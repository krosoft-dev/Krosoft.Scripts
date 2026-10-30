function NodeInstall() {  
    Write-Host -fore green "=========================================="
    Write-Host -fore green "Node install..."
    Write-Host -fore green "==========================================" 
    $path = Get-Location
    Write-Host "Path            : " $path
    Write-Host -fore green "==========================================" 
    npm i
    Write-Host -fore green "=========================================="
    Write-Host
    Write-Host 
} 
Set-Alias KNI NodeInstall

function NodeOutdated() {  
    Write-Host -fore green "==========================================" 
    Write-Host -fore green "Node outdated..." 
    Write-Host -fore green "==========================================" 
    $path = Get-Location
    Write-Host "Path            : " $path
    Write-Host -fore green "==========================================" 
    npm outdated
    Write-Host -fore green "=========================================="
    Write-Host
    Write-Host 
} 
Set-Alias KNO NodeOutdated

