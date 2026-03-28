# ====== CONFIG ======
$SourceDir = "H:\LaunchBox\Games\Sony Playstation 2"
$OutputDir = "H:\LaunchBox\Games\Sony Playstation 2\_CHD"
$Chdman    = "H:\LaunchBox\Games\Sony Playstation 2\_CHD\chdman.exe"
$FailureLog = Join-Path $OutputDir "chd_failures.txt"
# ====================

$Failures = @()

# Ensure output base directory exists
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

# Recursively find all CUE files
$cueFiles = Get-ChildItem -Path $SourceDir -Recurse -Filter *.cue

foreach ($cue in $cueFiles) {

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

    # Build process info
    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName               = $Chdman
    $startInfo.Arguments              = "createcd -i `"$($cue.FullName)`" -o `"$outputFile`""
    $startInfo.UseShellExecute        = $false
    $startInfo.CreateNoWindow         = $true
    $startInfo.RedirectStandardOutput = $true
    $startInfo.RedirectStandardError  = $true

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $startInfo
    $process.Start() | Out-Null

    $stdout = $process.StandardOutput.ReadToEnd()
    $stderr = $process.StandardError.ReadToEnd()

    $process.WaitForExit()

    if ($process.ExitCode -eq 0) {
        Write-Host "Success: $outputFile" -ForegroundColor Green
    }
    else {
        Write-Host "FAILED: $($cue.FullName)" -ForegroundColor Red

        $Failures += [PSCustomObject]@{
            File     = $cue.FullName
            ExitCode = $process.ExitCode
            Error    = if ($stderr) { $stderr.Trim() } else { "Unknown error" }
        }
    }
}

Write-Host "`nAll recursive conversions complete." -ForegroundColor Magenta

# ====== FAILURE SUMMARY ======
if ($Failures.Count -gt 0) {
    Write-Host "`nThe following files FAILED to convert:" -ForegroundColor Red

    foreach ($f in $Failures) {
        Write-Host "`nFile: $($f.File)" -ForegroundColor Red
        Write-Host "ExitCode: $($f.ExitCode)" -ForegroundColor DarkRed
        Write-Host "Reason: $($f.Error)" -ForegroundColor DarkYellow
    }

    # Save failure log
    $Failures | ForEach-Object {
        "File: $($_.File)`nExitCode: $($_.ExitCode)`nReason: $($_.Error)`n"
    } | Out-File -FilePath $FailureLog -Encoding UTF8

    Write-Host "`nFailure log saved to: $FailureLog" -ForegroundColor Yellow
}
else {
    Write-Host "`nNo failures detected 🎉" -ForegroundColor Green
}
