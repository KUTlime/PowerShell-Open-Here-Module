function Get-IconAsset
{
  New-Item "$env:LOCALAPPDATA\WindowsPowerShell" -ItemType Directory -Force
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  $wc = New-Object System.Net.WebClient
  $wc.DownloadFile('https://raw.githubusercontent.com/KUTlime/PowerShell-Open-Here-Module/master/assets/PowerShell.ico', "$env:LOCALAPPDATA\WindowsPowerShell\PowerShell.ico")
}

function Set-WindowsPowerShellShortcut
{
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
    Get-IconAsset
    $iconFile = Get-ChildItem -Path $env:LOCALAPPDATA\WindowsPowerShell\PowerShell.ico
    New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR | Write-Verbose
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

    New-ItemProperty -Path HKCR:\Directory\ContextMenus\$registryKeyName\shell\runas -Name MUIVerb -Value $OpenHereAsAdmin -Force
    New-ItemProperty -Path HKCR:\Directory\ContextMenus\$registryKeyName\shell\runas -Name Icon -Value $iconFile.FullName -Force
    New-ItemProperty -Path HKCR:\Directory\ContextMenus\$registryKeyName\shell\runas -Name HasLUAShield -Value "" -Force

    New-ItemProperty -Path HKCR:\Directory\ContextMenus\$registryKeyName\shell\openpowershell -Name MUIVerb -Value $OpenHere -Force
    New-ItemProperty -Path HKCR:\Directory\ContextMenus\$registryKeyName\shell\openpowershell -Name Icon -Value $iconFile.FullName -Force
}

function Remove-WindowsPowerShellShortcut
{
    [CmdletBinding()]
    Param (
    )
    throw [System.NotImplementedException]::new()
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