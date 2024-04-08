## Arthur Vaccario - Windows Update Fixer v1.4
 ## Last update 04/08/2024 (Initial) Development
##

# Function to prompt for continue or quit
function Prompt-ContinueOrQuit {
    param([string]$message)
    Write-Host $message -ForegroundColor Green
    Write-Host "Press Enter to continue, Space bar to skip, or 'q' to quit." -ForegroundColor Yellow

    do {
        $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        switch ($key.VirtualKeyCode) {
            0x20 { Write-Host "Skipping..." -ForegroundColor Cyan; return $true }
            0x51 { Write-Host "Quitting the script..." -ForegroundColor Red; exit }
            0x0D { return $false }
            default { Write-Host "Invalid key. Please press Enter, Space bar, or 'q'." -ForegroundColor Red }
        }
    } while ($true)
}

clear # Clear screen

# Begin
if (Prompt-ContinueOrQuit "This Script Must be run in an elevated (admin) PowerShell script. Press 'q' if you are not an admin.") { return }

# Run the Windows Update troubleshooter
if (-not (Prompt-ContinueOrQuit "Run Windows Update Troubleshooter?")) { msdt.exe /id WindowsUpdateDiagnostic }

# Stopping services
if (-not (Prompt-ContinueOrQuit "Stop Windows Update Services?")) {
    Stop-Service -Name wuauserv -Force
    Stop-Service -Name cryptSvc -Force
    Stop-Service -Name bits -Force
    Stop-Service -Name msiserver -Force
}

# Renaming the SoftwareDistribution folder
if (-not (Prompt-ContinueOrQuit "Rename SoftwareDistribution Directory?")) {
    Rename-Item -Path C:\Windows\SoftwareDistribution -NewName SoftwareDistribution.old
}

# Starting services
if (-not (Prompt-ContinueOrQuit "Re-start Windows Update Services?")) {
    Start-Service -Name wuauserv
    Start-Service -Name cryptSvc
    Start-Service -Name bits
    Start-Service -Name msiserver
}

# Running system file checker
if (-not (Prompt-ContinueOrQuit "Run System File Checker"))) {
    sfc /scannow
}

# Running DISM tool to repair Windows image
if (-not (Prompt-ContinueOrQuit "Run The Deployment Image Servicing and Management Tool (DISM)"))) {
    DISM /Online /Cleanup-Image /RestoreHealth
}
#end

