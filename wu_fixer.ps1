## Arthur Vaccario - Windows Update Fixer v1.0 
## Last update 04/08/2024 (Initial) Development
# Function to prompt for continue or quit
function Prompt-ContinueOrQuit {
    param([string]$message)
    Write-Host $message -ForegroundColor Yellow
    Write-Host "Press Enter to continue, Space bar to skip, or 'q' to quit." -ForegroundColor Green

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
Prompt-ContinueOrQuit "Press Enter to run the Windows Update Troubleshooter, Spacebar to skip or 'q' to quit."
msdt.exe /id WindowsUpdateDiagnostic


Prompt-ContinueOrQuit "Press Enter to Stop Windows Update Services, Spacebar to skip or 'q' to quit."
# Stopping services
Stop-Service -Name wuauserv -Force
Stop-Service -Name cryptSvc -Force
Stop-Service -Name bits -Force
Stop-Service -Name msiserver -Force
Prompt-ContinueOrQuit "Services Stopped. Press Enter to Rename SoftwareDistribution Directory, Spacebar to skip or 'q' to quit."

# Renaming the SoftwareDistribution folder
Rename-Item -Path C:\Windows\SoftwareDistribution -NewName SoftwareDistribution.old
Prompt-ContinueOrQuit "SoftwareDistribution folder renamed. Press Enter to Re-start Services, Spacebar to skip or 'q' to quit."

# Starting services
Start-Service -Name wuauserv
Start-Service -Name cryptSvc
Start-Service -Name bits
Start-Service -Name msiserver
Prompt-ContinueOrQuit "Services started. Press Enter to Run System File Checker, Spacebar to skip or 'q' to quit."

# Running system file checker
sfc /scannow
Prompt-ContinueOrQuit "System File Checker Complete. Press Enter to Run The Deployment Image Servicing and Management Tool (DISM), Spacebar to skip or 'q' to quit."
# Running DISM tool to repair Windows image
DISM /Online /Cleanup-Image /RestoreHealth

