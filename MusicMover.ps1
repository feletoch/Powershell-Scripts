. .\Variables.ps1

#Thanks to
#https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/using-filesystemwatcher-correctly-part-2
        
    function Move-File(
        [Parameter(Mandatory = $true)] [string] $path
    )
    {
        if((Get-Date).AddMinutes(-5) -gt (Get-item $path).LastWriteTime){
            Write-Host "Moving $path" -ForegroundColor DarkYellow
            Copy-Item $path -Destination $musicFolderPath
            Move-Item $path -Destination $syncPath -Force
        }
    }

### SET FOLDER TO WATCH + FILES TO WATCH + SUBFOLDERS YES/NO
    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = $downloadpath
    $watcher.Filter = $FileType
    $watcher.IncludeSubdirectories = $true
    $watcher.EnableRaisingEvents = $true  

### DEFINE ACTIONS AFTER AN EVENT IS DETECTED
    $action = {     
                $details = $event.SourceEventArgs
                $FullPath = $details.FullPath
                Write-Host "File Created: $FullPath" -ForegroundColor DarkGreen
                sleep $completeTimer
                Move-File -path $FullPath
              }    
### DECIDE WHICH EVENTS SHOULD BE WATCHED 
    Register-ObjectEvent $watcher "Created" -Action $action ## "Changed" "Deleted" "Renamed"

    #Make a loop for existing files
    while ($true) {
        sleep 60
        #5 minute last write time will stop moving imcomplete files, hopefully
        (Get-ChildItem $downloadpath -Filter $FileType | ? {(Get-Date).AddMinutes(-5) -gt $_.LastWriteTime }) | 
        Foreach-Object  {
            Write-Host "Found previous file: $_" -ForegroundColor DarkGreen
            Move-File -path $_.FullName
        }
    }

#https://github.com/feletoch/Powershell-Scripts/
