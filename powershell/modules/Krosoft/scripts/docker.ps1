function DockerUp($configuration, $folder) {   
    Write-Host "Starting: DockerUp" -ForegroundColor Green
    Write-Host "=============================================================================="
    Write-Host "Projet         : "$configuration.projectName
    Write-Host "Folder         : "$folder
    Write-Host "=============================================================================="
    docker-compose --compatibility -f "$($configuration.dockerComposeFolder)\$folder\docker-compose.yml" -f "$($configuration.dockerComposeFolder)\$folder\docker-compose.override.yml" up -d 
    Write-Host
    Write-Host "Finishing: DockerUp" -ForegroundColor Green
    Write-Host
    Write-Host
}  
 
function DockerDown($configuration, $folder) {   
    Write-Host "Starting: DockerDown" -ForegroundColor Green
    Write-Host "=============================================================================="
    Write-Host "Projet         : "$configuration.projectName
    Write-Host "Folder         : "$folder
    Write-Host "=============================================================================="
    docker-compose --compatibility -f "$($configuration.dockerComposeFolder)\$folder\docker-compose.yml" -f "$($configuration.dockerComposeFolder)\$folder\docker-compose.override.yml" down
    Write-Host
    Write-Host "Finishing: DockerDown" -ForegroundColor Green
    Write-Host
    Write-Host
}  
 
# function DockerUpAndBuild($folder) {    
#     Write-Host "=========================================="
#     Write-Host "Docker Compose Up (with build): "$folder
#     Write-Host "==========================================" 
#     docker-compose -f "$global:projet\docker-compose\$folder\docker-compose.yml" --compatibility -f "$global:projet\docker-compose\$folder\docker-compose.override.yml" up -d --build --force-recreate --remove-orphans 
# } 

# function DockerUpAndBuildProjet($projet) {    
#     Write-Host "=========================================="
#     Write-Host "Docker Compose Up (with build) projet : "$projet
#     Write-Host "==========================================" 
#     docker-compose -f "$projet\docker-compose\docker-compose.yml" -f "$projet\docker-compose\docker-compose.override.yml" up --compatibility -d --build --force-recreate --remove-orphans 
# } 
 
# function DockerDownProjet($projet) {    
#     Write-Host "=========================================="
#     Write-Host "Docker Compose Down projet : "$projet
#     Write-Host "==========================================" 
#     docker-compose --compatibility -f "$projet\docker-compose\docker-compose.yml" -f "$projet\docker-compose\docker-compose.override.yml" down
# } 
 


 
 

 
