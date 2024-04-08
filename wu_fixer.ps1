## Arthur Vaccario - Windows Update Fixer v1.0 
## Last update 04/08/2024 (Initial) Development

# Run the Windows Update troubleshooter
msdt.exe /id WindowsUpdateDiagnostic

# Stopping services
Stop-Service -Name wuauserv -Force
Stop-Service -Name cryptSvc -Force
Stop-Service -Name bits -Force
Stop-Service -Name msiserver -Force

# Renaming the SoftwareDistribution folder
Rename-Item -Path C:\Windows\SoftwareDistribution -NewName SoftwareDistribution.old

# Starting services
Start-Service -Name wuauserv
Start-Service -Name cryptSvc
Start-Service -Name bits
Start-Service -Name msiserver

# Running system file checker
sfc /scannow

# Running DISM tool to repair Windows image
DISM /Online /Cleanup-Image /RestoreHealth

