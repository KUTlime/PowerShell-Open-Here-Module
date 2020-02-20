enum ShellType
{
    WindowsPowerShell
    PowerShellCore
    Terminal
}

function Get-ShellType
{
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false,
            Position = 0,
            ParameterSetName = 'Basic')]
        [ValidateNotNullOrEmpty()]
        [ShellType]
        $ShellType
    )
    switch ($ShellType)
    {
        ([ShellType]::WindowsPowerShell) { return 'WindowsPowerShell' }
        ([ShellType]::PowerShellCore) { return 'PowerShellCore' }
        ([ShellType]::Terminal) { return 'Terminal' }
        Default { throw [System.ArgumentOutOfRangeException]::('Unknown Shell type.') }
    }
}

function Get-IconAsset
{
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false,
            Position = 0,
            ParameterSetName = 'Basic')]
        [ValidateNotNullOrEmpty()]
        [String]
        $ShellType
    )
    New-Item "$env:LOCALAPPDATA\OpenHere\$ShellType" -ItemType Directory -Force | Write-Verbose
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile("https://raw.githubusercontent.com/KUTlime/PowerShell-Open-Here-Module/master/assets/$ShellType.ico", "$env:LOCALAPPDATA\OpenHere\$ShellType\Icon.ico")
}

function Set-OpenHereWindowsPowerShellShortcut
{
    <#
    .SYNOPSIS
        Sets Open here shortcut into the system shell.
    .DESCRIPTION
        Sets Open here shortcut into the context menu in the system shell for directory, the directory background, drives and the user's desktop.
    .EXAMPLE
        PS C:\> Set-OpenHereWindowsPowerShellShortcut
        Creates the default shortcut in the system. "Windows PowerShell" as root folder name, "Open here" as non-elevated privileges command name and "Open here as Administrator" elevated privileges command name will be used.
    .EXAMPLE
        PS C:\> Set-OpenHereWindowsPowerShellShortcut -RootName 'Old PowerShell'
        Creates a customized shortcut in the system. "Old PowerShell" as root folder name, "Open here" as non-elevated privileges command name and "Open here as Administrator" elevated privileges command name will be used.
    .EXAMPLE
        PS C:\> Set-OpenHereWindowsPowerShellShortcut -OpenHere 'I''m lazy'
        Creates a customized shortcut in the system. "Windows PowerShell" as root folder name, "I'm lazy" as non-elevated privileges command name and "Open here as Administrator" elevated privileges command name will be used.
    .EXAMPLE
        PS C:\> Set-OpenHereWindowsPowerShellShortcut -OpenHereAsAdmin 'I''m lazy admin'
        Creates a customized shortcut in the system. "Windows PowerShell" as root folder name, "Open here" as non-elevated privileges command name and "I''m lazy admin" elevated privileges command name will be used.
    .EXAMPLE
        PS C:\> Set-OpenHereWindowsPowerShellShortcut -RootName 'Old PowerShell' -OpenHere 'I''m lazy'
        Creates a customized shortcut in the system. "Old PowerShell" as root folder name, "I'm lazy" as non-elevated privileges command name and "Open here as Administrator" elevated privileges command name will be used.
    .EXAMPLE
        PS C:\> Set-OpenHereWindowsPowerShellShortcut -OpenHere 'I''m lazy' -OpenHereAsAdmin 'I''m lazy admin'
        Creates a fully customized shortcut in the system. "Windows PowerShell" as root folder name, "I'm lazy" as non-elevated privileges command name and "I'm lazy admin" elevated privileges command name will be used.
    .EXAMPLE
        PS C:\> Set-OpenHereWindowsPowerShellShortcut -RootName 'Old PowerShell' -OpenHere 'I''m lazy' -OpenHereAsAdmin 'I''m lazy admin'
        Creates a fully customized shortcut in the system. "Old PowerShell" as root folder name, "I'm lazy" as non-elevated privileges command name and "I'm lazy admin" elevated privileges command name will be used.
    .EXAMPLE
        PS C:\> Set-OpenHereWindowsPowerShellShortcut -Verbose
        Creates the default shortcut in the system and the building process will be verbose to user. "Windows PowerShell" as root folder name, "Open here" as non-elevated privileges command name and "Open here as Administrator" elevated privileges command name will be used.
    .LINK
        https://github.com/KUTlime/PowerShell-Open-Here-Module
    .INPUTS
        System.String
    .OUTPUTS
        Shell shortcut visible in the context menu.
    .NOTES
        To override the default shortcut icon, override the Icon.ico file in %LOCALAPPDATA%\OpenHere\[ShellType].
        The context menu can be invoked from the menu button and by the right mouse button click.
    #>
    [CmdletBinding()]
    Param (
        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false,
            Position = 0,
            ParameterSetName = 'Basic')]
        [ValidateNotNullOrEmpty()]
        [String]
        $RootName = "Windows PowerShell",
        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false,
            Position = 1,
            ParameterSetName = 'Basic')]
        [ValidateNotNullOrEmpty()]
        [String]
        $OpenHere = "Open here",
        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false,
            Position = 1,
            ParameterSetName = 'Basic')]
        [ValidateNotNullOrEmpty()]
        [String]
        $OpenHereAsAdmin = "Open here as Administrator"
    )

    $registryKeyName = 'WindowsPowerShell'

    function Set-RegistryKey
    {
        [CmdletBinding()]
        param (
            [Parameter()]
            [String]
            $Path
        )
        New-Item -Path $Path\$registryKeyName -Force -ErrorAction:Continue | Write-Verbose
        New-ItemProperty -Path $Path\$registryKeyName -Name MUIVerb -Value $RootName -Force -ErrorAction:Continue | Write-Verbose
        New-ItemProperty -Path $Path\$registryKeyName -Name Icon -Value $iconFile.FullName -Force -ErrorAction:Continue | Write-Verbose
        New-ItemProperty -Path $Path\$registryKeyName -Name ExtendedSubCommandsKey -Value "Directory\ContextMenus\$registryKeyName" -Force -ErrorAction:Continue | Write-Verbose
    }

    function Set-RegistryKeyWithCommand
    {
        [CmdletBinding()]
        param (
            [Parameter()]
            [String]
            $Path
        )
        New-Item -Path $Path\$registryKeyName\shell\runas\command -Value "$env:SystemRoot\system32\WindowsPowerShell\v1.0\powershell.exe -noexit -command Set-Location '%V'" -Force -ErrorAction:Continue | Write-Verbose
        New-Item -Path $Path\$registryKeyName\shell\openpowershell\command -Value "$env:SystemRoot\system32\WindowsPowerShell\v1.0\powershell.exe -noexit -command Set-Location '%V'" -Force -ErrorAction:Continue | Write-Verbose
    }

    $ShellType = Get-ShellType -ShellType $registryKeyName
    Get-IconAsset -ShellType $ShellType
    $iconFile = Get-ChildItem -Path "$env:LOCALAPPDATA\OpenHere\$ShellType\Icon.ico"
    New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR | Write-Verbose

    Set-RegistryKey -Path HKCR:\LibraryFolder\background\shell
    Set-RegistryKey -Path HKCR:\Drive\shell
    Set-RegistryKey -Path HKCR:\Directory\shell
    Set-RegistryKey -Path HKCR:\Directory\Background\shell
    Set-RegistryKey -Path HKCR:\DesktopBackground\Shell
    Set-RegistryKey -Path HKLM:\SOFTWARE\Classes\Drive\shell
    Set-RegistryKey -Path HKLM:\SOFTWARE\Classes\Directory\shell
    Set-RegistryKey -Path HKLM:\SOFTWARE\Classes\Directory\background\shell
    Set-RegistryKey -Path HKLM:\SOFTWARE\Classes\DesktopBackground\Shell
    Set-RegistryKey -Path HKLM:\SOFTWARE\Classes\LibraryFolder\background\shell

    Set-RegistryKeyWithCommand -Path HKCR:\Directory\ContextMenus
    Set-RegistryKeyWithCommand -Path HKCR:\SOFTWARE\Classes\Directory\ContextMenus

    New-ItemProperty -Path HKCR:\Directory\ContextMenus\$registryKeyName\shell\runas -Name MUIVerb -Value $OpenHereAsAdmin -Force | Write-Verbose
    New-ItemProperty -Path HKCR:\Directory\ContextMenus\$registryKeyName\shell\runas -Name Icon -Value $iconFile.FullName -Force | Write-Verbose
    New-ItemProperty -Path HKCR:\Directory\ContextMenus\$registryKeyName\shell\runas -Name HasLUAShield -Value "" -Force | Write-Verbose

    New-ItemProperty -Path HKCR:\Directory\ContextMenus\$registryKeyName\shell\openpowershell -Name MUIVerb -Value $OpenHere -Force | Write-Verbose
    New-ItemProperty -Path HKCR:\Directory\ContextMenus\$registryKeyName\shell\openpowershell -Name Icon -Value $iconFile.FullName -Force | Write-Verbose

    Write-Host "The configuration of Open here shortucut has been completed."
}

