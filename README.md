# Powershell-Scripts
<b>Collection of my powershell scripts</b>

<b>Auto7zip.ps1</b><br/>
Automatically zip the folder to .7z using 7zip<br/>
usage: require installation of 7zip to %ProgramFiles%\7-Zip\7z.exe<br/>
powershell.exe -executionpolicy bypass -file Auto7zip.ps1 C:\folder C:\backupfolder zipname<br/>
First arg required, the other 2 are optional

<b>FlacToAlac.ps1</b><br/>
Use ffmpeg and convert the current folder's flac files to alac files<br/>
Usercases: Transcode Flac to ALac for a ancient gadget call ipod classic that refused to have rockbox install<br/>
usage: required installation of ffmpeg to C:\ffmpeg\bin\ffmpeg.exe or in system path, update the script's <i>$outputPath</i> to change the output alac file

<b>StoreExternalIP.ps1</b><br/>
Store your external ipv4 to a txt file.<br/>
Usecases: Share non-static IP by using service like onedrive, dropbox or google drive to sync the file and avoid using other DDNS service.

<b>MusicMover.ps1</b><br/>
Move Music from download folder to designated location.<br/>
Usercases: Auto trigger when pre-defined file extension in location is created, wait for pre-determined interval and move file to designated folder 

<hr/>
<b>RestartMinecraftServer.ps1</b><br/>
Streamline stop, update, backup and restart the bedrock and java servers<br/>
Usecases: Create scheduled tasks to automaticlly restart the servers<br/>
Usage: Require update the path for both servers<br/>
<ol><li>Kill the <i>Java, Javaw</i> and <i>bedrock_server.exe</i></li>
<li>Run the <b>MinecraftServerUpdate.ps1</b> and <b>MinecraftBedrockServerUpdate.ps1</b> if the script exist in same folder</li>
<li>Copy the world data to a temp folder and compress it. Uses <b>Auto7zip.ps1</b> if it exist in same folder, otherwise it uses the Windows default zip. <br/>the backup logic will do it every odd weeks if it has Scheduled task to run it every week.</li>
<li>Restart the servers</li>
</ol>

<b>MinecraftServerUpdate.ps1</b><br/>
Scrape the link and download the server <br/>
Usage: Require the path of the java server, create <b>MinecraftServerUpdate.ps1</b> afterwards which can be use to start the server.<br/> To do: change script and move it to the $PSScripts folder

<b>MinecraftBedrockServerUpdate.ps1</b><br/>
Scrape the link and download the server <br/>
Usage: Require the path of the bedrock server. Unzip of the zip file will override all the setting file except the server.properties.<br/> To do: add a array to restore the other settings, not really important.

<b>MinecraftSaveBackup.ps1</b><br/>
Backup the server world as a .7z or zip file<br/>
Usage: Require either or both path of the java server and bedrock server, the archive folder is optional. The script will use <b>Auto7zip.ps1</b> is it exists in the same folder, if is not found, it would use the default zipping method.

