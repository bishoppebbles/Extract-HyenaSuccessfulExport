<#
.SYNOPSIS
    This script allows for easier Hyena re-scanning of failed systems for a given Organizational Unit (OU).  Systems that were successfully scanned will be skipped resulting in shorter re-scan times as well as a more complete data pull of systems within the OU.
.DESCRIPTION
    This script takes the output of the Hyena operations log and extracts all the systems that were successfully scanned.  This list can be used to re-scan a given OU with Hyena and ignore any systems that were already successful.  In Hyena's 'Output' properties tab 'Enable File Logging' as well the 'Log Successful Operations' must be selected for this script to work.  Optionally, and for informational purposes, it can return a list of all systems that failed.  The 'Log Failed Operations' must be checked for this to work.  
.PARAMETER OperationsLogFile
    The name of the Hyena operations log file.
.PARAMETER OutputFile
    The name of the output file to write results to.
.PARAMETER SearchString
    The search string to use.
.EXAMPLE
    Extract-HyenaSuccessfulExport.ps1 Export.log

    This scipt only requires the Hyena successful operations log as a single argument.  By default, it outputs the results to a file called 'export_success.dat' using a search string of 'SUCCESS'.    
.EXAMPLE
    Extract-HyenaSuccessfulExport.ps1 -OperationsLogfile Export.log -OutputFile Output.dat -SearchString SUCCESS
    
    Explicitly include the script option flags for the Hyena successful operations log 'Export.log', a custom output file named 'Output.dat', and a search string of 'SUCCESS'.
.EXAMPLE
    Extract-HyenaSuccessfulExport.ps1 Export.log Output.dat ERROR
    
    All script options are positional so the use of explicit flags is not mandatory.  This specifies a Hyena log with the 'Log Failed Operations' option enabled called 'Export.log', an output file named 'Output.dat', and a search string of 'ERROR'.  This returns a list of the systems that failed during the scan and cannot be used as input to the 'Skip Computers List' in Hyena.
.NOTES
    Version 1.0 - Last Modified: 12 OCT 2018
    Sam Pursglove
#>

param 
(
    [Parameter(Position=0,
               Mandatory=$true,
               ValueFromPipeline=$false,
               HelpMessage='Filename of the Hyena operations log (e.g., export.log).  Hyena file logging and the "Log Successful Operations" option must be enabled for this script to work.')]
    [string]$OperationsLogFile,

    [Parameter(Mandatory=$false,
               ValueFromPipeline=$false,
               HelpMessage='Name of the file to save the systems that Hyena successfully scanned.  The default file name is export_success.dat')]
    [string]$OutputFile = 'export_success.dat',

    [Parameter(Mandatory=$false,
               ValueFromPipeline=$false,
               HelpMessage='Optionally, you can change the search string used to export from the Hyena operations log (e.g., ERROR).  This is case insensitive')]
    [ValidateSet('SUCCESS','ERROR')] [string]$SearchString = 'SUCCESS'
)

$temp = Get-Content $OperationsLogFile | Select-String $SearchString

$temp[0] = "Date_time`tHost`tFQDN_host`tLocation`tObject_type`tExport"

# Length-2 is used at the output log of Hyena adds an additional newline at the end
$temp[0..($temp.Length-2)] | 
    ConvertFrom-Csv -Delimiter "`t" | 
    ForEach-Object { Write-Output "\\$($_.FQDN_host)" } | 
    Sort-Object -Unique |
    # ASCII encoding is required for Hyena to properly read the file
    Out-File $OutputFile -Encoding ascii