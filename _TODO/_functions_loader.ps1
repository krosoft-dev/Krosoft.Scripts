function LoadConfigurationProjet($jsonPath) {    
    Write-Host "=========================================="
    Write-Host "LoadConfigurationProjet : "$jsonPath
    Write-Host "=========================================="
    $jsonProjet = Get-Content -Raw -Path $jsonPath | ConvertFrom-Json  
    $global:projet = $jsonProjet.name
    $global:gitlabId = $jsonProjet.gitlabId
    $global:gitlabName = $jsonProjet.gitlabName
    $global:repositories = $jsonProjet.repositories
    $global:repositories_migration = [array] ($global:repositories | Where-Object { $_.useMigration -eq "true" })
    $global:repositories_node = [array] ($global:repositories | Where-Object { $_.useNode -eq "true" })
    Write-Host "=========================================="
    Write-Host "=========================================="
    Write-Host "Project : " $global:projet
    Write-Host "Gitlab Id : " $global:gitlabId
    Write-Host "Gitlab name : " $global:gitlabName
    Write-Host "Repositories : "($global:repositories).length
    Write-Host "Repositories 'Node' : "($global:repositories_node).length
    Write-Host "Repositories 'Migration' : "($global:repositories_migration).length
    Write-Host "=========================================="
} 

function LoadConfigurationInfrastructure() {     
    $jsonPath = "$PSScriptRoot\..\positive.infrastructure.json"
    Write-Host "=========================================="
    Write-Host "LoadConfigurationInfrastructure : "$jsonPath
    Write-Host "=========================================="
    $jsonInfra = Get-Content -Raw -Path $jsonPath | ConvertFrom-Json 
    $global:git = $jsonInfra.git 
    $global:azureDevops = $jsonInfra.azureDevops 
    $global:gitlab = $jsonInfra.gitlab
    Write-Host "=========================================="
    Write-Host "OrganizationUrl : " $global:azureDevops.organization 
    Write-Host "=========================================="
}
