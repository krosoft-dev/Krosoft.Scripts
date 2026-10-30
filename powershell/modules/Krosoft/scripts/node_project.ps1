function NodeInstallProjet($configuration) {    
    Write-Host "Starting: NodeInstallProjet" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $path = Get-Location
    Write-Host "ProjectName            : " $configuration.projectName 
    Write-Host "Repositories 'Node'    : "($configuration.repositories_node).length 
    Write-Host "=============================================================================="  
    foreach ($repo in $configuration.Repositories_node) {      
        $path = Get-Location 
        Set-Location $repo.name
        NodeInstall  
        Set-Location $path  
    }   
    Write-Host "Finishing: NodeInstallProjet" -ForegroundColor Green
    Write-Host
    Write-Host 
} 

function NodeOutdatedProjet($configuration) {    
    Write-Host "Starting: NodeOutdatedProjet" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $path = Get-Location
    Write-Host "ProjectName            : " $configuration.projectName 
    Write-Host "Repositories 'Node'    : "($configuration.repositories_node).length  
    Write-Host "=============================================================================="  
    foreach ($repo in $configuration.Repositories_node) {      
        $path = Get-Location 
        Set-Location $repo.name
        NodeOutdated  
        Set-Location $path  
    }   
    Write-Host "Finishing: NodeOutdatedProjet" -ForegroundColor Green
    Write-Host
    Write-Host 
} 