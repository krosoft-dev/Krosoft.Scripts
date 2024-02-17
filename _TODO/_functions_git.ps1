
function DuplicateRepositoryGit($folder, $project_partial_name , $source_project , $destination_project) {   
    $path = Get-Location
    
    $url = $global:azureDevops.url

    $source_project_name = "$source_project$project_partial_name"
    $source_folder = [IO.Path]::Combine($folder, $source_project_name)
    $source_repo_url = "$url$source_project/_git/$source_project_name"

    $destination_project_name = "$destination_project$project_partial_name"
    $destination_folder = [IO.Path]::Combine($folder, $destination_project_name)
    $destination_repo_url = "$url$destination_project/_git/$destination_project_name"

    Write-Host "=========================================="
    Write-Host "Duplicate the repository : $source_project_name vers $destination_project_name"
    Write-Host "=========================================="  
    
    Write-Host "=========================================="
    Write-Host "Source"
    Write-Host "Cloning the repository : $source_repo_url"
    Write-Host "In the folder : $source_folder"
    Write-Host "=========================================="  
    RemoveItemIfExist $source_folder   
    Set-Location $folder
    git clone $source_repo_url
    Set-Location $source_folder
    git remote rm origin
    git add .
    git commit -m "Init"
    
    Write-Host "=========================================="
    Write-Host "Destination"
    Write-Host "Cloning the repository : $destination_repo_url"
    Write-Host "In the folder : $destination_folder"
    Write-Host "=========================================="
    RemoveItemIfExist $destination_folder 
    Set-Location $folder
    git clone $destination_repo_url
    Set-Location $destination_folder  
    git checkout -b develop  
    git remote add "feature/init" $source_folder
    git pull "feature/init" develop --allow-unrelated-histories
    git remote rm "feature/init"
    git push --set-upstream origin develop
    git push 
    
    # Clean du dossier "Source"
    RemoveItemIfExist $source_folder
    
    # Retour au chemin de base
    Set-Location $path
}
 









function GitConfig($repositoryName) {    
    $path = Get-Location
    Set-Location $repositoryName  
    $repositoryPath = Get-Location
    Write-Host "=========================================="
    Write-Host "Configure the repository: "$repositoryName
    Write-Host "Path : " $repositoryPath
    Write-Host "=========================================="
    git config user.name $global:git.name
    git config user.email $global:git.email
    git config user.name
    git config user.email 
    Set-Location $path   
} 


function GitConfigProjet() {     
     
    Write-Host "=========================================="
    Write-Host "GitConfigProjet : "$global:projet
    Write-Host "==========================================" 
    
    foreach ($repo in $global:repositories) {        
        GitConfig $repo.name 
    }   
}







function GitClean($repositoryName) {    
    $path = Get-Location
    Set-Location $repositoryName  
    $repositoryPath = Get-Location
    Write-Host "=========================================="
    Write-Host "Clean branch of repository: "$repositoryName
    Write-Host "Path : " $repositoryPath
    Write-Host "=========================================="
    git fetch origin --prune
    git branch -vv | where { $_ -match '\[origin/.*: gone\]' } | foreach { git branch -D ($_.split(" ", [StringSplitOptions]'RemoveEmptyEntries')[0]) }
    Set-Location $path  
} 


function GitCleanProjet() {     
     
    Write-Host "=========================================="
    Write-Host "GitCleanProjet : "$global:projet
    Write-Host "==========================================" 
    
    foreach ($repo in $global:repositories) {        
        GitClean $repo.name 
    }   
}

function GitRevert($repositoryName) {    
    $path = Get-Location
    Set-Location $repositoryName  
    $repositoryPath = Get-Location
    Write-Host "=========================================="
    Write-Host "Clean untracked changes of repository: "$repositoryName
    Write-Host "Path : " $repositoryPath
    Write-Host "=========================================="
    git clean -fd
    git reset --hard
    git checkout
    Set-Location $path  
} 


function GitRevertProjet() {     
     
    Write-Host "=========================================="
    Write-Host "GitRevertProjet : "$global:projet
    Write-Host "==========================================" 
    
    foreach ($repo in $global:repositories) {        
        GitRevert $repo.name 
    }   
}

function GitRename($repositoryName, $old_name, $new_name) {    
    $path = Get-Location
    Set-Location $repositoryName  
    $repositoryPath = Get-Location
    Write-Host "=========================================="
    Write-Host "Renaming the repository: "$repositoryName
    Write-Host "Path : " $repositoryPath     
    Write-Host "$repo $old_name > $new_name"
    Write-Host "=========================================="  
    git checkout $old_name
    git branch -m $new_name
    git push origin -u $new_name
    git push origin --delete $old_name
    Set-Location $path  
} 


function GitRenameProjet() {     
     
    Write-Host "=========================================="
    Write-Host "GitRenameProjet : "$global:projet
    Write-Host "==========================================" 
    
    $old_name = "master"
    $new_name = "develop"

    foreach ($repo in $global:repositories) {        
        GitRevert $repo.name $old_name $new_name
    }   
}

 