function Remove-OpenHereWindowsPowerShellShortcut
{
        <#
    .SYNOPSIS
        Removes the Open here shortcut.
    .DESCRIPTION
        Removes the Open here shortcut from all locations in the system shell.
    .EXAMPLE
        PS C:\> Remove-OpenHereWindowsPowerShellShortcut
        Removes the default shortcut in the system.
    .EXAMPLE
        PS C:\> Remove-OpenHereWindowsPowerShellShortcut -Verbose
        Removes the default shortcut from the system and the removing process will be verbose to user.
    .LINK
        https://github.com/KUTlime/PowerShell-Open-Here-Module
    .INPUTS
        void
    .OUTPUTS
        The shell shortcut is removed from the context menu.
    .NOTES
        The context menu can be invoked from the menu button and by the right mouse button click.
        On some system, the some error can occur during removal process. These errors are mostly harmless.
    #>
    [CmdletBinding()]
    Param (
    )
    $registryKeyName = 'WindowsPowerShell'

    function Remove-RegistryKey
    {
        [CmdletBinding()]
        param (
            [Parameter()]
            [String]
            $Path
        )
        Remove-Item -Path $Path\$registryKeyName -Force -ErrorAction:Continue | Write-Verbose
    }

    function Remove-RegistryKeyWithCommand
    {
        [CmdletBinding()]
        param (
            [Parameter()]
            [String]
            $Path
        )
        Remove-Item -Path $Path\$registryKeyName\shell\runas\command -Force -ErrorAction:Continue | Write-Verbose
        Remove-Item -Path $Path\$registryKeyName\shell\openpowershell\command -Force -ErrorAction:Continue | Write-Verbose
    }

    $ShellType = Get-ShellType -ShellType $registryKeyName
    Get-IconAsset -ShellType $ShellType
    Get-ChildItem -Path "$env:LOCALAPPDATA\OpenHere\$ShellType\Icon.ico" | Remove-Item -Force | Write-Verbose
    New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR | Write-Verbose

    Remove-RegistryKey -Path HKCR:\LibraryFolder\background\shell
    Remove-RegistryKey -Path HKCR:\Drive\shell
    Remove-RegistryKey -Path HKCR:\Directory\shell
    Remove-RegistryKey -Path HKCR:\Directory\Background\shell
    Remove-RegistryKey -Path HKCR:\DesktopBackground\Shell
    Remove-RegistryKey -Path HKLM:\SOFTWARE\Classes\Drive\shell
    Remove-RegistryKey -Path HKLM:\SOFTWARE\Classes\Directory\shell
    Remove-RegistryKey -Path HKLM:\SOFTWARE\Classes\Directory\background\shell
    Remove-RegistryKey -Path HKLM:\SOFTWARE\Classes\DesktopBackground\Shell
    Remove-RegistryKey -Path HKLM:\SOFTWARE\Classes\LibraryFolder\background\shell

    Remove-RegistryKeyWithCommand -Path HKCR:\Directory\ContextMenus
    Remove-RegistryKeyWithCommand -Path HKCR:\SOFTWARE\Classes\Directory\ContextMenus

    Write-Host "The configuration of Open here shortucut has been removed."
}


