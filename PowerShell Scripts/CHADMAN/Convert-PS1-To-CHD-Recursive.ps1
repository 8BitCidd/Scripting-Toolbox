# This script was created to autmate the process of converting PS1 bin/cue files into a CHD file.
 
# ====== CONFIG ======
$SourceDir = "H:\LaunchBox\Games\Sony Playstation"
$OutputDir = "H:\LaunchBox\Games\Sony Playstation\_CHD"
$Chdman    = "H:\LaunchBox\Games\Sony Playstation\_CHD\chdman.exe"
# ====================

# Track failures
$Failures = @()

# Ensure output base directory exists
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

# Recursively find all CUE files
$cueFiles = Get-ChildItem -Path $SourceDir -Recurse -Filter *.cue

foreach ($cue in $cueFiles) {

    # Preserve relative folder structure
    $relativePath = $cue.Directory.FullName.Substring($SourceDir.Length).TrimStart('\')
    $targetDir    = Join-Path $OutputDir $relativePath

    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir | Out-Null
    }

    $outputFile = Join-Path $targetDir ($cue.BaseName + ".chd")

    if (Test-Path $outputFile) {
        Write-Host "Skipping (exists): $($cue.FullName)" -ForegroundColor Yellow
        continue
    }

    Write-Host "Converting: $($cue.FullName)" -ForegroundColor Cyan

    # Start chdman minimized
    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName        = $Chdman
    $startInfo.Arguments       = "createcd -i `"$($cue.FullName)`" -o `"$outputFile`""
    $startInfo.UseShellExecute = $true
    $startInfo.WindowStyle     = [System.Diagnostics.ProcessWindowStyle]::Minimized

    $process = [System.Diagnostics.Process]::Start($startInfo)
    $process.WaitForExit()

    if ($process.ExitCode -eq 0) {
        Write-Host "Success: $outputFile" -ForegroundColor Green
    }
    else {
        Write-Host "FAILED: $($cue.FullName)" -ForegroundColor Red
        $Failures += $cue.FullName
    }
}

Write-Host "`nAll recursive conversions complete." -ForegroundColor Magenta

# ====== FAILURE SUMMARY ======
if ($Failures.Count -gt 0) {
    Write-Host "`nThe following files FAILED to convert:" -ForegroundColor Red
    $Failures | ForEach-Object { Write-Host $_ -ForegroundColor Red }
}
else {
    Write-Host "`nNo failures detected 🎉" -ForegroundColor Green
}
