$array = @()
if($args.Length -lt 2){
    Write-Output "Missing the args (java version world path(can be """"), Bedrock version world path(can be """"), compress folder path(optional)), using folder path variable"
    . .\Variables.ps1
    $array += if(![string]::IsNullOrEmpty($minecraftJavaFolderPath) -and ![string]::IsNullOrEmpty($minecraftWorldSubfolderName)){(Join-Path -Path $minecraftJavaFolderPath -ChildPath $minecraftWorldSubfolderName)}else{""}
    $array += if(![string]::IsNullOrEmpty($minecraftBedrockFolderPath) -and ![string]::IsNullOrEmpty($minecraftBedrockWorldSubfolderName)){(Join-Path -Path $minecraftBedrockFolderPath -ChildPath $minecraftBedrockWorldSubfolderName)}else{""}
    $array += $minecraftSaveArchiveFolder
} else{
    foreach($arg in $args){
    $array += "$arg"
    }
}
 
$mincraftWorldPath,$minecraftBedrockWorldPath,$archivedFolderPath = $array

#internal variables
$compressArchiveTempFolderName = (Get-Date).ToString("yyyyMMdd")
$javaTempSaveFolder = "javaEdition"
$bedrockSaveFolder = "bedrockEdition"
 
#create temp folder for compression
Set-Location $PSScriptRoot
if(!(Test-Path -Path $compressArchiveTempFolderName -PathType Container)){
    New-Item -Name $compressArchiveTempFolderName -ItemType directory
    Write-Output "Create temp folder $compressArchiveTempFolderName"
}
#create sub folder for java version and copy the world
if(![string]::IsNullOrEmpty($mincraftWorldPath) -and (Test-Path -Path $mincraftWorldPath -PathType Container)){
    if((!(Test-Path -Path $compressArchiveTempFolderName"\"$javaTempSaveFolder -PathType Container))){
        New-Item -Name $compressArchiveTempFolderName"\"$javaTempSaveFolder -ItemType directory
    }
    #copy the save data to the newly created temp folder
    Copy-Item $mincraftWorldPath -destination $PSScriptRoot"\"$compressArchiveTempFolderName"\"$javaTempSaveFolder -recurse -force
    Write-Output "Copy files from $mincraftWorldPath to $PSScriptRoot\$compressArchiveTempFolderName\$javaTempSaveFolder completed"
}

#create sub folder for bedrock version and copy the world
if(![string]::IsNullOrEmpty($minecraftBedrockWorldPath) -and (Test-Path -Path $minecraftBedrockWorldPath -PathType Container)){
    if((!(Test-Path -Path $compressArchiveTempFolderName"\"$bedrockSaveFolder -PathType Container))){
        New-Item -Name $compressArchiveTempFolderName"\"$bedrockSaveFolder -ItemType directory
    }
    #copy the save data to the newly created temp folder
    Copy-Item $minecraftBedrockWorldPath -destination $PSScriptRoot"\"$compressArchiveTempFolderName"\"$bedrockSaveFolder -recurse -force
    Write-Output "Copy files from $minecraftBedrockWorldPath to $PSScriptRoot\$compressArchiveTempFolderName\$bedrockSaveFolder completed"
}

#create a readme text file
if(!(Test-Path -Path $PSScriptRoot"\"$compressArchiveTempFolderName"\"readme.txt -PathType Leaf)){
    New-Item $PSScriptRoot"\"$compressArchiveTempFolderName"\"readme.txt -type file
    Write-Output "Create $PSScriptRoo\$compressArchiveTempFolderName\readme.txt completed"
}

#create a directory in root when archive folder path is not specified
if([string]::IsNullOrEmpty($archivedFolderPath) -or !(Test-Path -Path $archivedFolderPath -PathType Container)){
    $Script:archivedFolderPath = $PSScriptRoot+"\Archived_Saves"
}

if((!(Test-Path -Path $archivedFolderPath -PathType Container))){
    $folderName = Split-Path -Path $archivedFolderPath -Leaf
    $parentPath = Split-Path -Path $archivedFolderPath -Parent
    if((Test-Path -Path $parentPath -PathType Container)){
        Set-Location $parentPath
        New-Item -Name $folderName -ItemType directory
        Set-Location $PSScriptRoot
    }else{
        New-Item -Name $folderName -ItemType directory
        $Script:archivedFolderPath = $PSScriptRoot+"\"+$folderName
    }  
    Write-Output "Create a backup folder for compressed files at $archivedFolderPath"
}

if(Test-Path -Path $PSScriptRoot"\Auto7zip.ps1" -PathType Leaf){
    #zip the temp folder using 7zip
    Write-Output "Loading 7zip compression script"
    powershell.exe -executionpolicy bypass -file Auto7zip.ps1 $PSScriptRoot"\"$compressArchiveTempFolderName $archivedFolderPath
}else{
    Compress-Archive -Path $PSScriptRoot"\"$compressArchiveTempFolderName -DestinationPath $archivedFolderPath"\"$compressArchiveTempFolderName -Force
}

#clean up copy over saves
Remove-Item $compressArchiveTempFolderName -Force -Recurse

#https://github.com/feletoch/Powershell-Scripts/
