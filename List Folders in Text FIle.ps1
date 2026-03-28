# ====== CONFIG ======
$SourceDir = "H:\LaunchBox\Games\Sony Playstation"
$OutputFile = "H:\LaunchBox\Games\Sony Playstation\folder_list.txt"
# ====================

Get-ChildItem -Path $SourceDir -Directory |
    Select-Object -ExpandProperty Name |
    Sort-Object |
    Out-File -FilePath $OutputFile -Encoding UTF8

Write-Host "Folder names exported to $OutputFile" -ForegroundColor Green
