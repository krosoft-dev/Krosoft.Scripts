function GitVersion {
    git --version
}
Set-Alias KGV GitVersion

function GitClean {
    Write-Host "=========================================="
    Write-Host "Clean branch of Repository"
    Write-Host "=========================================="
    $path = Get-Location
    Write-Host "Path : " $path
    Write-Host "=========================================="
    git pull
    git fetch origin --prune
    git branch -vv | where { $_ -match '\[origin/.*: gone\]' } | foreach { git branch -D ($_.split(" ", [StringSplitOptions]'RemoveEmptyEntries')[0]) }
    Write-Host  
}
Set-Alias KGC GitClean