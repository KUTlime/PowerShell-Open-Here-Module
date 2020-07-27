Write-Host "Test"
Write-Output "Test to output stream."
if ($env:NUGETAPIKEY)
{
    Write-Host "Api key exist."
}