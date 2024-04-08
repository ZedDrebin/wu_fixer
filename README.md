README.md
<h1>Windows Update Fixer</h1>
Run this PowerShell script in an elevated (Admin) prompt.<br>
It will run the Windows Update Troubleshooter then stop Windows Updates services,<br>
rename C:\Windows\SoftwareDistribution to  C:\Windows\SoftwareDistribution.old<br>
Then run a system scan. See C:\Windows\Logs\CBS\CBS.log for details<br><br>
Then it will run The <b>D</b>eployment <b>I</b>mage <b>S</b>ervicing and <b>M</b>anagement Tool (DISM).<br> 
