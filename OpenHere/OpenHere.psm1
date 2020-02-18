function Set-WindowsPowerShellShortcut
{
    [CmdletBinding()]
    param (
    )
    throw [System.NotImplementedException]::new()
}

function Remove-WindowsPowerShellShortcut
{
    [CmdletBinding()]
    param (
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
    [System.Reflection.Assembly]::LoadWithPartialName('System.Drawing') | Write-Verbose
    $Icon.ToBitmap().Save($FilePath)
}