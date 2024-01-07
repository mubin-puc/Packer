# Install OpenCover 4.7.922
choco install OpenCover --version '4.7.922' --params '"/DIR=C:/Users/$env:CurrentBld_svc_username"' -y

# Add OpenCover to the Path
$openCoverPath = "$env:USERPROFILE\AppData\Local\Apps\OpenCover"
$env:Path += ";$openCoverPath"

