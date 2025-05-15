# ----------------------------------------------
# Script: Install-WingetOnLTSC.ps1
# Purpose: On Windows 10 LTSC (which lacks the Microsoft Store by default),
#          this script installs the Microsoft Store and then the App Installer package,
#          thereby enabling Winget.
#
# IMPORTANT: Replace the placeholder URLs with valid download links from your trusted source.
# ----------------------------------------------

function Install-MicrosoftStore {
    # Check if Microsoft Store is installed
    $storePackage = Get-AppxPackage -Name "Microsoft.WindowsStore" -ErrorAction SilentlyContinue
    if ($storePackage -eq $null) {
        Write-Output "Microsoft Store is not installed. Installing Microsoft Store..."
        
        # URL for the Microsoft Store package (.appx or .msix)
        # Replace this with the correct URL for your package
        $storeUrl = "https://example.com/path/to/MicrosoftStore.appx"
        $storeInstallerPath = "$env:TEMP\MicrosoftStore.appx"
        
        try {
            Write-Output "Downloading Microsoft Store package..."
            Invoke-WebRequest -Uri $storeUrl -OutFile $storeInstallerPath -UseBasicParsing
            Write-Output "Installing Microsoft Store package..."
            Add-AppxPackage -Path $storeInstallerPath
            Write-Output "Microsoft Store installed successfully."
        }
        catch {
            Write-Error "Failed to install Microsoft Store: $_"
        }
    }
    else {
        Write-Output "Microsoft Store is already installed."
    }
}

function Install-AppInstaller {
    # Check if App Installer (the package that includes Winget) is installed
    $appInstallerPackage = Get-AppxPackage -Name "Microsoft.DesktopAppInstaller" -ErrorAction SilentlyContinue
    if ($appInstallerPackage -eq $null) {
        Write-Output "App Installer is not installed. Installing App Installer package (this includes Winget)..."
        
        # URL for the App Installer package (.appxbundle) that includes Winget
        # Replace this with the correct URL for your package
        $appInstallerUrl = "https://example.com/path/to/Microsoft.DesktopAppInstaller.appxbundle"
        $appInstallerPath = "$env:TEMP\DesktopAppInstaller.appxbundle"
        
        try {
            Write-Output "Downloading App Installer package..."
            Invoke-WebRequest -Uri $appInstallerUrl -OutFile $appInstallerPath -UseBasicParsing
            Write-Output "Installing App Installer package..."
            Add-AppxPackage -Path $appInstallerPath
            Write-Output "App Installer installed successfully. Winget should now be available."
        }
        catch {
            Write-Error "Failed to install App Installer package: $_"
        }
    }
    else {
        Write-Output "App Installer (and Winget) is already installed."
    }
}

# Main script execution
try {
    Write-Output "Starting Winget installation process on Windows 10 LTSC..."
    
    Install-MicrosoftStore
    Install-AppInstaller
    
    # Optional: Wait a few seconds to ensure installation processes have finished
    Start-Sleep -Seconds 5
    
    # Test if winget is available
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        $wingetVersion = winget --version
        Write-Output "Winget is installed successfully. Version: $wingetVersion"
    }
    else {
        Write-Output "Winget is not detected. Please check the installation steps and verify the package sources."
    }
}
catch {
    Write-Error "An unexpected error occurred: $_"
}
