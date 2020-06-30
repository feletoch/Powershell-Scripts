
. .\Variables.ps1

#internal variables
$java = Get-Process java -ErrorAction SilentlyContinue
$javaw = Get-Process javaw -ErrorAction SilentlyContinue
$minecraftBedrock = Get-Process bedrock_server -ErrorAction SilentlyContinue
$hasMineCraftJavaWork = $false
$hasMineCraftBedrockwork = $false

function MinecraftJavaWorkLoad{
  #kill all the java and javaw, there might be a better way of doing this
  if($java -Or $javaw){
    if ($java) {
      Write-Output "kill java window first"
      Write-Output "Close windows sucessful:" $java.CloseMainWindow() 
      
      Start-Sleep 10
      if (!$java.HasExited) {
        $java | Stop-Process -Force
      }
      Write-Output "Force close Java completed"
    }
    if ($javaw) {
      Write-Output "closing javaw window first"
      Write-Output "Close windows sucessful:" $javaw.CloseMainWindow()
      
      Start-Sleep 10
      if (!$javaw.HasExited) {
        $javaw | Stop-Process -Force
      }  
      Write-Output "Force close Javaw completed"
    }
    #Run the Update script
    if((Test-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath "MinecraftServerUpdate.ps1")-PathType Leaf)){
      powershell.exe -executionpolicy bypass -file "MinecraftServerUpdate.ps1"
    }
    #Set the local variable
    $Script:hasMineCraftJavaWork = $true
  }
}

function MinecraftBedrockWorkload{
  # kill the bedrock excutable server
  if ($minecraftBedrock) {
    Write-Output "kill bedrock server window first"
    Write-Output "Close windows sucessful:" $minecraftBedrock.CloseMainWindow()
    
    Start-Sleep 60
    if (!$minecraftBedrock.HasExited) {
      $minecraftBedrock | Stop-Process -Force   
    }
    Write-Output "Force close bedrock server completed"
    
    #Run the Update script
    if((Test-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath "MinecraftBedrockServerUpdate.ps1")-PathType Leaf)){
      powershell.exe -executionpolicy bypass -file "MinecraftBedrockServerUpdate.ps1"
    }
    #Set the local variable
    $Script:hasMineCraftBedrockwork = $true
  }
}

#Start the task
if(![string]::IsNullOrEmpty($minecraftJavaFolderPath) -and (Test-Path -Path $minecraftJavaFolderPath -PathType Container)){
  MinecraftJavaWorkLoad
}
if(![string]::IsNullOrEmpty($minecraftBedrockFolderPath) -and (Test-Path -Path $minecraftBedrockFolderPath -PathType Container)){
  MinecraftBedrockWorkload
}

#backup the world files
if(![string]::IsNullOrEmpty($minecraftSaveArchiveFolder) -and (Test-Path -Path $minecraftSaveArchiveFolder -PathType Container)){
  #default backup every 2 weeks if schedule task is running weekly, supporting weekly for now
  $date = [DateTime]::ParseExact($defaultDate, "dd/MM/yyyy", $null)
  if($date -eq $null){
    $date = (Get-Date).Add(15);
  }
  #change the / will change the frequency of the backup
  if((([math]::Abs([math]::Round(((Get-Date) - $date).day) / 14))%2) -eq 0){ 
      $backupScriptVariables = @()
      $minecraftJavaWorldPath = (Join-Path -Path $minecraftJavaFolderPath -ChildPath $minecraftWorldSubfolderName) 
      $minecraftBedrockWorldPath = (Join-Path -Path $minecraftBedrockFolderPath -ChildPath $minecraftBedrockWorldSubfolderName) 

      if($hasMineCraftJavaWork -and (Test-Path -Path $minecraftJavaWorldPath)){
        $backupScriptVariables += $minecraftJavaWorldPath
      }else{
        $backupScriptVariables += ""
      }
      if($hasMineCraftBedrockwork -and (Test-Path -Path $minecraftBedrockWorldPath)){
        $backupScriptVariables += $minecraftBedrockWorldPath
      }else{
        $backupScriptVariables += ""
      }
      Write-Output "Backup save by running MinecraftSaveBackup.ps1 $backupScriptVariables $minecraftSaveArchiveFolder"
      powershell.exe -executionpolicy bypass -file MinecraftSaveBackup.ps1 $backupScriptVariables $minecraftSaveArchiveFolder
  }else{
      Write-Output "Skip backup"
  }
}

#start servers
 if($hasMineCraftBedrockwork){
   Invoke-Item "$minecraftBedrockFolderPath\bedrock_server.exe"
 }

if($hasMineCraftJavaWork -and (Test-Path -Path "$minecraftJavaFolderPath\StartMinecraftServer.ps1" -PathType Leaf)){
  Write-Output "Starting Minecraft java server via $minecraftJavaFolderPath\StartMinecraftServer.ps1"
  Set-Location $minecraftJavaFolderPath
  powershell.exe -executionpolicy bypass -file StartMinecraftServer.ps1
}


#https://github.com/feletoch/Powershell-Scripts/
