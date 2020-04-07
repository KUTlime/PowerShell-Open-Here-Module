#
# Module manifest for module 'OpenHere'
#
# Generated by: Radek Zahradník
#
# Generated on: 17.02.2020
#

@{

    # Script module or binary module file associated with this manifest.
    RootModule         = 'OpenHere'

    # Version number of this module.
    ModuleVersion      = '3.0.0'

    # Supported PSEditions
    # CompatiblePSEditions = @()

    # ID used to uniquely identify this module
    GUID               = '689f0f0f-1c04-4ce6-8049-dba35b1d4184'

    # Author of this module
    Author             = 'Radek Zahradník, Ph.D.'

    # Company or vendor of this module
    CompanyName        = 'Radek Zahradník, Ph.D.'

    # Copyright statement for this module
    Copyright          = '(c) Radek Zahradník, Ph.D. All rights reserved.'

    # Description of the functionality provided by this module
    Description        = 'This module enables "Open here" shortcuts functionality for various shells like Windows PowerShell, Command line, Windows Terminal.'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion  = '5.0.0.0'

    # Name of the PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # CLRVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @()

    # Assemblies that must be loaded prior to importing this module
    RequiredAssemblies = @('System.Drawing.dll')

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport  = @('Set-OpenHereShortcut', 'Remove-OpenHereShortcut')

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport    = @()

    # Variables to export from this module
    VariablesToExport  = '*'

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport    = @()

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData        = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags                     = @('WindowsPowerShell', 'OpenHere', 'Open', 'Here', 'Shortcut', 'CMD', 'WindowsTerminal')

            # A URL to the license for this module.
            LicenseUri               = 'https://github.com/KUTlime/PowerShell-Open-Here-Module/blob/master/LICENSE'

            # A URL to the main website for this project.
            ProjectUri               = 'https://github.com/KUTlime/PowerShell-Open-Here-Module'

            # A URL to an icon representing this module.
            # IconUri = ''

            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            RequireLicenseAcceptance = $false

            # ReleaseNotes of this module
            ReleaseNotes             = @'
v3.0.0: (2020-04-07)
- Support for PowerShell Core 7 RTM x64 (or any x64 major version)
- Support for WSL/Bash

v2.0.5: (2020-03-01)
- Manifest description update.

v2.0.4: (2020-02-27)
- A workaround for Windows Terminal open here shortcut when RMB on directory/drive letter has been added.
- From this version, both Windows Terminal Open here shortcuts use Windows PowerShell for a correct startup.

v2.0.3: (2020-02-24)
- A workaround for Windows Terminal open here as admin has been added.

v2.0.2: (2020-02-23)
- Terminal was renamed to Windows Terminal to respect the official name.
- Enum value Terminal was changed to WindowsTerminal to respect the official name.

v2.0.1: (2020-02-23)
- Manifest update fix.

v2.0.0: (2020-02-23)
- Support for Microsoft Terminal.
- Support for MS Command Prompt
- Function refactoring into general implementation.
- Function renaming.
- Function example extension.
- Function parameters documentation has been extended.
- General documentation update.

v1.0.4: (2020-02-20)
- Fix of relelease notes.

v1.0.3: (2020-02-20)
- Documentation update.

v1.0.2: (2020-02-20)
- Support of shell type for icon provider.

v1.0.1: (2020-02-20)
- Fixing minimal PowerShell version from 1.x to 5.0.

v1.0.0: (2020-02-20)
- Initial release
- Implementation for Windows PowerShell shortcut.
'@

            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            # RequireLicenseAcceptance = $false

            # External dependent modules of this module
            # ExternalModuleDependencies = @()

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}

