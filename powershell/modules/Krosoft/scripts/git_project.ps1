function GitCloneProjet($configuration) {    
    Write-Host "Starting: GitCloneProjet" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $path = Get-Location
    Write-Host "ProjectName              : " $configuration.projectName 
    Write-Host "=============================================================================="  
    foreach ($repo in $configuration.repositories) {             
        $path = Get-Location 
        Set-Location $repo.name      
        $repositoryUrl = "$($configuration.azureDevops.urlGit)/$($configuration.projectName)/_git/$($repo.name)"
        GitClone $repositoryUrl
        Set-Location $path  
    }   
    Write-Host "Finishing: GitCloneProjet" -ForegroundColor Green
    Write-Host
    Write-Host 
}
function GitPullProjet($configuration, $branch) {    
    Write-Host "Starting: GitPullProjet" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $path = Get-Location
    Write-Host "ProjectName            : " $configuration.projectName
    Write-Host "Branch                 : " $branch
    Write-Host "=============================================================================="  
    foreach ($repo in $configuration.repositories) {      
        $path = Get-Location 
        Set-Location $repo.name
        GitPull $branch 
        Set-Location $path  
    }   
    Write-Host "Finishing: GitPullProjet" -ForegroundColor Green
    Write-Host
    Write-Host 
}
function GitBranchesProjet($configuration ) {    
    Write-Host "Starting: GitBranchesProjet" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $path = Get-Location
    Write-Host "ProjectName            : " $configuration.projectName   
    Write-Host "=============================================================================="  
    foreach ($repo in $configuration.repositories) {      
        $path = Get-Location 
        Set-Location $repo.name
        GitBranches  
        Set-Location $path  
    }   
    Write-Host "Finishing: GitBranchesProjet" -ForegroundColor Green
    Write-Host
    Write-Host 
}
function GitPushProjet($configuration ) {    
    Write-Host "Starting: GitPushProjet" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $path = Get-Location
    Write-Host "ProjectName            : " $configuration.projectName   
    Write-Host "=============================================================================="  
    foreach ($repo in $configuration.repositories) {      
        $path = Get-Location 
        Set-Location $repo.name
        GitPush  
        Set-Location $path  
    }   
    Write-Host "Finishing: GitPushProjet" -ForegroundColor Green
    Write-Host
    Write-Host 
} 

function GitCommitPushProjet($configuration, $commitName) {    
    Write-Host "Starting: GitCommitPushProjet" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $path = Get-Location
    Write-Host "ProjectName            : " $configuration.projectName   
    Write-Host "Commit                 : " $commitName
    Write-Host "=============================================================================="  
    foreach ($repo in $configuration.repositories) {      
        $path = Get-Location 
        Set-Location $repo.name
        GitCommitPush $commitName
        Set-Location $path  
    }   
    Write-Host "Finishing: GitCommitPushProjet" -ForegroundColor Green
    Write-Host
    Write-Host 
}

 