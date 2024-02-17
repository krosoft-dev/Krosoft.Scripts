function SetupEnvProject($source, $targets) {    
     
  Write-Host "=========================================="
  Write-Host "SetupEnvProject : "$global:projet
  Write-Host "==========================================" 
  
  foreach ($repo in $global:repositories) {        
    SetupEnv  $source $targets $repo.name
  }     
}

function SetupEnv($source, $targets, $repo) {  
  Write-Host "=========================================="
  Write-Host "Creation des environnements depuis l'environnement '$source' pour $repo "
  Write-Host "=========================================="
 


  
    Set-Location $repo

    $path = "docker-compose"   
    if (Test-Path $path) {   
        foreach ($target in $targets) {

            $sourceUpper = ToTitleCase($source)
            $targetUpper = ToTitleCase($target)

            Write-Host "Creation de l'environnement '$target'"
            Copy-Item "$path\.env.$source" -Destination "$path\.env.$target"
            Copy-Item "$path\docker-compose.$source.yml" -Destination "$path\docker-compose.$target.yml"
            ReplaceTxt "$path\.env.$target" $source $target
            ReplaceTxt "$path\.env.$target" $sourceUpper $targetUpper
            ReplaceTxt "$path\docker-compose.$target.yml" $source $target
            ReplaceTxt "$path\docker-compose.$target.yml" $sourceUpper $targetUpper
        }
    }
    else {
        Write-Host "$path n'existe pas."
    }


    if (Test-Path $repo) {
        foreach ($target in $targets) { 

            $sourceUpper = ToTitleCase($source)
            $targetUpper = ToTitleCase($target)

            $sourceSettings = "$repo\appsettings.$sourceUpper.json" 
            $targetSettings = "$repo\appsettings.$targetUpper.json" 
                       

            if (Test-Path $sourceSettings) {
                Copy-Item $sourceSettings -Destination $targetSettings        
                ReplaceTxt $targetSettings $source $target
                ReplaceTxt $targetSettings $sourceUpper $targetUpper
            }
            else {
                Write-Host "$sourceSettings n'existe pas."
            }
        }
    }
    else {
        Write-Host "$repo n'existe pas."
    }
   
    Set-Location .. 
}



