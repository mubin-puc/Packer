# Define the source folder and destination folder
$sourceFolder = "files"
$destinationFolder = "C:/dependencies"

# Check if the source folder exists
if (Test-Path $sourceFolder -PathType Container) {
    # Check if the destination folder exists, create it if not
    if (-not (Test-Path $destinationFolder -PathType Container)) {
        New-Item -ItemType Directory -Path $destinationFolder | Out-Null
    }

    # Get all files from the source folder
    $files = Get-ChildItem -Path $sourceFolder

    # Copy each file to the destination folder
    foreach ($file in $files) {
        $destinationPath = Join-Path $destinationFolder $file.Name
        Copy-Item -Path $file.FullName -Destination $destinationPath -Force
        Write-Host "Copied $($file.FullName) to $($destinationPath)"
    }

    Write-Host "Files copied successfully."
} else {
    Write-Host "Source folder does not exist: $sourceFolder"
}
