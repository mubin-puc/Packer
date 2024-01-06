# Setup chocolatey 
choco source Add -Name alteryx -Source https://artifactory.alteryx.com/artifactory/api/nuget/chocolatey
choco source Add -Name alteryx-nuget-development -Source https://artifactory.alteryx.com/artifactory/api/nuget/devops-chocolatey-nuget-development --priority="'10'"
choco source Add -Name alteryx-nuget-mirror -Source https://artifactory.alteryx.com/artifactory/api/nuget/devops-chocolatey-nuget-mirror --priority="'5'"
choco source Add -Name alteryx-cache -Source https://artifactory.alteryx.com/artifactory/api/nuget/chocolatey-remote
choco source disable -name chocolatey

# Install version packages
choco install 7zip --version=19.0.0 -y
choco install jfrog-cli --version=1.52.0 -y

# Install google chrome
Write-Host "Installing google chrome..."
Start-Process -Wait -FilePath "$env:SystemRoot\System32\msiexec.exe" -ArgumentList "/i https://dl.google.com/edgedl/chrome/install/GoogleChromeStandaloneEnterprise64.msi /quiet /passive /qn"

#Disable Windows Feature 
Disable-WindowsOptionalFeature -FeatureName Internet-Explorer-Optional-amd64 -Online -NoRestart

# Install .NET Framework 3.5 on Windows Server
Write-Host "Installing .NET Framework 3.5 ...";
Add-WindowsFeature -Name NET-Framework-Core
