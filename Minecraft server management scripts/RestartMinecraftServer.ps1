$minecraftJavaFolderPath = "D:\Minecraft_server"
$minecraftBedrockFolderPath = "D:\Minecraft_bedrock_server"
$minecraftSaveArchiveFolder = "D:\minecraft_backup"

$minecraftWorldSubfolderName = "world"
$minecraftBedrockWorldSubfolderName = "worlds"
$defaultDate = "12/07/2019"

#internal variables
$java = Get-Process java -ErrorAction SilentlyContinue
$javaw = Get-Process javaw -ErrorAction SilentlyContinue
$minecraftBedrock = Get-Process bedrock_server -ErrorAction SilentlyContinue
$hasMineCraftJavaWork = $false
$hasMineCraftBedrockwork = $false

function MinecraftJavaWorkLoad{
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
  if((Test-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath "MinecraftServerUpdate.ps1")-PathType Leaf)){
    powershell.exe -executionpolicy bypass -file "MinecraftServerUpdate.ps1" $minecraftJavaFolderPath
  }
  $Script:hasMineCraftJavaWork = $true
}

function MinecraftBedrockWorkload{
  if ($minecraftBedrock) {
    Write-Output "kill bedrock server window first"
    Write-Output "Close windows sucessful:" $minecraftBedrock.CloseMainWindow()
    
    Start-Sleep 10
    if (!$minecraftBedrock.HasExited) {
      $minecraftBedrock | Stop-Process -Force   
    }
    Write-Output "Force close bedrock server completed"
  }
  if((Test-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath "MinecraftBedrockServerUpdate.ps1")-PathType Leaf)){
    powershell.exe -executionpolicy bypass -file "MinecraftBedrockServerUpdate.ps1" $minecraftBedrockFolderPath
  }
  $Script:hasMineCraftBedrockwork = $true
}
if(![string]::IsNullOrEmpty($minecraftJavaFolderPath) -and (Test-Path -Path $minecraftJavaFolderPath -PathType Container)){
  MinecraftJavaWorkLoad
}
if(![string]::IsNullOrEmpty($minecraftBedrockFolderPath) -and (Test-Path -Path $minecraftBedrockFolderPath -PathType Container)){
  MinecraftBedrockWorkload
}

if(![string]::IsNullOrEmpty($minecraftSaveArchiveFolder) -and (Test-Path -Path $minecraftSaveArchiveFolder -PathType Container)){
  #backup every 2 weeks if schedule task is running weekly
  $date = [DateTime]::ParseExact($defaultDate, "dd/MM/yyyy", $null)
  if($date -eq $null){
    $date = (Get-Date).Add(15);
  }
  if((([math]::Abs([math]::Round(((Get-Date) - $date).day) / 14))%2) -eq 0){ 
      $backupScriptVariables = @()
      $minecraftJavaWorldPath = (Join-Path -Path $minecraftJavaFolderPath -ChildPath $minecraftWorldSubfolderName) 
      $minecraftBedrockWorldPath = (Join-Path -Path $minecraftBedrockFolderPath -ChildPath $minecraftBedrockWorldSubfolderName) 

      if($hasMineCraftJavaWork -and (Test-Path -Path $minecraftJavaWorldPath)){        
        $backupScriptVariables += $minecraftJavaWorldPath
      }else{
        $backupScriptVariables += ""
      }
      if($hasMineCraftJavaWork -and (Test-Path -Path $minecraftBedrockWorldPath)){        
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

if($hasMineCraftBedrockwork){
  Invoke-Item "$minecraftBedrockFolderPath\bedrock_server.exe"
}

if($hasMineCraftJavaWork -and (Test-Path -Path "$minecraftJavaFolderPath\StartMinecraftServer.ps1" -PathType Leaf)){
  Write-Output "Starting Minecraft java server via $minecraftJavaFolderPath\StartMinecraftServer.ps1"
  Set-Location $minecraftJavaFolderPath
  powershell.exe -executionpolicy bypass -file StartMinecraftServer.ps1
}

#https://github.com/feletoch/Powershell-Scripts/
