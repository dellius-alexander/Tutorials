Set-ExecutionPolicy Bypass -Scope Process -Force;
# Open PowerShell terminal as Administrator, run this script
#####################################################################
# Redefine destination log directory here or by default log directory
# will go into to USERHOME directory
$CUSTOM_LOG_DIR=(Write-Output $env:USERPROFILE)+"\.logs\PS-Logs"
if(test-path $CUSTOM_LOG_DIR){$CUSTOM_LOG_DIR+" Exists......"}else{
    $CUSTOM_LOG_DIR+" Does not Exist......"
    New-Item -ItemType Directory -Path $CUSTOM_LOG_DIR
}
#####################################################################
# This function is used to install downloaded packages gracefully
function local:install-packages($path){
    # container for absolute file path
    $file_abs = 
    # location of log directory
    Write-Host "Logs for this install-msi can be found in $userlogdir"
    # verify file name
    Write-Output ('You entered "{0}"' -f $path)
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
    if (test-path $CUSTOM_LOG_DIR){$CUSTOM_LOG_DIR+" Exists......"}else{
        New-Item -ItemType "directory" -Path "$CUSTOM_LOG_DIR" -Force -ErrorAction SilentlyContinue}
    # length of split path
    $len = $file_abs.split("\").Length
    # get the leaf node of file path aka file name
    $file = if($file_abs.contains("\")){  $file_abs.split("\")[$len-1]} else {Write-Output $file_abs}
    # verify file name
    Write-Output ('You entered "{0}"' -f $file)
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
        ('"{0}\{1}"' -f $CUSTOM_LOG_DIR, $logFile))
    # start the install process
    Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Wait -NoNewWindow
    } # end of install-packages
#####################################################################
# Comment out any package you do not want to be installed
$install_packages = @(
    'git' 
    'datagrip' 
    'microsoft-windows-terminal '
    'python'
    'vscode '
    'docker-desktop'
    'visualparadigm-ce'
)
#####################################################################
    # Step 1 - Enable the Windows Subsystem for Linux
$WSL_INSTALL = [PSCustomObject]@{ Command = 'wsl --install;  Restart-Computer;'; }
# Custom objects needed for installation
# Comment out any objec you do not want to install
# NOTE: comment out wsl after initial install and system reboot
$collection= @{

    # Step 2 - Check requirements for running WSL 2
    # For x64 systems: Version 1903 or higher, with Build 18362 or higher.
    # For ARM64 systems: Version 2004 or higher, with Build 19041 or higher.
    # Builds lower than 18362 do not support WSL 2. Use the Windows Update 
    # Assistant to update your version of Windows. Then update to wsl2
        WSL2_Download = 'Invoke-WebRequest -Uri "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi" -OutFile "$env:USERPROFILE\Downloads\wsl_update_x64.msi" -debug -verbose';
        WSL2_Download_Dst = "$env:USERPROFILE\Downloads\wsl_update_x64.msi"
    
    # Step 3 - Enable Virtual Machine feature
        VirtualMachinePlatform = 'dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart';

    # Step 4 - Update to wsl2
        UPDATEWSL = 'wsl --set-default-version 2; wsl --install -d Ubuntu-20.04;';

    # Step 5 - Install Chocolatey

        InstallChocolatey = 'Set-ExecutionPolicy Bypass -Scope Process -Force; `
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
        iex ((New-Object System.Net.WebClient).DownloadString("https://community.chocolatey.org/install.ps1"));'

    # Step 6 - Update Powershell PackageManagement
        UpdatePackageManagement = 'powershell.exe -NoLogo -NoProfile -Command [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Install-Module -Name PackageManagement -Force -MinimumVersion 1.4.6 -Scope CurrentUser -AllowClobber -Repository PSGallery'

    # Step 7 - # Install development packages
        InstallChocolateyPackages = "choco install -dvfy "+$install_packages
}


#####################################################################
# Check if wsl is installed and enabled
 if ((Get-WindowsOptionalFeature -online | Where-Object -Property FeatureName -like "Microsoft-Windows-Subsystem-Linux" ).State.ToString().Contains('Enabled')) 
 {
    $package_logs = $CUSTOM_LOG_DIR+"\package_install_"+(get-date -Format yyyyMMddTHHmmss)+".log"
    Invoke-Expression $collection['WSL2_Download'] -verbose  | Tee-Object -FilePath $package_logs -Append -Debug
    Invoke-Expression $collection['VirtualMachinePlatform'] -Debug -Verbose | Tee-Object -FilePath $package_logs -Append -Debug
    install-packages($collection['WSL2_Download_Dst']) | Tee-Object -FilePath $package_logs -Append -Debug
    Invoke-Expression $collection['UpdatePackageManagement'] -Debug -Verbose  | Tee-Object -FilePath $package_logs -Append -Debug
    Invoke-Expression $collection['InstallChocolatey'] -Debug -Verbose | Tee-Object -FilePath $package_logs -Append -Debug
    Invoke-Expression $collection['InstallChocolateyPackages'] -Debug -Verbose | Tee-Object -FilePath $package_logs -Append -Debug    

} else { # install wsl
    Invoke-Expression  $WSL_INSTALL.Command -Debug -Verbose | Tee-Object -FilePath $package_logs -Append -Debug
    
}

