
function NodeInstall($repositoryName) {    
    $path = Get-Location
    Set-Location $repositoryName  
    $repositoryPath = Get-Location
    Write-Host "=========================================="
    Write-Host "Install node : "$repositoryName
    Write-Host "Path : " $repositoryPath
    Write-Host "=========================================="
    npm i
    Set-Location $path  
} 


function NodeInstallProjet() {     
     
    Write-Host "=========================================="
    Write-Host "NodeInstallProjet : "$global:projet
    Write-Host "==========================================" 
    
    foreach ($repo in $global:repositories_node) {        
        NodeInstall $repo.name 
    }   
}




 
