# Usage (depuis la racine du repo) : .\tools\scripts\cli_install.ps1
# Installe (ou réinstalle) le module Krosoft et l'ajoute au profil PowerShell.

$installScript = Join-Path $PSScriptRoot "..\..\powershell\modules\install_krosoft.ps1"

if (-not (Test-Path $installScript)) {
    Write-Host -fore Red "Script d'installation introuvable : $installScript"
    exit 1
}

& (Resolve-Path $installScript).Path
