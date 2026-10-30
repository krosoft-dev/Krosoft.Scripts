function ReadJson($jsonPath) {    
  Write-Host "=========================================="
  Write-Host "ReadJson : "$jsonPath
  Write-Host "=========================================="
  $json = Get-Content -Raw -Path $jsonPath | ConvertFrom-Json  
    
  $json
  return
}   