Function Get-Icon
{
    <#
      .SYNOPSIS
      Extracts an icon from EXE file.
      .DESCRIPTION
      Get-Icon extracts the icon image from an exe file.
      .PARAMETER Path
      Specifies a path to the EXE file from the icon should be extracted. The input can be a string or a valid instance of the System.IO.FileInfo class.
      .EXAMPLE
      Get-Icon -Path $env:SystemRoot\system32\WindowsPowerShell\v1.0\powershell.exe
      .NOTES
      - Non-public function so far.
      .LINK
      https://github.com/KUTlime/PowerShell-Open-Here-Module
      .INPUTS
      System.String
      System.IO.FileInfo
      .OUTPUTS
      An icon extracted from the input EXE file.
  #>
    [CmdletBinding()]
    [OutputType([System.Drawing.Icon])]
    Param (
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false,
            Position = 0,
            ParameterSetName = 'Basic')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( -Not ($_ | Test-Path) )
                {
                    throw "EXE file does not exist"
                }
                return $true
            })]
        [System.IO.FileInfo]
        $Path
    )

    [System.Reflection.Assembly]::LoadWithPartialName('System.Drawing') | Write-Verbose
    Write-Output -InputObject ([System.Drawing.Icon]::ExtractAssociatedIcon($Path.FullName))
}

Function Out-Icon
{
    <#
      .SYNOPSIS
      Saves the input icon to file.
      .DESCRIPTION
      Out-Icon saves the icon as bitmap image to the file specified with as input file name.
      .PARAMETER FilePath
      Specifies a FilePath to the EXE file from the icon should be extracted. The input can be a string or a valid instance of the System.IO.FileInfo class.
      .EXAMPLE
      Get-Icon -Path $env:SystemRoot\system32\WindowsPowerShell\v1.0\powershell.exe | Out-Icon -FilePath D:\Icon.ico
      .NOTES
      - This function is a simple wrapper for OutFile and a call of ToBitmap().Save(FilePath) method from the input icon instance.
      .LINK
      https://github.com/KUTlime/PowerShell-Open-Here-Module
      .INPUTS
      System.String
      .OUTPUTS
      An icon stored as bitmap file in the specified file path.
  #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false,
            Position = 0,
            ParameterSetName = 'Basic')]
        [ValidateNotNullOrEmpty()]
        [System.Drawing.Icon]
        $Icon,
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false,
            Position = 1,
            ParameterSetName = 'Basic')]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $FilePath

    )
    New-Item -Path ([System.IO.Path]::GetDirectoryName($FilePath)) -ItemType Directory -ErrorAction:SilentlyContinue
    [System.Reflection.Assembly]::LoadWithPartialName('System.Drawing') | Write-Verbose
    $Icon.ToBitmap().Save("$FilePath")
}