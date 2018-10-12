# Extract-HyenaSuccessfulExport
This script allows for easier Hyena re-scanning of failed systems for a given Organizational Unit (OU).  Systems that were successfully exported will be skipped resulting in shorter re-scan times as well as a more complete data pull of system objects within the OU.

It requires that you enable logging of operations in Hyena if you aren’t doing so already.

## Basic Usage

    .\Extract-HyenaSuccessfulExport.ps1 -OperationsLogFile export.log

By default, it will output a list of systems that had successful object exports to a file called ‘export_success.dat’.  That file can be used within Hyena's Export Properties so they are skipped for any subsequent re-scans.  The option to link the successfully exported system list can be set by going to:

    Export Selected Objects > Settings > Export Properties > General tab > then check 'Skip Computers Listed in File' and link the file

To use the built-in PowerShell help system and read the documentation for this script run:

    Get-Help .\Extract-HyenaSuccessfulExport.ps1

## Options

There are two other options included with this script.  `-OutputFile` allows you to change the default name of the output file, 'export_success.dat'.  You can also change the search string used to extract systems from the Hyena operations log with the `-SearchString` option.  The default uses the case sensitive string of 'SUCCESS'.  If you were interested in the export failures you could change this to 'ERROR'.  Note that this is only for informational purposes and as the resultant output file cannot be beneficially resused within Hyena's Export Properties options.

## Configuring Hyena's Export Properties

Hyena does required some basic configuration to ensure that logging is enabled and that the `export.log` file is generated (this name can be changed within the `Log File Name` box).  As specified above you'll want to navigate to the `Export Properties` dialog but go to the 'Output' tab instead in the `File Logging Options` section.  Check the following:

- [x] Enable File Logging
- [x] Log Successful Operations  
- [x] Log Failed Operations
- [x] Append Logging Information to Log File

If the `Log Failed Options` option is not checked then the corresponding `-SearchString` option would be of no value, though this is not detrimental to the script operation.

When running your Hyena export for the first time I'd recommend checking the following options as well in `File Output Options` section:

- [x] Write Field Titles to Output Files
- [x] Append Output To Output Files (If Files Already Exist)

If you check `Append Output To Output Files (If Files Already Exist)` this will automatically add new systems that are scanned to your existing data pull.  That way you won’t have to manually piece the different datasets together, though it can be done.  If you have export failures and you need to run Hyena again I'd recommend unchecking `Write Field Titles to Output Files` for all subsequent scans.  If you don’t your results will be fine but be advised that you’ll have the header column included more than one time.
