#Requires -PSEdition Core
#Requires -Version 5.0
##########################################################################
##########################################################################
# setup-pc function
function global:set-env {

<#
.SYNOPSIS
    
.DESCRIPTION
    
.PARAMETER URL
    
.PARAMETER PATH
    The [OPTIONAL] PATH parameter provides a PATH destination for your downloaded 
    object; default download location is the current directory of the executing script
.INPUTS
    Yes... I do accept pipeline input 
    e.g. 
.OUTPUTS 
    
.EXAMPLE
    
.EXAMPLE
    
.EXAMPLE
        
.NOTES
    Author: Dellius Alexander
    Last Edit: 2020-06-11
    Version 1.0 - download single object
    Version 1.1 - download to a spacified PATH & added pipeline input
#>
##########################################################################
# Specifies a array of objects to one locations.
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true,
    Position=0,
    ParameterSetName="Objects",
    ValueFromPipeline=$true,
    ValueFromPipelineByPropertyName=$true,
    HelpMessage="System.Object[]")]
    [ValidateNotNullOrEmpty()]
    [System.Object[]]
    $objects)
##########################################################################

    foreach ($item in (Write-Output $objects))
    {
        Write-Host $item
    }


}

set-env -Objects @($args)
# One-liner to install or update PowerShell 6 on Windows 10
#Set-ExecutionPolicy Bypass -Scope Process -Force; iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"
Exit-PSSession 
# ##########################################################################
# # Install Chocolatey
# # Use this command to bypass execution policy => #Set-ExecutionPolicy Bypass -Scope Process -Force; 
# [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
# # Install windows feature subsystem for linux
# dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
# # Install windows feature virtual machine platform
# dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
# # Download wsl2 update
# iwr -Uri 'https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi' -OutFile wsl_update_x64.msi
# # Install wsl2 using 'function msi-install <file.msi>'
# .\install-msi.ps1 wsl_update_x64.msi
# wsl --set-default-version 2

# iwr -Uri 'https://desktop.docker.com/win/stable/amd64/Docker%20Desktop%20Installer.exe' -OutFile 'Docker_Desktop_Installer.exe'



##########################################################################