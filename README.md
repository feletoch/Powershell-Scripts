# Powershell-Scripts
<b>Collection of my powershell scripts</b>

<b>Auto7zip.ps1</b><br/>
Automatically zip the folder to .7z using 7zip<br/>
usage: require installation of 7zip to %ProgramFiles%\7-Zip\7z.exe</br>
powershell.exe -executionpolicy bypass -file Auto7zip.ps1 C:\folder C:\backupfolder zipname<br/>
First arg required, the other 2 are optional

<b>FlacToAlac.ps1</b><br/>
Use ffmpeg and convert the current folder's flac files to alac files<br/>
Usercases: Transcode Flac to ALac for a ancient gadget call ipod classic that refused to have rockbox install<br/>
usage: required installation of ffmpeg to C:\ffmpeg\bin\ffmpeg.exe or in system path, update the script's <i>$outputPath</i> to change the output alac file

<b>StoreExternalIP.ps1</b><br/>
Store your external ipv4 to a txt file.<br/>
usecases: Share non-static IP by using service like onedrive, dropbox or google drive to sync the file and avoid using other DDNS service.
