$psGet = 'PowerShellGet'
$nugetApiKey = $args[0]
Write-Host "Test"
if ($nugetApiKey)
{
    Write-Host "Api key exist."
}
Install-Module -Name $psGet -MinimumVersion '2.2.3'
Import-Module PowerShellGet
Get-Module | Where-Object {$_.Name -eq 'PowerShellGet'}