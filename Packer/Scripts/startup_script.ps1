# Task 1: Run win_whoami
$instanceName = Get-WmiObject Win32_ComputerSystem | Select-Object -ExpandProperty Name

# Task 2: Run default_browser.ps1
Start-Process -FilePath "psexec.exe" -ArgumentList "-accepteula \\$($instanceName) -s -i 1 -w C:/dependencies -u $($env:autologon_user) -p '$($env:autologon_password)' -h cmd.exe /c 'echo .|powershell.exe -file C:/dependencies/default_browser.ps1'" -Wait

# Task 3: Modify the ExecutionPolicy
Set-ExecutionPolicy Unrestricted -Scope LocalMachine -Force -ErrorAction Ignore

# Task 4: Create directory structure for startup script
$startupDirectory = "C:\Users\$($env:autologon_user)\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\"
New-Item -Path $startupDirectory -ItemType Directory -Force

# Task 5: Move the default_browser to the selected location
Copy-Item -Path "C:/dependencies/default_browser.ps1" -Destination "$startupDirectory\default_browser.ps1" -Force

# Task 6: Update Windows explorer to stop asking for default browser
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "NoNewAppAlert" -Value 1

# Task 7: Update windows error reporting
New-Item -Path "HKCR:\Microsoft.PowerShellScript.1\Shell" -Force
Set-ItemProperty -Path "HKCR:\Microsoft.PowerShellScript.1\Shell" -Name "(Default)" -Value 0

# Task 8: Reboot after software is installed
Restart-Computer
