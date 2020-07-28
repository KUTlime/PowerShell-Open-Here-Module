$psGet = 'PowerShellGet'
$nugetApiKey = $args[0]
$minimalPSGetVersion = [System.Version]'2.2.3'
if ($nugetApiKey)
{
    Write-Host "Api key exist."
}

Import-Module PowerShellGet
$psGetModule = Get-Module | Where-Object { $_.Name -eq $psGet }
if ($psGetModule.Version -lt $minimalPSGetVersion)
{
    Install-Module -Name $psGet -MinimumVersion '2.2.3'
}

Publish-Module -Name "$PSScriptRoot\OpenHere\" -NuGetApiKey $nugetApiKey