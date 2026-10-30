function GetSystemInfo() {
    Write-Host -fore green "=========================================="
    Write-Host -fore green "Get system info..."
    Write-Host -fore green "=========================================="
    $dotnetVersion = dotnet --version
    Write-Host "dotnet         : "$dotnetVersion  
    $nodeVersion = node --version
    Write-Host "node           : "$nodeVersion
    $gitVersion = git --version
    Write-Host "git            : "$gitVersion
    Write-Host -fore green "==========================================" 
    Write-Host
    Write-Host     
}
Set-Alias KSI GetSystemInfo