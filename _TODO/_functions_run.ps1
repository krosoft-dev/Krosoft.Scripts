 function StartProjet() {          
    Write-Host "=========================================="
    Write-Host "StartProjet : "$global:projet
    Write-Host "==========================================" 
    
    DockerUp "infrastructure"
    # DockerUpAndBuild "services"
    EfUpdateProjet  
}

function StopProjet() {     
     
    Write-Host "=========================================="
    Write-Host "StopProjet : "$global:projet
    Write-Host "==========================================" 
    
    DockerDown "infrastructure"
    DockerDown "services"
  
}
