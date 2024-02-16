$name = 'Krosoft'
$module = 'Krosoft'
$path = "$PSScriptRoot"
$registerPSRepositorySplat = @{
    Name                 = $name 
    SourceLocation       = $path
    ScriptSourceLocation = $path 
    InstallationPolicy   = 'Trusted'
} 
Unregister-PSRepository $name 
Register-PSRepository @registerPSRepositorySplat
Get-PSRepository

New-ModuleManifest -Path "$path\$module\$module.psd1" `
    -Author "Krosoft" `
    -Description "Scripts utiles"  `
    -RootModule "$path\$module\$module.psm1"  `
    -FunctionsToExport '*'


Test-ModuleManifest -Path "$path\$module\$module.psd1"

$file = "$path\$module.1.0.nupkg"
If (Test-Path $file) {
    Remove-Item -Path $file
}
else {
    Write-Host "'$file' not found."
}

Write-Host "=========================================="
Write-Host "Publish-Module : "$module
Write-Host "=========================================="
Publish-Module -Name "$path\$module\$module.psd1" -Repository $name -Verbose
Find-Module -Name $module -Repository $name -Verbose
 
Write-Host "=========================================="
Write-Host "Uninstall-Module : "$module
Write-Host "=========================================="
Uninstall-Module -Name $module -Verbose

Write-Host "=========================================="
Write-Host "Install-Module : "$module
Write-Host "=========================================="
Install-Module -Name $module -Repository $name -Verbose

Write-Host "=========================================="
Write-Host "Import-Module : "$module
Write-Host "=========================================="
Import-Module $module -Verbose -Force 

Write-Host "=========================================="
Write-Host "Test : "
Write-Host "=========================================="
kh



