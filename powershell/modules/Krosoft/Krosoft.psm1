# Importer les fonctions depuis les fichiers .ps1
$scripts = @(Get-ChildItem -Path $PSScriptRoot\scripts\*.ps1)
foreach ($script in $scripts) {
    try {
        Write-Verbose "Importing $($script.FullName)"
        . $script.FullName
    } catch {
        Write-Error "Failed to import function $($script.FullName): $_"
    }
}

# Exporter les fonctions\Alias
Export-ModuleMember -Function '*'
Export-ModuleMember -Alias '*'