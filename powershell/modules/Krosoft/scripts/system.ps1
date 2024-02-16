function GetSystemInfo() {
Write-Host "=========================================="
Write-Host "Get-System-Info : "
$dotnetVersion = dotnet --version
Write-Host "    - dotnet : "$dotnetVersion
$nodeVersion = node --version
Write-Host "    - node : "$nodeVersion
$gitVersion = git --version
Write-Host "    - git : "$gitVersion
Write-Host "=========================================="
}
Set-Alias KSI GetSystemInfo