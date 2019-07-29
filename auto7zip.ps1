if($args.Length -lt 1){
    Write-Output "Please enter the correct args (job output path[require], override output path, override output name)"
    exit
} 

$array = @()
foreach($arg in $args){
   $array += "$arg"
}
 
$Path,$outputPath,$outputname = $array
Write-Output "Input args:"
Write-Output "Path: $Path"
Write-Output "outputPath: $outputPath"
Write-Output "outputname: $outputname"

# Alias for 7-zip
if (-not (test-path "$env:ProgramFiles\7-Zip\7z.exe")) {
    Write-Output "$env:ProgramFiles\7-Zip\7z.exe needed" 
    Write-Output "Please download windows installation file here https://www.7-zip.org/download.html"
    exit
}
set-alias zip "$env:ProgramFiles\7-Zip\7z.exe"
 
#Check if the job path 
if(-not (Test-Path $path -PathType Container)){
    Write-Output "incorrect job path $path" 
    exit
}

#set the output file name
$name = Split-Path -Path $path -Leaf 
if(-not ($outputname)){$outputname = $name}

#if the override path don't exists, use the current path
if(([string]::IsNullOrEmpty($outputPath)) -or (-not (Test-Path $outputPath -PathType Container))){
    Write-Output "incorrect output path ($outputPath), set path to $PSScriptRoot"
    $outputPath = $PSScriptRoot    
}

#Create the final zip file name
$outputPathName = $outputPath+"\"+$outputname+".7z"

#remove zip item with the same name at the output folder
if(Test-Path $outputPathName){
    Write-Output "remove existing file $outputPathName"
    Remove-Item $outputPathName
}

#get the number of cpu thread
$thread = Get-WmiObject -Class win32_processor | Select-Object -ExpandProperty NumberOfLogicalProcessors

if(-not ($thread -match '^\d+$')){
    $thread = 1
}

#more info here: https://www.dotnetperls.com/7-zip-examples
Write-Output "compressing folder from $path to $outputPathName"
$7zipParameters = @("a", "-t7z", "-mx9", "-ms=on")

#add multithread to 7zip compression 
if(($thread) -gt 1){ 
    $7zipParameters += "-mmt"
}

Write-Output "compressing data with these parameters '$7zipParameters'"
zip $7zipParameters $outputPathName $path 
Write-Output "compression done"