Function GetRepositoriesPerPage($page, $pageSize) {

    $URL = "https://gitlab.com/api/v4/projects/$global:gitlabId/registry/repositories?per_page=$pageSize&page=$page"

    Write-Host "=========================================="
    Write-Host "GetRepositoriesPerPage (pageSize) : "$pageSize
    Write-Host "GetRepositoriesPerPage (page) : "$page
    Write-Host "GetRepositoriesPerPage (URL) : "$URL
    Write-Host "=========================================="

    $global:response = Invoke-WebRequest -UseBasicParsing $URL -Headers @{'PRIVATE-TOKEN' = $global:gitlab.token }
    $json = $global:response | ConvertFrom-Json
    $repositories = $json | Select-Object -Property project_id, id, name

    foreach ($repository in $repositories) {

        $global:allRepositories += $repository
    }
}

Function GetRepositories($token) {
    $global:allRepositories = New-Object System.Collections.ArrayList @()
    $pageNumber = 1
    $pageSize = 50

    do {
        GetRepositoriesPerPage $pageNumber $pageSize
        $pageNumber++
    } while ($global:response.Headers.Link.Contains('rel="next"'))

    $global:allRepositories
    return
}

function RegistryRepositoriesProjet() {
    $organization = $global:gitlab.organization
    Write-Host "=========================================="
    Write-Host "RegistryRepositoriesProjet : $global:gitlabName ($organization)"
    Write-Host "==========================================" 
    GetRepositories $global:gitlab.token
}

function RegistryRepositoriesInit($label) {
    $organization = $global:gitlab.organization
    Write-Host "=========================================="
    Write-Host "RegistryRepositoriesInit : $global:gitlabName ($organization)"
    Write-Host "==========================================" 

    $repository = $global:repositories | Where-Object label -EQ $label      
    if ($null -eq $repository ) {
        Write-Warning "Le label '$label' n'a pas permis de trouver le repository."
        Exit
    }

    $image = "registry.gitlab.com/adneom-rhone-alpes/$global:gitlabName/${label}:0.0.0"
    $registryUrl = "registry.gitlab.com/adneom-rhone-alpes/$global:gitlabName/"
    
    docker login $registryUrl -u $global:gitlab.login -p $global:gitlab.token
    docker pull hello-world
    docker tag hello-world $image

    Write-Host "=========================================="
    Write-Host "Push :  $image"
    Write-Host "Url :  $registryUrl"
    Write-Host "==========================================" 
    docker push $image
}

function RegistryRepositoriesAll() {
    $organization = $global:gitlab.organization
    Write-Host "=========================================="
    Write-Host "RegistryRepositoriesAll : $global:gitlabName ($organization)"
    Write-Host "=========================================="  

    foreach ($repo in $global:repositories) {        
        RegistryRepositoriesInit $repo.label 
    } 
}




function RegistryTagsCleanProjet($repositoryId) {
    $organization = $global:gitlab.organization
    Write-Host "=========================================="
    Write-Host "RegistryTagsCleanProjet : $global:gitlabName ($organization)"
    Write-Host "==========================================" 
    
    $URL = "https://gitlab.com/api/v4/projects/$global:gitlabId/registry/repositories/$repositoryId/tags"

    Write-Host "=========================================="    
    Write-Host "Url : "$URL
    Write-Host "=========================================="

    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("PRIVATE-TOKEN", $global:gitlab.token)
    $headers.Add("Content-Type", "application/x-www-form-urlencoded")

    $body = "keep_n=10&name_regex_delete=.*"

    try {
        $response = Invoke-RestMethod $URL -Method 'DELETE' -Headers $headers -Body $body -ErrorVariable RespErr; 
        $response | ConvertTo-Json
    }
    catch {
        Write-Host "ERR : ";
       
        Write-Warning $_.Exception
        Write-Warning $RespErr 
    }
}   
    
    
    
Function RegistryTagsLastProjetPerPage($repositoryId, $page, $pageSize) {
    
    $URL = "https://gitlab.com/api/v4/projects/$global:gitlabId/registry/repositories/$repositoryId/tags?per_page=$pageSize&page=$page"

    Write-Host "==========================================" 
    Write-Host "Url : "$URL
    Write-Host "=========================================="

    $global:response = Invoke-WebRequest -UseBasicParsing $URL -Headers @{'PRIVATE-TOKEN' = $global:gitlab.token } 
    $json = $global:response | ConvertFrom-Json  
    $tags = $json | Select-Object name

    foreach ($tag in $tags) { 
        $global:allTags += $tag         
    }
}


function RegistryTagsLastProjet($repositoryId) {
    $organization = $global:gitlab.organization
    Write-Host "=========================================="
    Write-Host "RegistryTagsLastProjet : $global:gitlabName ($organization)"
    Write-Host "==========================================" 
  
    try {
    
        $global:allTags = New-Object System.Collections.ArrayList @()
        $pageNumber = 1
        $pageSize = 50
    
        do {
            RegistryTagsLastProjetPerPage $repositoryId $pageNumber $pageSize
            $pageNumber++  
    
    
            Write-Host "=========================================="
            Write-Host "RequestWithPage (Link) : "$global:response.Headers.Link
            Write-Host "=========================================="
    
                
    
        } while ($global:response.Headers.Link.Contains('n'))
    
    
        $versions = @()
        foreach ($tag in $global:allTags ) {
            try {
                $name = $tag.name
                $v = [version]$name
                $versions += $v
            } 
            catch {  
                Write-Warning "Impossible de déterminer une version à partir du tag : $name"
                Write-Warning $_.Exception
            } 
        }
    
        $sortedVersions = $versions | Sort-Object 
        $lastVersion = $sortedVersions[-1]
        Write-Host "Last : $lastVersion" 
    }
    catch {
        Write-Warning "Impossible de déterminer une version : "	
        Write-Warning $_.Exception
        Exit        
    }
    
    $versionStringIncremented = [string][version]::New($lastVersion.Major, $lastVersion.Minor, $lastVersion.Build + 1)
    Write-Host "Next : $versionStringIncremented"  
    $versionStringIncremented
    return 
}
