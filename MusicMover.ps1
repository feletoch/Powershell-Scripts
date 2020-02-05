$downloadpath = "C:\Music"
$musicFolderPath = "D:\Music"
$completeTimer = 90
$fileType = "*.flac"
    
function Move-File(
[Parameter(Mandatory = $true)] [string] $path
)
{
            Move-Item $path -Destination $musicFolderPath -Force 
}

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $downloadpath
$watcher.Filter = $fileType
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true  

$action = { 
            #wait for file to finish downloading
            sleep $completeTimer
            $details = $event.SourceEventArgs
            $FullPath = $details.FullPath
            Move-File -path $FullPath
          }    

Register-ObjectEvent $watcher "Created" -Action $action
while ($true) {
            sleep 60
            (Get-ChildItem $downloadpath -Filter $fileType | ? {$_.LastWriteTime -lt (Get-Date).AddMinutes(-10)}) | 
            Foreach-Object  {
                        Move-File -path $_.FullName
            }
}
