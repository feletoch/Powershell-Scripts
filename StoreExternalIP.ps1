$fileName = "ip.txt"
$fileLocations = @((Get-Content Env:\OneDrive), ([Environment]::GetFolderPath("Desktop")))

$currenttime = Get-Date 
$ipaddr = Invoke-RestMethod http://ipinfo.io/json | Select-Object -exp ip
foreach($location in $fileLocations){
    if((Test-Path -Path $location -PathType Container)){
        $outputItem = (Join-Path -Path $location -ChildPath $fileName)
        if(-not (Test-Path -Path $location\$fileName)){
            New-Item $outputItem -type file
        }
        (Write-Output $currenttime $ipaddr) | Out-File $outputItem
    }
}