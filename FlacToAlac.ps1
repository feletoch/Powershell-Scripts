$ffmpegPath = "C:\ffmpeg\bin\"
$ffmpegExcutable = "ffmpeg.exe"
$outputpath = 

function CreatOutputPath {
    $script:outputpath = $PSScriptRoot+"\alac\"
    if(-not (Test-Path -Path $outputpath -PathType Container)){
        New-Item -Path $outputpath -ItemType Directory
    }
}
function Transcode {
    if([string]::IsNullOrEmpty($outputpath)){
        Write-Output "No output path define"
        CreatOutputPath
    }else{
        if(-not (Test-Path -Path $outputpath -PathType Container)){
            CreatOutputPath
        }
    }
    Write-Output "Output location $outputpath"
    Get-ChildItem -recurse -include *.flac | ForEach-Object{
        ffmpeg -i $_.FullName -acodec alac ($outputpath+"\"+$_.BaseName+'.m4a')
    }
}

if(-not (Test-Path -Path $ffmpegPath$ffmpegExcutable -PathType Leaf)){
    Write-Output "Cannot find $ffmpegPath$ffmpegExcutable, do not have it install? Download it here:"
    Write-Output "https://ffmpeg.zeranoe.com/builds/"
    $confirmation = Read-Host "ffmpeg exists in environment variable? press y to proceed"
    if ($confirmation -eq 'y') {
        Set-Alias ffmpeg $ffmpegExcutable
        Transcode
    }
}else{
    Set-Alias ffmpeg $ffmpegPath$ffmpegExcutable
    Transcode
}

#https://github.com/feletoch/Powershell-Scripts/