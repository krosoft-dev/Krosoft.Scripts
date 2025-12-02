function DotnetBuild($project) {    
    Write-Host -fore green "=========================================="
    Write-Host -fore green "Build dotnet project(s)..."
    Write-Host -fore green "=========================================="
    $path = Get-Location
    Write-Host "Path : " $path
    Write-Host -fore green "=========================================="
    dotnet build .    
    Write-Host -fore green "=========================================="
    Write-Host  
    Write-Host  
}
Set-Alias KDB DotnetBuild