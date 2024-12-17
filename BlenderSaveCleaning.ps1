# This script gets the blender .blendX files and remove them
# Author : TLR

param (
    [string]$folder = "",
    [string]$force = ""
)

function GetFilesToDeleteRecursive([string]$path) {
    $ret = @()
    $files = Get-ChildItem -Path $folder -Recurse | Where-Object {$_.Name -match ".+\.blend[0-9]+$"}
    #Write-Output("File count : {0}" -f($files.count))
    for ($i = 0; $i -lt $files.Count; $i++) {
        $ret += $files[$i].FullName
    }
    return $ret
}

function DisplayFiles([string[]]$files) {
    foreach ($file in $files) {
        Write-Output $file
    }
}

function DeleteFiles([string[]]$files) {
    foreach ($file in $files) {
        Remove-Item -Path $file -Force
    }
}

# Test the path
if(!(Test-Path -Path $folder)) {
    Write-Output "path not found"
    Write-Output( "Usage : .\{0} <path to folder to be cleaned> <force>" -f ($MyInvocation.MyCommand.Name) )
    return
}

[string[]]$toDelete = GetFilesToDeleteRecursive $folder
$space = 0;

#Get the size of all files
foreach($file in $toDelete) {
    $f = Get-Item($file)
    $space += $f.Length / 1024 / 1024
}

if($toDelete.count -le 0) {
    Write-Output "No .blendX files found"
    return
}

Write-Output("Files found : {0}`nTotal size : {1}MB" -f($toDelete.count, [math]::round($space, 2)))

if($force -ne "force") {
    $showFiles = Read-Host "Do you want to see the files to be deleted ? Y/n"
    if ($showFiles -ne 'n') {
        DisplayFiles($toDelete)
    }
    
    $shouldDelete = Read-Host "Delete the files ? y/N"
    if ($shouldDelete -eq 'y') {
        DeleteFiles($toDelete)
        Write-Output "Files deleted"
    }
    else {
        Write-Output "Files not deleted"
    }
}
else {
    DeleteFiles($toDelete)
    Write-Output "Files deleted"
}

