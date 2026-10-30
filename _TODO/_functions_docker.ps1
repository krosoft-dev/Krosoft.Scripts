
function DockerUp($folder) {    
    Write-Host "=========================================="
    Write-Host "Docker Compose Up: "$folder
    Write-Host "==========================================" 
    docker-compose -f "$global:projet\docker-compose\$folder\docker-compose.yml" --compatibility -f "$global:projet\docker-compose\$folder\docker-compose.override.yml" up -d 
} 
 
function DockerUpAndBuild($folder) {    
    Write-Host "=========================================="
    Write-Host "Docker Compose Up (with build): "$folder
    Write-Host "==========================================" 
    docker-compose -f "$global:projet\docker-compose\$folder\docker-compose.yml" --compatibility -f "$global:projet\docker-compose\$folder\docker-compose.override.yml" up -d --build --force-recreate --remove-orphans 
} 

function DockerUpAndBuildProjet($projet) {    
    Write-Host "=========================================="
    Write-Host "Docker Compose Up (with build) projet : "$projet
    Write-Host "==========================================" 
    docker-compose -f "$projet\docker-compose\docker-compose.yml" -f "$projet\docker-compose\docker-compose.override.yml" up --compatibility -d --build --force-recreate --remove-orphans 
} 
 
function DockerDown($folder) {    
    Write-Host "=========================================="
    Write-Host "Docker Compose Down: "$folder
    Write-Host "==========================================" 
    docker-compose --compatibility -f "$global:projet\docker-compose\$folder\docker-compose.yml" -f "$global:projet\docker-compose\$folder\docker-compose.override.yml" down
}  
 
function DockerDownProjet($projet) {    
    Write-Host "=========================================="
    Write-Host "Docker Compose Down projet : "$projet
    Write-Host "==========================================" 
    docker-compose --compatibility -f "$projet\docker-compose\docker-compose.yml" -f "$projet\docker-compose\docker-compose.override.yml" down
} 
 


 
 

 
