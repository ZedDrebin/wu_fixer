## Arthur Vaccario - Windows Update Fixer v1.2 
## Last update 04/08/2024 (Initial) Development

# Function to prompt for continue or quit
function Prompt-ContinueOrQuit {
    param([string]$message)
    Write-Host $message -ForegroundColor Green
    Write-Host "Press Enter to continue, Space bar to skip, or 'q' to quit." -ForegroundColor Yellow
 
    # Wait for key press
    $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

    switch ($key.VirtualKeyCode) {
        # Space bar
        32 { Write-Host "Skipping..." -ForegroundColor Cyan }
        # 'Q' key
        81 { Write-Host "Quitting the script..." -ForegroundColor Red; exit }
        # Enter
        13 { }
        default { Write-Host "Invalid key. Please press Enter, Space bar, or 'q'." -ForegroundColor Red; Prompt-ContinueOrQuit $message }
    }
}
# Run the Windows Update troubleshooter
Prompt-ContinueOrQuit "Windows Update Troubleshooter"
msdt.exe /id WindowsUpdateDiagnostic


# Stopping services
Prompt-ContinueOrQuit "Windows Update Services"
Stop-Service -Name wuauserv -Force
Stop-Service -Name cryptSvc -Force
Stop-Service -Name bits -Force
Stop-Service -Name msiserver -Force
Prompt-ContinueOrQuit "Rename SoftwareDistribution Directory"

# Renaming the SoftwareDistribution folder
Rename-Item -Path C:\Windows\SoftwareDistribution -NewName SoftwareDistribution.old
Prompt-ContinueOrQuit "Re-start Services"

# Starting services
Start-Service -Name wuauserv
Start-Service -Name cryptSvc
Start-Service -Name bits
Start-Service -Name msiserver

# Running system file checker
Prompt-ContinueOrQuit "Run System File Checker"
sfc /scannow

# Running DISM tool to repair Windows image
Prompt-ContinueOrQuit "Run The Deployment Image Servicing and Management Tool (DISM)"
DISM /Online /Cleanup-Image /RestoreHealth
#end
