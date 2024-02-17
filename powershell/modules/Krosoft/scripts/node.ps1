function NodeInstall() {  
    Write-Host "Starting: NodeInstall" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $path = Get-Location
    Write-Host "Path            : " $path
    Write-Host "=============================================================================="   
    npm i
    Write-Host "Finishing: NodeInstall" -ForegroundColor Green
    Write-Host
    Write-Host 
} 
Set-Alias KNI NodeInstall

function NodeOutdated() {  
    Write-Host "Starting: NodeOutdated" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $path = Get-Location
    Write-Host "Path            : " $path
    Write-Host "=============================================================================="   
    npm outdated
    Write-Host "Finishing: NodeOutdated" -ForegroundColor Green
    Write-Host
    Write-Host 
} 
Set-Alias KNO NodeOutdated




npm 





 
