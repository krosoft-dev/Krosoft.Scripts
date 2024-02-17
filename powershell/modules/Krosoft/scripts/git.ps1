function GitVersion {
    git --version
}
Set-Alias KGV GitVersion

function GitClean {
    Write-Host "=========================================="
    Write-Host "Clean repository"
    Write-Host "=========================================="
    $path = Get-Location
    Write-Host "Path : " $path
    Write-Host "=========================================="
    git pull
    git fetch origin --prune
    git branch -vv | Where-Object { $_ -match '\[origin/.*: gone\]' } | ForEach-Object { git branch -D ($_.split(" ", [StringSplitOptions]'RemoveEmptyEntries')[0]) }
    Write-Host  
}
Set-Alias KGC GitClean 

function GitPull($branch) {  
    Write-Host "Starting: GitPull" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $path = Get-Location
    Write-Host "Path            : " $path
    Write-Host "Branch          : " $branch
    Write-Host "=============================================================================="  
    if ($branch) { 
        git checkout $branch
    }
    git pull 
    Write-Host "Finishing: GitPull" -ForegroundColor Green
    Write-Host
    Write-Host 
} 
Set-Alias KGP GitPull

function GitClone($repositoryUrl) {
    Write-Host "Starting: GitClone" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $path = Get-Location
    Write-Host "Path                     : " $path
    Write-Host "RepositoryUrl            : " $repositoryUrl
    Write-Host "=============================================================================="  
    git clone $repositoryUrl
    Write-Host "Finishing: GitClone" -ForegroundColor Green
    Write-Host
    Write-Host 
}
Set-Alias KGClo GitClone

function GitBranches() {  
    Write-Host "Starting: GitBranches" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $path = Get-Location
    Write-Host "Path            : " $path
    Write-Host "=============================================================================="  
    git for-each-ref --format='%(color:cyan)%(authordate:format:%d/%m/%Y %H:%M)    %(align:25,left)%(color:yellow)%(authorname)%(end) %(color:reset)%(refname:strip=3)' --sort=-authordate refs/remotes  
    Write-Host "Finishing: GitBranches" -ForegroundColor Green
    Write-Host
    Write-Host 
} 
Set-Alias KGB GitBranches

function GitPush() {  
    Write-Host "Starting: GitPush" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $path = Get-Location
    Write-Host "Path            : " $path
    Write-Host "=============================================================================="  
    git push
    Write-Host "Finishing: GitPush" -ForegroundColor Green
    Write-Host
    Write-Host 
} 

function GitCommitPush($commitName) {    
    Write-Host "Starting: GitCommitPush" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $path = Get-Location
    Write-Host "Path            : " $path
    Write-Host "Commit          : " $commitName
    Write-Host "=============================================================================="  
    git add .
    git commit -m $commitName
    git push 
    Write-Host "Finishing: GitCommitPush" -ForegroundColor Green
    Write-Host
    Write-Host 
} 





function GitRevert() {    
    Write-Host "Starting: GitRevert" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $path = Get-Location
    Write-Host "Path            : " $path 
    Write-Host "=============================================================================="  
    git clean -fd
    git reset --hard
    git checkout 
    Write-Host "Finishing: GitRevert" -ForegroundColor Green
    Write-Host
    Write-Host 
} 
Set-Alias KGR GitRevert






 