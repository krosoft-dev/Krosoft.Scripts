function EfUpdateService($projet) {   
    Write-Host "Starting: EfUpdateService" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $path = Get-Location
    Write-Host "Projet                     : " $projet 
    Write-Host "Path                       : " $path 
    Write-Host "=============================================================================="  
   
    Set-Location $projet
    $script_ef = ".\scripts\ef_update-database.ps1" 
    . $script_ef  
    Set-Location $path  
    Write-Host "Finishing: EfUpdateService" -ForegroundColor Green
    Write-Host
    Write-Host 
} 


function EfRebuildService($projet) {   
    Write-Host "Starting: EfRebuildService" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $path = Get-Location
    Write-Host "Projet                     : " $projet 
    Write-Host "Path                       : " $path 
    Write-Host "=============================================================================="  
   
    Set-Location $projet
    $script_ef = ".\scripts\ef_rebuild-database.ps1" 
    . $script_ef  
    Set-Location $path  
    Write-Host "Finishing: EfRebuildService" -ForegroundColor Green
    Write-Host
    Write-Host 
} 


function EfAddMigrationService($projet) {   
    Write-Host "Starting: EfAddMigrationService" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $path = Get-Location
    Write-Host "Projet                     : " $projet 
    Write-Host "Path                       : " $path 
    Write-Host "=============================================================================="  
   
    Set-Location $projet
    $script_ef = ".\scripts\ef_add-migration.ps1" 
    . $script_ef  
    Set-Location $path  
    Write-Host "Finishing: EfAddMigrationService" -ForegroundColor Green
    Write-Host
    Write-Host 
} 



function EfUpdate( $context, $startupProject, $projet) { 
    Write-Host "================Update Database=========================="
    Write-Host "Projet : "$projet
    Write-Host "StartupProject : "$startupProject
    Write-Host "Context : "$context
    Write-Host "========================================================="
    dotnet ef database update --context $context -s $startupProject -p $projet
}


function EfUpdateFromJson($json) {   
    Write-Host "=========================================="
    Write-Host "EfUpdateFromJson : "$json.projet $json.startupProjec
    Write-Host "=========================================="
    
    if ($json.startupProject) {
        $startupProject = $json.startupProject
    }
    else {
        $startupProject = $json.projet
    } 

    EfUpdate $json.context $startupProject $json.projet
} 

function EfRemoveMigration($context, $projet) {
    Write-Host "================Remove migration=========================="
    Write-Host "Projet :"$projet
    Write-Host "Context :"$context 
    Write-Host "======================================================="
    dotnet ef migrations remove --context $context -s $projet -p $projet 
}



function EfAddMigration(  $context, $startupProject, $projet, $migration) {
  
    Write-Host "================Add migration=========================="
    Write-Host "Projet :"$projet
    Write-Host "StartupProject :"$startupProject
    Write-Host "Context :"$context
    Write-Host "Migration :"$migration
    Write-Host "======================================================="
    dotnet ef migrations add $migration --context $context -s $startupProject -p $projet
}






function EfRebuild( $context, $projet) { 
    Write-Host "================Rebuild Database=========================="      
    Write-Host "Projet :"$projet
    Write-Host "Context :"$context
    Write-Host "=========================================================="
    dotnet ef database drop --context $context -s $projet -p $projet
    dotnet ef database update --context $context -s $projet -p $projet
}









function EfRemoveMigrationFromJson($json) {    
    Write-Host "=========================================="
    Write-Host "EfRemoveMigrationFromJson : "$json.projet
    Write-Host "=========================================="
    
    EfRemoveMigration $json.context $json.projet
} 

  
function EfUpdateFromJson($json) {    
    Write-Host "=========================================="
    Write-Host "EfUpdateFromJson : "$json.projet $startupProjec
    Write-Host "=========================================="
    
    if ($json.startupProject) {
        $startupProject = $json.startupProject
    }
    else {
        $startupProject = $json.projet
    } 

    EfUpdate $json.context $startupProject $json.projet
} 
 
function EfRebuildFromJson($json) {    
    Write-Host "=========================================="
    Write-Host "EfRebuildFromJson : "$json.projet
    Write-Host "=========================================="
    
    EfRebuild $json.context $json.projet
} 
 
function EfAddMigrationFromJson($json) {    
    Write-Host "=========================================="
    Write-Host "EfAddMigrationFromJson : "$json.projet
    Write-Host "=========================================="

    if ($json.startupProject) {
        $startupProject = $json.startupProject
    }
    else {
        $startupProject = $json.projet
    } 
    
    EfAddMigration $json.context $startupProject $json.projet $json.migration
} 
