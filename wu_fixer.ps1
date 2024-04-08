## Arthur Vaccario - Windows Update Fixer v1.3
## Last update 04/08/2024 (Initial) Development
##
# Function to prompt for continue or quit
function Prompt-ContinueOrQuit {
    param([string]$message)
    Write-Host $message -ForegroundColor Green
    Write-Host "Press Enter to continue, Space bar to skip, or 'q' to quit." -ForegroundColor Yellow
 
    # Wait for key press
    $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

    switch ($key.VirtualKeyCode) {
        # Space bar
        0x20 { Write-Host "Skipping..." -ForegroundColor Cyan }
        # 'q' key
        0x51 { Write-Host "Quitting the script..." -ForegroundColor Red; exit }
        # Enter
        0x0D { }
        default { Write-Host "Invalid key. Please press Enter, Space bar, or 'q'." -ForegroundColor Red; Prompt-ContinueOrQuit $message }
    }
}

clear # Clear screen
# Begin
Prompt-ContinueOrQuit "This Script Must be run in an elevated (admin) PowerShell script. Press 'q' if you are not an admin. It will run the Windows Update Troubleshoter. Rename the C:\Windows\SoftwareDistribution folder. Run a system scan, then Run the Deployment Image Servicing and Management Tool (DISM)."

# Run the Windows Update troubleshooter
Prompt-ContinueOrQuit "Run Windows Update Troubleshooter?"
msdt.exe /id WindowsUpdateDiagnostic


# Stopping services
Prompt-ContinueOrQuit "Stop Windows Update Services?"
Stop-Service -Name wuauserv -Force
Stop-Service -Name cryptSvc -Force
Stop-Service -Name bits -Force
Stop-Service -Name msiserver -Force

# Renaming the SoftwareDistribution folder
Prompt-ContinueOrQuit "Rename SoftwareDistribution Directory?"
Rename-Item -Path C:\Windows\SoftwareDistribution -NewName SoftwareDistribution.old

# Starting services
Prompt-ContinueOrQuit "Re-start Windows Update Services?"
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
