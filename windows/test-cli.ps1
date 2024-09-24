# test-cli accepts commandline arguments 
# argument type can be [string] or any [data type]
function local:test-cli {
    [CmdletBinding()]
    param (
        [system.object[]]
        $arguments)
        foreach ($arg in $arguments) {
            Write-Output "$arg"
        }    
}
# Use $args the automatic variable to capture command line input and 
# split them into an array of arguments to the function
test-cli -arguments @($args.split(","))
