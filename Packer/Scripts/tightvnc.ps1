# Install Latest TightVNC
choco install tightvnc --params '"/SET_USEVNCAUTHENTICATION=1 /VALUE_OF_USEVNCAUTHENTICATION=1 /SET_PASSWORD=1 /VALUE_OF_PASSWORD=$env:TEDDY_PASSWORD"' -y

# Download DFMirage Driver
Invoke-WebRequest -Uri "https://artifactory.alteryx.com/artifactory/Runner_resources/guitest/dfmirage-setup-2.0.301.exe" -OutFile "C:/dependencies/dfmirage-setup-2.0.301.exe"

# Run the dfmirage-setup-2.0.301.exe with parameters
Start-Process "C:/dependencies/dfmirage-setup-2.0.301.exe" -ArgumentList "/VERYSILENT /NORESTART"

# Update autologon Username
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultUserName" -Value $env:autologon_user

# Update autologon Password
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultPassword" -Value $env:autologon_password

# Update AutoAdminLogon
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoAdminLogon" -Value "1"

# Update DontDisplayLastUserName
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DontDisplayLastUserName" -Value "0"

# Set a no lock screen
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreen" -Value 1 -Type DWord

# Set a no lock screen
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" -Name "TestHooks" -Value 1 -Type DWord

# Removes the Network discovery screen
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Network" -Name "NewNetworkWindowOff" -Value 1

# Reboot after software is installed
Write-Host "Reboot after software is installed ..."
Start-Sleep -Seconds 30
Restart-Computer -Force
