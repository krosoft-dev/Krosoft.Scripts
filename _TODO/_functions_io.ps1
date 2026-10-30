
function  RemoveItemIfExist ( $path) {    
  if (Test-Path $path) {      
    Remove-Item -Force -Recurse -Path $path
  }
} 

function ReplaceTxt($path, $source, $target) {
  (Get-Content -Path $path -Raw).Replace($source, $target) | Set-Content -Path $path
}


function ToTitleCase($text) {    
  return (Get-Culture).textinfo.totitlecase($text.tolower())
}

function RenameContent($base, $project, $source , $destination ) {        
  if ([string]::IsNullOrEmpty($base)) {
    Write-Warning "Param 'base' undefined" 
    Exit
  }  
  if ([string]::IsNullOrEmpty($project)) {
    Write-Warning "Param 'project' undefined" 
    Exit
  }
  if ([string]::IsNullOrEmpty($source)) {
    Write-Warning "Param 'source' undefined" 
    Exit
  }
  if ([string]::IsNullOrEmpty($destination)) {
    Write-Warning "Param 'destination' undefined" 
    Exit
  }

  Write-Host
  Write-Host "Rename content project $project : '$source' > '$destination'" 
  Write-Host

  $path = Get-Location 
 
  $source_folder = [IO.Path]::Combine($base, $project)
  Set-Location $source_folder
  $source_path = Get-Location
  Write-Host "Path : " $source_path


 
  # Remplacement du contenu des fichiers
  $contents = Get-ChildItem -Recurse -Attributes !Directory | Select-Object -expand fullname

  Write-Host "Analysing $(  $contents.length) files for replacement..." 
  $contents | ForEach-Object { (Get-Content $_) -creplace $source, $destination | Set-Content $_ }

  # Renommage des dossiers  
  $directories = Get-ChildItem -Recurse -Directory `
  | Where-Object { $_.Name -match $source }  `
  | Sort-Object Name

  Write-Host "Renaming $(  $directories.length) directories..." 

  foreach ($directory in $directories) {
    $new_name = $directory.Name -creplace $source, $destination
    Write-Host "Renaming $($directory.FullName) >  $new_name"  
    Rename-Item -Path $directory.FullName -NewName $new_name
  }


  # Renommage des fichiers
  $files = Get-ChildItem -Recurse -Attributes !Directory `
  | Where-Object { $_.Name -match $source }  `
  | Sort-Object Name

  Write-Host "Renaming $($files.length) files..." 
  foreach ($file in $files) {
    $new_name = $file.Name -creplace $source, $destination
    Write-Host "Renaming $($file.Name) >  $new_name"  
    Rename-Item -Path $file.FullName -NewName $new_name
  }

  # Retour au chemin de base
  Set-Location $path
}

function CopyEnvProjet($source, $targets) {
  Write-Host "=========================================="
  Write-Host "CopyEnvProjet : "$global:projet
  Write-Host "==========================================" 
  
  if ([string]::IsNullOrEmpty($source)) {
    Write-Warning "Param 'source' undefined" 
    Exit
  }  

  if ([string]::IsNullOrEmpty($targets)) {
    Write-Warning "Param 'targets' undefined" 
    Exit
  }

  foreach ($repo in $global:repositories) {        
    CopyEnv $repo.name $source $targets  
  }
}
 





function CopyEnv( $repo, $source, [array]$targets) {
  Write-Host "=========================================="
  Write-Host "Creation des environnements depuis l'environnement '$source' pour $repo "
  Write-Host "==========================================" 
  
  $path = Get-Location 

  Set-Location $repo

  $pathDockerCompose = "docker-compose"   
  if (Test-Path $pathDockerCompose) {   
    foreach ($target in $targets) {

      $sourceUpper = ToTitleCase($source)
      $targetUpper = ToTitleCase($target)

      Write-Host "Creation de l'environnement '$target'"
      Copy-Item "$pathDockerCompose\.env.$source" -Destination "$pathDockerCompose\.env.$target"
      Copy-Item "$pathDockerCompose\docker-compose.$source.yml" -Destination "$pathDockerCompose\docker-compose.$target.yml"
      ReplaceTxt "$pathDockerCompose\.env.$target" $source $target
      ReplaceTxt "$pathDockerCompose\.env.$target" $sourceUpper $targetUpper
      ReplaceTxt "$pathDockerCompose\docker-compose.$target.yml" $source $target
      ReplaceTxt "$pathDockerCompose\docker-compose.$target.yml" $sourceUpper $targetUpper
    }
  }
  else {
    Write-Host "$pathDockerCompose n'existe pas."
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
 
  # Retour au chemin de base
  Set-Location $path
}


