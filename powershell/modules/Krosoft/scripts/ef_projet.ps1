function EfUpdateProjet($configuration) {    
    Write-Host "Starting: EfUpdateProjet" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $path = Get-Location
    Write-Host "Path                     : " $path 
    Write-Host "ProjectName              : " $configuration.projectName 
    Write-Host "=============================================================================="  
    foreach ($repo in $configuration.Repositories_migration) {           
        EfUpdateService $repo.name   
    }   
    Write-Host "Finishing: EfUpdateProjet" -ForegroundColor Green
    Write-Host
    Write-Host 
} 


 
