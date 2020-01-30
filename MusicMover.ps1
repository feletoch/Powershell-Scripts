$downloadpath = "C:\Music"
$musicFolderPath = "D:\Music"
$completeTimer = 90

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $downloadpath
$watcher.Filter = "*.flac"
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true  

$action = { 
            #wait for file to finish downloading
            sleep $completeTimer
            $details = $event.SourceEventArgs
            $FullPath = $details.FullPath
            Move-Item $FullPath -Destination $musicFolderPath -Force   
          }    

Register-ObjectEvent $watcher "Created" -Action $action
while ($true) {sleep 60}
