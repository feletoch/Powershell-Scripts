. .\Variables.ps1

if(!(Test-Path -Path $minecraftJavaFolderPath -PathType Container)){
    Write-Output "$minecraftJavaFolderPath not found, exiting"
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
    if(!(Test-Path -Path $minecraftJavaFolderPath"\"$fileName)){
        #download the file
        [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
        Invoke-WebRequest $link -OutFile $minecraftJavaFolderPath"\"$fileName
        Write-Output "Download $link to $minecraftJavaFolderPath\$fileName complete"
        
        if((Test-Path -Path $minecraftJavaFolderPath"\"$fileName)){
           Set-Content (Join-Path -ChildPath "StartMinecraftServer.ps1" -Path $minecraftJavaFolderPath) "#http://www.minecraftforum.net/forums/archive/alpha/alpha-survival-multiplayer/823328-making-your-server-lag-less-by-tuning-java
           #https://www.minecraft.net/en-us/download/server/
           javaw -server -Xnoclassgc -Xmn512M -Xmx2048M -Xms1024M -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=4 -XX:+AggressiveOpts -jar $minecraftJavaFolderPath\$fileName nogui" -Encoding ASCII
           Write-Output "Modify StartMinecraftServer.ps1 with new server name: $fileName"
        }

    }else{
        Write-Output "$fileName exists in $minecraftJavaFolderPath, Nothing to do here."
    }
}

#https://github.com/feletoch/Powershell-Scripts/