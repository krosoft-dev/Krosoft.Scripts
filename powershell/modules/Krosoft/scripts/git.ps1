function GitVersion {
    git --version
}
Set-Alias KGV GitVersion

function GitClean {
    Write-Host "=========================================="
    Write-Host "Clean repository"
    Write-Host "=========================================="
    $path = Get-Location
    Write-Host "Path : " $path
    Write-Host "=========================================="
    git pull
    git fetch origin --prune
    git branch -vv | Where-Object { $_ -match '\[origin/.*: gone\]' } | ForEach-Object { git branch -D ($_.split(" ", [StringSplitOptions]'RemoveEmptyEntries')[0]) }
    Write-Host  
}
Set-Alias KGC GitClean

function GitPull {
    Write-Host "=========================================="
    Write-Host "Pull repository"
    Write-Host "=========================================="
    $path = Get-Location
    Write-Host "Path : " $path
    Write-Host "=========================================="
    git pull
    Write-Host        
}
Set-Alias KGP GitPull
function GitClone($repository) {
    Write-Host "=========================================="
    Write-Host "Clone repository : "$repository
    Write-Host "=========================================="
    $path = Get-Location
    Write-Host "Path : " $path
    Write-Host "=========================================="
    git clone $repository
    Write-Host        
}
Set-Alias KGClo GitClone