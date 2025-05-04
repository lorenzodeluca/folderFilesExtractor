# To run: powershell -ExecutionPolicy Bypass -File "renamer.ps1"

# Directory configuration
$source = "L:\source"
$dest = "L:\dest"

# Create destination directory if it does not exist
if (-not (Test-Path $dest)) {
    New-Item -ItemType Directory -Path $dest | Out-Null
}

# Initialize file counter
$counter = 1

# Get all files recursively
Get-ChildItem -Path $source -Recurse -File | ForEach-Object {
    $file = $_
    # Get modification year and month
    $modYear = $file.LastWriteTime.ToString("yyyy")
    $modMonth = $file.LastWriteTime.ToString("MM")
    # Get filename without extension and file extension
    $filename = $file.BaseName
    $extension = $file.Extension.TrimStart('.')

    # Construct new filename
    $newname = "{0}-{1}-{2}-{3}.{4}" -f $modYear, $modMonth, $filename, $counter, $extension

    # Copy the file with the new name to the destination directory
    Copy-Item -Path $file.FullName -Destination (Join-Path $dest $newname)

    Write-Host "Copied: $($file.FullName) -> $dest\$newname"

    $counter++
}
Write-Host ""
Write-Host "Operation completed. Total files processed: $($counter-1)"
