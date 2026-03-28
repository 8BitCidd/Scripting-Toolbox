# This script is just another verion of the File_Name_Export script.
# This one was created when trying to convert a large amount of PS1 bin/cue files in to CHD format.

# ====== CONFIG ======
$SourceDir = "H:\LaunchBox\Games\Sony Playstation"
$OutputFile = "H:\LaunchBox\Games\Sony Playstation\folder_list.txt"
# ====================

Get-ChildItem -Path $SourceDir -Directory |
    Select-Object -ExpandProperty Name |
    Sort-Object |
    Out-File -FilePath $OutputFile -Encoding UTF8

Write-Host "Folder names exported to $OutputFile" -ForegroundColor Green
