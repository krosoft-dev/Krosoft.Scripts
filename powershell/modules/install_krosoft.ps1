Write-Host -fore green "=========================================="
Write-Host -fore green "Check PowerShell version : " 
Write-Host -fore green "=========================================="

$PSVersionTable

# https://github.com/PowerShell/PowerShellGetv2/issues/606
$env:DOTNET_CLI_UI_LANGUAGE = "en_US"
$env:DOTNET_CLI_LANGUAGE = "en_US"
$env:NUGET_CLI_LANGUAGE = "en_US"



$name = 'Krosoft'
$module = 'Krosoft'
$version = '1.0'
$path = "$PSScriptRoot"
$registerPSRepositorySplat = @{
    Name                 = $name 
    SourceLocation       = $path
    ScriptSourceLocation = $path 
    InstallationPolicy   = 'Trusted'
} 

Write-Host -fore green "=========================================="
Write-Host -fore green "Register PSRepository : "$name
Write-Host -fore green "=========================================="

Unregister-PSRepository $name 
Register-PSRepository @registerPSRepositorySplat


Write-Host -fore green "=========================================="
Write-Host -fore green "All PSRepository : "
Write-Host -fore green "=========================================="
Get-PSRepository


Write-Host -fore green "=========================================="
Write-Host -fore green "Creation du module : "$module
Write-Host -fore green "=========================================="
New-ModuleManifest -Path "$path\$module\$module.psd1" `
    -Author "Krosoft" `
    -ModuleVersion $version `
    -Description "Scripts utiles"  `
    -RootModule "$module.psm1"  `
    -FunctionsToExport '*' `
    -AliasesToExport '*'

Write-Host -fore green "=========================================="
Write-Host -fore green "Test du module : "$module
Write-Host -fore green "=========================================="
Test-ModuleManifest -Path "$path\$module\$module.psd1"

$file = "$path\$module.$version.nupkg"
If (Test-Path $file) {
    Remove-Item -Path $file
}
else {
    Write-Host -fore red "'$file' not found."
    
}
 

Write-Host -fore green "=========================================="
Write-Host -fore green "Publish-Module : "$module
Write-Host -fore green "=========================================="
Publish-Module -Name "$path\$module\$module.psd1" -Repository $name -Verbose  

Write-Host -fore green "=========================================="
Write-Host -fore green "Check : "$module
Write-Host -fore green "=========================================="
Find-Module -Name $module -Repository $name -Verbose
 
Write-Host -fore green "=========================================="
Write-Host -fore green "Uninstall-Module : "$module
Write-Host -fore green "=========================================="
Uninstall-Module -Name $module -Verbose -ErrorAction SilentlyContinue
 
Write-Host -fore green "=========================================="
Write-Host -fore green "Install-Module : "$module
Write-Host -fore green "=========================================="
Install-Module -Name $module -Repository $name -Scope CurrentUser -Verbose


Write-Host -fore green "=========================================="
Write-Host -fore green "Setup PowerShell Profile"
Write-Host -fore green "=========================================="
$profileDir = Split-Path $PROFILE -Parent
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}
$importLine = "Import-Module $module -Force"
if (Test-Path $PROFILE) {
    $content = Get-Content $PROFILE -Raw
    if ($content -notmatch "Import-Module\s+$module") {
        Add-Content -Path $PROFILE -Value "`n$importLine"
        Write-Host -fore Blue "Added '$importLine' to profile: $PROFILE"
    } else {
        Write-Host -fore Blue "Profile already contains Import-Module $module"
    }
} else {
    Set-Content -Path $PROFILE -Value $importLine
    Write-Host -fore Blue "Created profile with '$importLine': $PROFILE"
}


 
Write-Host -fore green "=========================================="
Write-Host -fore green "Import-Module : "$module
Write-Host -fore green "=========================================="
Import-Module $module -Verbose -Force 
 
Write-Host -fore green "=========================================="
Write-Host -fore green "Test : "
Write-Host -fore green "=========================================="
kh

