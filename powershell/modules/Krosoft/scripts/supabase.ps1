function Get-ProjectIdFromConfig($configPath) { 
    Write-Host -fore Blue "Reading config file from path: $configPath"

    if (-not (Test-Path $configPath)) {
        throw "ERROR: Config file not found at path: $configPath"
    }
    $configLines = Get-Content -Path $configPath

    foreach ($line in $configLines) {
        if ($line -match '^project_id\s*=\s*"(.*)"') {
            return $matches[1]
        }
    } 
    throw "ERROR: Project ID not found in config file."
}

function SupabaseGenTypes {
    Write-Host -fore Green "=========================================="
    Write-Host -fore Green "Supabase : Generate Types"
    Write-Host -fore Green "=========================================="    
    $configPath = "./supabase/config.toml"
    $typesPath = "./src/integrations/supabase/types.ts"
    $project_id = Get-ProjectIdFromConfig $configPath    
    Write-Host -fore Green "=========================================="
    Write-Host -fore Blue "Project ID   : "$project_id
    Write-Host -fore Blue "Types Path   : "$typesPath
    Write-Host -fore Green "=========================================="
 
    node_modules\supabase\bin\supabase.exe gen types typescript --project-id $project_id > $typesPath 
}
Set-Alias KSGT SupabaseGenTypes 

function SupabaseFunctionsList {
    Write-Host -fore Green "=========================================="
    Write-Host -fore Green "Supabase : List Functions"
    Write-Host -fore Green "=========================================="    
    $configPath = "./supabase/config.toml"
    $project_id = Get-ProjectIdFromConfig $configPath    
    Write-Host -fore Green "=========================================="
    Write-Host -fore Blue "Project ID   : "$project_id
    Write-Host -fore Green "=========================================="

    node_modules\supabase\bin\supabase.exe functions list --project-ref $project_id
}
Set-Alias KSFL SupabaseFunctionsList
 
 
function SupabaseFunctionsDownload {
    $function_name = Read-Host "Nom de la fonction" 
    Write-Host -fore Green "=========================================="
    Write-Host -fore Green "Supabase : Download Function"
    Write-Host -fore Green "=========================================="    
    $configPath = "./supabase/config.toml"
    $project_id = Get-ProjectIdFromConfig $configPath    
    Write-Host -fore Green "=========================================="
    Write-Host -fore Blue "Project ID   : "$project_id
    Write-Host -fore Blue "Name         : "$function_name 
    Write-Host -fore Green "=========================================="
  
    if ([string]::IsNullOrEmpty($function_name )) {
        Write-Host -fore red "ERROR : Function name is required"
        exit
    }  
 
    node_modules\supabase\bin\supabase.exe functions download $function_name --project-ref $project_id

}
Set-Alias KSFD SupabaseFunctionsDownload

 
function SupabaseFunctionsCreate {
    
    $function_name = Read-Host "Nom de la fonction"
    Write-Host -fore Green "=========================================="
    Write-Host -fore Green "Supabase : Create Function"
    Write-Host -fore Green "=========================================="    
    $configPath = "./supabase/config.toml"
    $project_id = Get-ProjectIdFromConfig $configPath    
    Write-Host -fore Green "=========================================="
    Write-Host -fore Blue "Project ID   : "$project_id
    Write-Host -fore Blue "Name         : "$function_name 
    Write-Host -fore Green "=========================================="

    if ([string]::IsNullOrEmpty($function_name )) {
        Write-Host -fore red "ERROR : Function name is required"
        exit
    }  

    node_modules\supabase\bin\supabase.exe functions new $function_name  


}
Set-Alias KSFC SupabaseFunctionsCreate


function SupabaseFunctionsDeploy {
    $function_name = Read-Host "Nom de la fonction"
    Write-Host -fore Green "=========================================="
    Write-Host -fore Green "Supabase : Deploy Function"
    Write-Host -fore Green "=========================================="
    $configPath = "./supabase/config.toml"
    $project_id = Get-ProjectIdFromConfig $configPath
    Write-Host -fore Green "=========================================="
    Write-Host -fore Blue "Project ID   : "$project_id
    Write-Host -fore Blue "Name         : "$function_name
    Write-Host -fore Green "=========================================="

    if ([string]::IsNullOrEmpty($function_name )) {
        Write-Host -fore red "ERROR : Function name is required"
        exit
    }

    node_modules\supabase\bin\supabase.exe functions deploy $function_name --project-ref $project_id
}

Set-Alias KSFDe SupabaseFunctionsDeploy

 