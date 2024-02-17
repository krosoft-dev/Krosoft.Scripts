function LoadConfiguration($jsonPath ) {     
    Write-Host "Starting: LoadConfiguration" -ForegroundColor Green
    Write-Host "=============================================================================="
    Write-Host "Path         : "$jsonPath  
    Write-Host "=============================================================================="  
    $json = Get-Content -Raw -Path $jsonPath | ConvertFrom-Json  
    # $obj.projet = $jsonProjet.name
    # $obj.gitlabId = $jsonProjet.gitlabId
    # $obj.gitlabName = $jsonProjet.gitlabName
    # $obj.repositories = $jsonProjet.repositories
    $configuration = @{
        Projet                 = $json.name
        DockerComposeFolder    = $json.dockerComposeFolder
        Repositories           = $json.repositories
        Repositories_migration = [array] ($json.repositories | Where-Object { $_.useMigration -eq "true" })
        Repositories_node      = [array] ($json.repositories | Where-Object { $_.useNode -eq "true" })

    } 
    Write-Host "Project : " $configuration.Projet 
    Write-Host
    Write-Host "Finishing: LoadConfiguration" -ForegroundColor Green
    Write-Host
    Write-Host  
    return $configuration
} 

function ShowConfiguration($configuration) {    
    Write-Host "Starting: ShowConfiguration" -ForegroundColor Green 
   
   
    # Write-Host "OrganizationUrl : " $obj.azureDevops.organization 
    Write-Host "Project : " $configuration.Projet
    Write-Host "DockerComposeFolder : " $configuration.DockerComposeFolder

    Write-Host "Repositories : "($configuration.repositories).length
    Write-Host "Repositories 'Node' : "($configuration.repositories_node).length
    Write-Host "Repositories 'Migration' : "($configuration.repositories_migration).length

    # Write-Host "Gitlab Id : " $obj.gitlabId
    # Write-Host "Gitlab name : " $obj.gitlabName
    # Write-Host "Repositories : "($obj.repositories).length
    # Write-Host "Repositories 'Node' : "($obj.repositories_node).length
    # Write-Host "Repositories 'Migration' : "($obj.repositories_migration).length


   
   
   
   
    
    # $obj.projet = $jsonProjet.name
    # $obj.gitlabId = $jsonProjet.gitlabId
    # $obj.gitlabName = $jsonProjet.gitlabName
    # $obj.repositories = $jsonProjet.repositories
    # $obj.repositories_migration = [array] ($obj.repositories | Where-Object { $_.useMigration -eq "true" })
    # $obj.repositories_node = [array] ($obj.repositories | Where-Object { $_.useNode -eq "true" })

 
    

    # Write-Host "OrganizationUrl : " $obj.azureDevops.organization 
   
    # Write-Host "Gitlab Id : " $obj.gitlabId
    # Write-Host "Gitlab name : " $obj.gitlabName
   
 
    Write-Host
    Write-Host "Finishing: ShowConfiguration" -ForegroundColor Green
    Write-Host
    Write-Host     
} 

 