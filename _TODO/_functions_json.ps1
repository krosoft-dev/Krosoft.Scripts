function ReadJson($jsonPath) {    
  Write-Host "=========================================="
  Write-Host "ReadJson : "$jsonPath
  Write-Host "=========================================="
  $json = Get-Content -Raw -Path $jsonPath | ConvertFrom-Json  
    
  $json
  return
} 

 
function CreateJsonMigration($jsonPath, $projet, $context, $migration) {    
  Write-Host "=========================================="
  Write-Host "CreateJsonMigration : "$projet
  Write-Host "=========================================="
     

    

  $json = @{"projet" = $projet; "context" = $context; "migration" = $migration; }


  $json | ConvertTo-Json | Out-File $jsonPath



} 
