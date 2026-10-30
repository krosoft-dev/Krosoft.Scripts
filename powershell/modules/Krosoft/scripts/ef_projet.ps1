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


 
function EfRebuildProjet($configuration) {    
    Write-Host "Starting: EfRebuildProjet" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $path = Get-Location
    Write-Host "Path                     : " $path 
    Write-Host "ProjectName              : " $configuration.projectName 
    Write-Host "=============================================================================="  
    foreach ($repo in $configuration.Repositories_migration) {           
        EfRebuildService $repo.name   
    }   
    Write-Host "Finishing: EfRebuildProjet" -ForegroundColor Green
    Write-Host
    Write-Host 
} 


 
function EfAddMigrationProjet($configuration) {    
    Write-Host "Starting: EfAddMigrationProjet" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $path = Get-Location
    Write-Host "Path                     : " $path 
    Write-Host "ProjectName              : " $configuration.projectName 
    Write-Host "=============================================================================="  
    foreach ($repo in $configuration.Repositories_migration) {           
        EfAddMigrationService $repo.name   
    }   
    Write-Host "Finishing: EfAddMigrationProjet" -ForegroundColor Green
    Write-Host
    Write-Host 
} 


 
