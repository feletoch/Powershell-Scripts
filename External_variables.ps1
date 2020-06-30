# mincraft variables
$Global:minecraftJavaFolderPath = "C:\Minecraft_server"
$Global:minecraftBedrockFolderPath = "C:\Minecraft_bedrock_server"
$Global:minecraftSaveArchiveFolder = "C:\Backups\minecraft_saves"

$Global:minecraftWorldSubfolderName = "world"
$Global:minecraftBedrockWorldSubfolderName = "worlds"
$Global:defaultDate = "12/07/2019"

#Store Ip script variables
$Global:fileName = "ip.txt"
$Global:fileLocations = @((Get-Content Env:\OneDrive), ([Environment]::GetFolderPath("Desktop")))

#Flac to Alac script variables
$Global:ffmpegPath = "C:\ffmpeg\bin\"
$Global:ffmpegExcutable = "ffmpeg.exe"
$Global:outputpath = ""