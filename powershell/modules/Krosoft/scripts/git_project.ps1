function GitCloneProjet($configuration) {    
    Write-Host "Starting: GitCloneProjet" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $currentPath = Get-Location
    $finalPath = Join-Path -Path $currentPath -ChildPath $configuration.projectBasePath    
    Set-Location $finalPath
    Write-Host "Current Path             : " $currentPath
    Write-Host "Final Path               : " $finalPath 
    Write-Host "ProjectName              : " $configuration.projectName 
    Write-Host "Url Git                  : " $configuration.azureDevops.urlGit
    Write-Host "Use Ssh                  : " $configuration.azureDevops.useSsh
    Write-Host "=============================================================================="    

    foreach ($repo in $configuration.repositories) {  
        if ($($configuration.azureDevops.useSsh) -eq "true") {
            $repositoryUrl = "$($configuration.azureDevops.urlGit)/$($configuration.projectName)/$($repo.name)"       
        }
        else {
            $repositoryUrl = "$($configuration.azureDevops.urlGit)/$($configuration.projectName)/_git/$($repo.name)"
        }       
       
        GitClone $repositoryUrl       
    }   
 
    Set-Location $currentPath
    Write-Host "Finishing: GitCloneProjet" -ForegroundColor Green
    Write-Host
    Write-Host 
}


function GitPullProjet($configuration, $branch) {    
    Write-Host "Starting: GitPullProjet" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $currentPath = Get-Location
    $finalPath = Join-Path -Path $currentPath -ChildPath $configuration.projectBasePath    
    Set-Location $finalPath
    Write-Host "ProjectName            : " $configuration.projectName
    Write-Host "Branch                 : " $branch
    Write-Host "=============================================================================="  
    foreach ($repo in $configuration.repositories) {      
        $path = Get-Location 
        Set-Location $repo.name
        GitPull $branch 
        Set-Location $path  
    }   
    Set-Location $currentPath
    Write-Host "Finishing: GitPullProjet" -ForegroundColor Green
    Write-Host
    Write-Host 
}
function GitBranchesProjet($configuration ) {    
    Write-Host "Starting: GitBranchesProjet" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $currentPath = Get-Location
    $finalPath = Join-Path -Path $currentPath -ChildPath $configuration.projectBasePath    
    Set-Location $finalPath
    Write-Host "ProjectName            : " $configuration.projectName   
    Write-Host "=============================================================================="  
    foreach ($repo in $configuration.repositories) {      
        $path = Get-Location 
        Set-Location $repo.name
        GitBranches  
        Set-Location $path  
    }      
    Set-Location $currentPath
    Write-Host "Finishing: GitBranchesProjet" -ForegroundColor Green
    Write-Host
    Write-Host 
}
function GitPushProjet($configuration) {    
    Write-Host "Starting: GitPushProjet" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $currentPath = Get-Location
    $finalPath = Join-Path -Path $currentPath -ChildPath $configuration.projectBasePath    
    Write-Host "ProjectName            : " $configuration.projectName   
    Write-Host "=============================================================================="  
    foreach ($repo in $configuration.repositories) {      
        $path = Get-Location 
        Set-Location $repo.name
        GitPush  
        Set-Location $path  
    }   
    Set-Location $currentPath
    Write-Host "Finishing: GitPushProjet" -ForegroundColor Green
    Write-Host
    Write-Host 
} 

function GitCommitPushProjet($configuration, $commitName) {    
    Write-Host "Starting: GitCommitPushProjet" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $currentPath = Get-Location
    $finalPath = Join-Path -Path $currentPath -ChildPath $configuration.projectBasePath    
    Set-Location $finalPath 
    Write-Host "ProjectName            : " $configuration.projectName   
    Write-Host "Commit                 : " $commitName
    Write-Host "=============================================================================="  
    foreach ($repo in $configuration.repositories) {      
        $path = Get-Location 
        Set-Location $repo.name
        GitCommitPush $commitName
        Set-Location $path  
    }   
    Set-Location $currentPath
    Write-Host "Finishing: GitCommitPushProjet" -ForegroundColor Green
    Write-Host
    Write-Host 
}

 
function GitCleanProjet($configuration) {    
    Write-Host "Starting: GitCleanProjet" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $currentPath = Get-Location
    $finalPath = Join-Path -Path $currentPath -ChildPath $configuration.projectBasePath    
    Set-Location $finalPath
    Write-Host "ProjectName            : " $configuration.projectName    
    Write-Host "=============================================================================="  
    foreach ($repo in $configuration.repositories) {      
        $path = Get-Location 
        Set-Location $repo.name
        GitClean  
        Set-Location $path  
    }   
    Set-Location $currentPath
    Write-Host "Finishing: GitCleanProjet" -ForegroundColor Green
    Write-Host
    Write-Host 
}

 
 
function GitRevertProjet($configuration) {    
    Write-Host "Starting: GitRevertProjet" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $currentPath = Get-Location
    $finalPath = Join-Path -Path $currentPath -ChildPath $configuration.projectBasePath    
    Set-Location $finalPath
    Write-Host "ProjectName            : " $configuration.projectName    
    Write-Host "=============================================================================="  
    foreach ($repo in $configuration.repositories) {      
        $path = Get-Location 
        Set-Location $repo.name
        GitRevert  
        Set-Location $path  
    }   
    Set-Location $currentPath
    Write-Host "Finishing: GitRevertProjet" -ForegroundColor Green
    Write-Host
    Write-Host 
}

 