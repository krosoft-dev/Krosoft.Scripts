function GetSystemInfo() {
    Write-Host "Starting: GetSystemInfo" -ForegroundColor Green
    Write-Host "=============================================================================="
    $dotnetVersion = dotnet --version
    Write-Host "dotnet         : "$dotnetVersion  
    $nodeVersion = node --version
    Write-Host "node           : "$nodeVersion
    $gitVersion = git --version
    Write-Host "git            : "$gitVersion
    Write-Host "=============================================================================="  
    Write-Host "Finishing: GetSystemInfo" -ForegroundColor Green
    Write-Host
    Write-Host     
}
Set-Alias KSI GetSystemInfo