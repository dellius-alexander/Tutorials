
$objects= @(
    [PSCustomObject]@{
        Command = 'Invoke-WebRequest -Uri "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi" `
        -OutFile "$env:HOME\Downloads\wsl_update_x64.msi" -verbose';
    },
    [PSCustomObject]@{
        Command = 'Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -verbose -Force -ErrorAction SilentlyContinue';
    },
    [PSCustomObject]@{
        Command = 'dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart';
    }
)
# foreach ($item in $objects) {
#     Invoke-Expression $item.Command
# }
Invoke-Expression $objects[0].Command
##########################################################################
# Install WSL
# Step 1 - Enable the Windows Subsystem for Linux
# Open PowerShell terminal as Administrator, run:
#
# installs the needed packages to support 'wsl'.
## Command Installs:
###- Virtual Machine Platform
###- Windows Subsystem for Linux
###- WSL Kernel

# wsl --install 

# Restart-Computer

# Step 2 - Check requirements for running WSL 2
# For x64 systems: Version 1903 or higher, with Build 18362 or higher.
# For ARM64 systems: Version 2004 or higher, with Build 19041 or higher.
# Builds lower than 18362 do not support WSL 2. Use the Windows Update 
# Assistant to update your version of Windows.

# update to wsl2
# Step 3 - Enable Virtual Machine feature
# dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Step 4 - Download the Linux kernel update package
# $file = "$env:USERPROFILE\Downloads\wsl_update_x64.msi"
# iwr -Uri "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"  
#   -OutFile "$env:USERPROFILE\Downloads\wsl_update_x64.msi"
#
# Install wsl2 msi
# Install packages
function local:install-packages($Uri){
# define log directory
$userlogdir = (Write-Output $env:USERPROFILE)+"\.logs\PS-Logs"
# container for absolute file path
$file_abs = ""
# location of log directory
Write-Host "Logs for this install-msi can be found in $userlogdir"
# check and resolve file path
$path = (Resolve-Path $file).Path
# verify file name
Write-Output ('You entered "{0}"' -f ${file})
# test if file path exists
if (Test-Path $path) {
    # set absolute path of file
    $file_abs = (Resolve-Path $file).Path
}
else{
    # throw exception if file path fails
    throw "Unable to locate file: $file_abs"
}
# create log directory
New-Item -ItemType "directory" -Path "$userlogdir" -Force -ErrorAction SilentlyContinue
# length of split path
$len = $file_abs.split("\").Length
# get the leaf node of file path aka file name
$file = if($file_abs.contains("\")){  $file_abs.split("\")[$len-1]} else {Write-Output $file_abs}
# verify file name
Write-Output ('You entered "{0}"' -f ${file})
# get timestamp
$DataStamp = (get-date -Format yyyyMMddTHHmmss)
# define logfile: filename-timestamp.log
$logFile = ('{0}-{1}.log' -f $file, $DataStamp)
# msiarguments for msiexe process
$MSIArguments = @(
    "/i"
    ('"{0}"' -f $file_abs)
    "/qn"
    "/norestart"
    "/L*v"
    ('"{0}\{1}"' -f $userlogdir, $logFile))
# start the install process
Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Wait -NoNewWindow
} # end of install-package

# wsl --set-default-version 2
# wsl --install -d Ubuntu-20.04

# $packages = @(
# # Install Chocolatey
# Set-ExecutionPolicy Bypass -Scope Process -Force; `
#     [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
#     iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'));

# # Install development packages
# choco install -dvfy git datagrip microsoft-windows-terminal python vscode docker-desktop 

# # Update Powershell Packagement
# powershell.exe -NoLogo -NoProfile -Command `
# '[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Install-Module -Name PackageManagement -Force -MinimumVersion 1.4.6 -Scope CurrentUser -AllowClobber -Repository PSGallery'
# )

# install-package("Testing")