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