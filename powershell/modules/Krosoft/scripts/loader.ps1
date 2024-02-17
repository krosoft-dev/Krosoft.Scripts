function LoadConfiguration($jsonPath ) {     
    Write-Host "Starting: LoadConfiguration" -ForegroundColor Green
    Write-Host "=============================================================================="
    Write-Host "Path         : "$jsonPath  
    Write-Host "=============================================================================="  
    
    # Charger le contenu JSON
    $configuration = Get-Content -Raw -Path $jsonPath | ConvertFrom-Json  
   
    # Définir les propriétés comme tableau vide
    $configuration | Add-Member -MemberType NoteProperty -Name Repositories_migration -Value @()
    $configuration | Add-Member -MemberType NoteProperty -Name Repositories_node -Value @()

    # Filtrer et ajouter les éléments
    $configuration.Repositories_migration = [array] ($configuration.repositories | Where-Object { $_.useMigration -eq "true" })
    $configuration.Repositories_node = [array] ($configuration.repositories | Where-Object { $_.useNode -eq "true" })


    Write-Host "ProjectName : " $configuration.projectName 
    Write-Host
    Write-Host "Finishing: LoadConfiguration" -ForegroundColor Green
    Write-Host
    Write-Host  
    return $configuration
} 

function ShowConfiguration($configuration) {    
    Write-Host "Starting: ShowConfiguration" -ForegroundColor Green 
   
   
    # Write-Host "OrganizationUrl : " $obj.azureDevops.organization 
    Write-Host "ProjectName : " $configuration.projectName
    Write-Host "DockerComposeFolder : " $configuration.DockerComposeFolder
    Write-Host "AzureDevops:Organization : " $configuration.azureDevops.organization

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

 