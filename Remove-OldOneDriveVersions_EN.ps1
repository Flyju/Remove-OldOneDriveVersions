# Get OneDrive path by process
function Get-OneDrivePathFromProcess {
    # Find the currently running OneDrive.exe process
    $oneDriveProcess = Get-Process -Name "OneDrive" -ErrorAction SilentlyContinue

    if ($oneDriveProcess) {
        # Get the full path of OneDrive.exe
        $oneDrivePath = $oneDriveProcess.Path
        # Get the folder path where OneDrive.exe is located
        $oneDriveFolderPath = Split-Path -Path $oneDrivePath -Parent
        return $oneDriveFolderPath
    } else {
        return $null
    }
}

# Get OneDrive path
Write-Output "Looking for OneDrive installation path..."
$oneDrivePath = Get-OneDrivePathFromProcess

# If the path is not found, prompt the user to manually input it
if (-not $oneDrivePath) {
    Write-Output "Unable to retrieve the OneDrive installation path (OneDrive may not be running)."
    $oneDrivePath = Read-Host "Please enter the OneDrive installation path"
}

Write-Output "Retrieved OneDrive folder path: $oneDrivePath"

# Check if OneDrive.exe exists in the path
if (-not (Test-Path "$oneDrivePath\OneDrive.exe")) {
    Write-Output "OneDrive.exe file not found. Please verify the path."
    exit
}

# Get the current OneDrive version
$currentVersion = (Get-Item "$oneDrivePath\OneDrive.exe").VersionInfo.ProductVersion
Write-Output "Current OneDrive version in use: $currentVersion"

# Find old version folders
Write-Output "Looking for old version folders..."
$oldFolders = Get-ChildItem -Path $oneDrivePath -Directory |
    Where-Object { $_.Name -match '^\d{2}\.\d{3}\.\d{4}\.\d{4}$' } |
    Where-Object { $_.Name -ne $currentVersion }

# Check if there are any old version folders
if ($oldFolders.Count -eq 0) {
    Write-Output "No old version OneDrive folders found."
} else {
    # Delete old version folders
    $oldFolders | ForEach-Object {
        Write-Output "About to delete old version folder: $($_.FullName)"
        Remove-Item -Path $_.FullName -Recurse -Force -Verbose
        Write-Output "Deleted old version folder: $($_.FullName)"
    }
}

Write-Output "Script execution completed!"
Write-Output "Press any key to exit..."
[Console]::ReadKey()
