if(-not($args.Length -eq 1)){
    Write-Output "Please enter the correct args (minecraft server folder path)"
    exit
} 
$filePath = $args

if(!(Test-Path -Path $filePath -PathType Container)){
    Write-Output "$filePath not found, exiting"
    exit
}

$url = "https://www.minecraft.net/en-us/download/server/"
$jarUrlFormat = "https://launcher.mojang.com/v1/objects/*.jar"

$hrefProp = ((Invoke-WebRequest –Uri $url).Links | Where-Object {$_.href -like $jarUrlFormat} | Where-Object innerText -like "minecraft_server*.jar" )
Write-Output $bedrockHrefProp
$link = $hrefProp.href
Write-Output "Found server link: $link"
$fileName = $hrefProp.innerText

#make sure link exists and file name matches
if((-not ([string]::IsNullOrEmpty($link)) -or (-not ([string]::IsNullOrEmpty($fileName))))){
    if(!(Test-Path -Path $filePath"\"$fileName)){
        #download the file
        [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
        Invoke-WebRequest $link -OutFile $filePath"\"$fileName
        Write-Output "Download $link to $filePath\$fileName complete"
        
        if((Test-Path -Path $filePath"\"$fileName)){
           Set-Content (Join-Path -ChildPath "StartMinecraftServer.ps1" -Path $filePath) "java -Xmx1024M -Xms1024M -jar  $filePath\$fileName nogui" -Encoding ASCII
           Write-Output "Modify StartMinecraftServer.ps1 with new server name: $fileName"
        }

    }else{
        Write-Output "$fileName exists in $filePath, Nothing to do here."
    }
}

#https://github.com/feletoch/Powershell-Scripts/