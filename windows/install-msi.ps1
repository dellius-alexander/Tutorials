#Requires -PSEdition Core
#Requires -Version 5.0
# Msi-Install function
function local:install-msi {
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
    ParameterSetName="file",
    ValueFromPipeline=$true,
    ValueFromPipelineByPropertyName=$true,
    HelpMessage="File")]
    [ValidateNotNullOrEmpty()]
    [System.Object]
    $file)
##########################################################################
PROCESS {
    try {
        $userlogdir = (Write-Output $Env:USERPROFILE)+"\.logs\PS-Logs"
        Write-Host "Logs for this install-msi can be found in $userlogdir"
        $path = (Resolve-Path $file).Path
        if (Test-Path $path) {
            $file_fullpath = (Resolve-Path $file).Path
        }
        else{
            throw "Unable to locate file: $file"
        }
        New-Item -ItemType "directory" -Path "$userlogdir" -Force -ErrorAction SilentlyContinue
        $len = $file_fullpath.split("\").Length
        $file = ($file_fullpath.contains("\") ? $file_fullpath.split("\")[$len-1] : $file_fullpath)
        Write-Output ('You entered "{0}"' -f ${file})
        $DataStamp = (get-date -Format yyyyMMddTHHmmss)
        $logFile = ('{0}-{1}.log' -f $file, $DataStamp)
        $MSIArguments = @(
            "/i"
            ('"{0}"' -f $file_fullpath)
            "/qn"
            "/norestart"
            "/L*v"
            ('"{0}\{1}"' -f $userlogdir, $logFile))
        Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Wait -NoNewWindow
        # Write-Output $MSIArguments
    }
    catch [System.Exception] {
        Write-Warning $_.Exception.Message
    }
}
}
install-msi -file @($args.split(","))

# Run command from command line:
# Set-ExecutionPolicy Bypass -Scope Process -Force; .\install-msi -file <filename>