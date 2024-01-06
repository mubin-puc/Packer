# Define the download URL for PsExec
$psexecUrl = "https://download.sysinternals.com/files/PSTools.zip"

# Define the destination folder for PsExec
$psexecDestination = "C:\dependencies\PSTools"

# Create the destination folder if it doesn't exist
if (-not (Test-Path $psexecDestination -PathType Container)) {
    New-Item -ItemType Directory -Path $psexecDestination | Out-Null
}

# Download PsTools.zip
Invoke-WebRequest -Uri $psexecUrl -OutFile "$psexecDestination\PSTools.zip"

# Extract the contents of the zip file
Expand-Archive -Path "$psexecDestination\PSTools.zip" -DestinationPath $psexecDestination -Force

# Add the PsExec folder to the system path
$envPath = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)
if ($envPath -notlike "*$psexecDestination*") {
    [System.Environment]::SetEnvironmentVariable('Path', "$envPath;$psexecDestination", [System.EnvironmentVariableTarget]::Machine)
}

# Display a message indicating that PsExec has been installed and added to the path
Write-Host "PsExec has been installed in C:\dependencies\PSTools and added to the system path. You may need to restart PowerShell for changes to take effect."
