New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft -Name "Windows Defender" -Force
Set-MpPreference -DisableRealtimeMonitoring $true
New-ItemProperty -Path "HKLM:\SOFTWARE\\Policies\Microsoft\Windows Defender" -Name DisableAntiSpyware -Value 1 -PropertyType DWORD -Force