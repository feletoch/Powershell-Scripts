if(-not($args.Length -eq 1)){
    Write-Output "Please enter the correct args (minecraft server folder path)"
    exit
} 
$bedrockFilePath = $args

if(!(Test-Path -Path $bedrockFilePath -PathType Container)){
    Write-Output "$bedrockFilePath not fond, exiting"
    exit
}

$bedrockUrl = "https://www.minecraft.net/en-us/download/server/bedrock/"
$bedrockzipUrlFormat = "https://minecraft.azureedge.net/bin-win/"
$BedrockRegexPattern = "(bedrock-server(\-|\d|.)*\.zip)"
$BedrockServerPropertiesName = "server.properties"

$bedrockHrefProp = ((Invoke-WebRequest –Uri $bedrockUrl).Links | Where-Object {$_.href -like $bedrockzipUrlFormat+"*.zip"} | Where-Object data-platform -eq "serverBedrockWindows")
Write-Output $bedrockHrefProp
$link = $bedrockHrefProp.href
Write-Output "Found server link: $link"

#make sure link exists
if(-not ([string]::IsNullOrEmpty($link))){

    #https://techtalk.gfi.com/windows-powershell-extracting-strings-using-regular-expressions/
    $bedrockFileName = ($link | Select-String -Pattern $BedrockRegexPattern -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value } )
    if(!(Test-Path -Path $bedrockFilePath"\"$bedrockFileName)){
        #download the file
        [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
        Invoke-WebRequest $link -OutFile $bedrockFilePath"\"$bedrockFileName
        Write-Output "Download $link to $bedrockFilePath\$bedrockFileName complete"
        
        if((Test-Path -Path $bedrockFilePath"\"$bedrockFileName)){
            #change server.properties file name
            if(Test-Path -path $bedrockFilePath"\"$BedrockServerPropertiesName -PathType leaf){
                Rename-Item -Path $bedrockFilePath"\"$BedrockServerPropertiesName -NewName "backup-$BedrockServerPropertiesName"
            }
            #Extract files
            Expand-Archive -Path "$bedrockFilePath\$bedrockFileName" -DestinationPath "$bedrockFilePath" -Force
            Write-Output "Extract files from $bedrockFilePath\$bedrockFileName to $bedrockFilePath complete"
            #delete server.properties file the nrename the backup
            if(Test-Path -path $bedrockFilePath"\"$BedrockServerPropertiesName -PathType leaf){
                Remove-Item -Path "$bedrockFilePath\$BedrockServerPropertiesName"             
            }
            if(Test-Path -path $bedrockFilePath"\backup-"$BedrockServerPropertiesName -PathType leaf){
                Rename-Item -Path "$bedrockFilePath\backup-$BedrockServerPropertiesName"  -NewName "$BedrockServerPropertiesName"
            }
        }

    }else{
        Write-Output "$bedrockFileName exists in $bedrockFilePath, Nothing to do here."
    }
}

#https://github.com/feletoch/Powershell-Scripts/