$RenovateImage = "renovate/renovate:latest"

function Get-RenovateEnvArgs($profilePath) {
    $envArgs = @()

    # Variables lues par le profil via process.env.XXX : transmises telles quelles au conteneur
    if ($profilePath) {
        $names = Select-String -Path $profilePath -Pattern "process\.env\.([A-Za-z0-9_]+)" -AllMatches |
            ForEach-Object { $_.Matches } |
            ForEach-Object { $_.Groups[1].Value } |
            Sort-Object -Unique
        foreach ($name in $names) {
            if (-not [Environment]::GetEnvironmentVariable($name)) {
                throw "Variable d'environnement '$name' (utilisee par le profil) non definie."
            }
            $envArgs += @("-e", $name)
        }
    }

    if ($env:GITHUB_COM_TOKEN) {
        $envArgs += @("-e", "RENOVATE_GITHUB_COM_TOKEN=$env:GITHUB_COM_TOKEN")
    }
    else {
        Write-Host -fore Yellow "GITHUB_COM_TOKEN non defini : risque de rate limit GitHub et pas de changelogs."
    }

    return $envArgs
}

function Show-RenovateReport($reportFile) {
    $report = Get-Content $reportFile -Raw | ConvertFrom-Json
    $updates = foreach ($repository in $report.repositories.PSObject.Properties) {
        foreach ($manager in $repository.Value.packageFiles.PSObject.Properties) {
            foreach ($file in $manager.Value) {
                foreach ($dep in $file.deps) {
                    foreach ($update in $dep.updates) {
                        [PSCustomObject]@{
                            Repo     = $repository.Name
                            Package  = $dep.depName
                            Actuelle = $dep.currentValue
                            Nouvelle = $update.newValue
                            Type     = $update.updateType
                        }
                    }
                }
            }
        }
    }

    if ($updates) {
        $updates | Sort-Object Repo, Type, Package -Unique | Format-Table -AutoSize
    }
    else {
        Write-Host -fore Green "Aucune mise a jour disponible."
    }
}

function Update-RenovateFiles($reportFile, $root) {
    $report = Get-Content $reportFile -Raw | ConvertFrom-Json
    $applied = 0
    $skipped = @()

    foreach ($repository in $report.repositories.PSObject.Properties) {
        foreach ($manager in $repository.Value.packageFiles.PSObject.Properties) {
            foreach ($file in $manager.Value) {
                $filePath = Join-Path $root $file.packageFile
                $lines = [IO.File]::ReadAllLines($filePath)
                $changed = $false

                foreach ($dep in $file.deps) {
                    # Plusieurs updates possibles (minor, major...) : on prend la plus haute
                    $update = $dep.updates |
                        Where-Object { $_.newValue -and $_.newValue -ne $dep.currentValue } |
                        Sort-Object newMajor, newMinor, newPatch -Descending |
                        Select-Object -First 1
                    if (-not $update) {
                        continue
                    }

                    $depPattern = "(?<![\w.])" + [regex]::Escape($dep.depName) + "(?![\w.])"
                    $valuePattern = "(?<![\w.])" + [regex]::Escape($dep.currentValue) + "(?![\w.])"
                    $found = $false
                    for ($i = 0; $i -lt $lines.Length; $i++) {
                        if ($lines[$i] -match $depPattern -and $lines[$i] -match $valuePattern) {
                            $lines[$i] = [regex]::Replace($lines[$i], $valuePattern, $update.newValue.Replace('$', '$$'))
                            $found = $true
                        }
                    }

                    if ($found) {
                        $applied++
                        $changed = $true
                        Write-Host -fore Blue "$($file.packageFile) : $($dep.depName) $($dep.currentValue) -> $($update.newValue)"
                    }
                    else {
                        $skipped += "$($file.packageFile) : $($dep.depName) $($dep.currentValue) -> $($update.newValue)"
                    }
                }

                if ($changed) {
                    # Conserve l'encodage (BOM) et les fins de ligne d'origine
                    $content = [IO.File]::ReadAllText($filePath)
                    $newLine = if ($content -match "`r`n") { "`r`n" } else { "`n" }
                    $bom = $content.Length -gt 0 -and [IO.File]::ReadAllBytes($filePath)[0] -eq 0xEF
                    $text = ($lines -join $newLine) + $(if ($content -match "(`r`n|`n)$") { $newLine })
                    [IO.File]::WriteAllText($filePath, $text, (New-Object Text.UTF8Encoding $bom))
                }
            }
        }
    }

    Write-Host -fore Green "$applied mise(s) a jour appliquee(s)."
    if ($skipped) {
        Write-Host -fore Yellow "Non appliquees automatiquement (a faire a la main) :"
        $skipped | ForEach-Object { Write-Host -fore Yellow " - $_" }
    }
}

function Invoke-Renovate {
    param(
        [string]$Path = ".",
        [switch]$DryRun,
        [switch]$Apply
    )

    if (-not (Test-Path $Path)) {
        Write-Host -fore Red "Chemin introuvable : $Path"
        return
    }
    $Path = (Resolve-Path $Path).Path
    $isLocal = Test-Path $Path -PathType Container
    if ($isLocal) {
        $DryRun = $true
    }
    elseif ($Apply) {
        Write-Host -fore Red "-Apply n'est disponible que sur un dossier local."
        return
    }

    Write-Host -fore green "=========================================="
    Write-Host -fore green "Renovate"
    Write-Host -fore green "=========================================="
    Write-Host -fore Blue "Path   : " $Path
    Write-Host -fore Blue "Mode   : " $(if ($isLocal) { "Local (aucune PR)" } else { "Profil" })
    Write-Host -fore Blue "DryRun : " $DryRun
    Write-Host -fore Blue "Apply  : " $Apply.IsPresent
    Write-Host -fore Blue "Image  : " $RenovateImage
    Write-Host -fore green "=========================================="

    $reportDir = Join-Path $env:TEMP "krosoft-renovate"
    New-Item -ItemType Directory -Force $reportDir | Out-Null
    $reportFile = Join-Path $reportDir "report.json"
    if (Test-Path $reportFile) {
        Remove-Item $reportFile
    }

    $dockerArgs = @("run", "--rm", "-v", "${reportDir}:/tmp/report")

    if ($isLocal) {
        # Dossier : analyse locale, sans plateforme, aucune PR
        # Renovate ne voit que les fichiers suivis par git
        $configs = @("renovate.json", "renovate.json5", ".renovaterc", ".renovaterc.json", ".github/renovate.json", ".gitlab/renovate.json")
        if (-not (git -C $Path ls-files -- $configs)) {
            Write-Host -fore Red "Aucune config Renovate suivie par git dans $Path (faire un 'git add renovate.json')."
            return
        }
        $dockerArgs += @("-v", "${Path}:/usr/src/app", "-w", "/usr/src/app", "-e", "LOG_LEVEL=warn")
        $dockerArgs += Get-RenovateEnvArgs $null
        $dockerArgs += @($RenovateImage, "--platform=local")
    }
    else {
        # Fichier : profil Renovate (config.js global)
        $dockerArgs += @("-v", "${Path}:/usr/src/app/config.js:ro", "-e", "LOG_LEVEL=$(if ($DryRun) { 'warn' } else { 'info' })")
        try {
            $dockerArgs += Get-RenovateEnvArgs $Path
        }
        catch {
            Write-Host -fore Red $_.Exception.Message
            return
        }
        $dockerArgs += $RenovateImage
        if ($DryRun) {
            $dockerArgs += "--dry-run=full"
        }
    }

    if ($DryRun) {
        $dockerArgs += @("--report-type=file", "--report-path=/tmp/report/report.json")
    }

    & docker @dockerArgs

    if ($DryRun -and (Test-Path $reportFile)) {
        Write-Host -fore green "=========================================="
        Write-Host -fore green "Mises a jour disponibles"
        Write-Host -fore green "=========================================="
        Show-RenovateReport $reportFile

        if ($Apply) {
            Write-Host -fore green "=========================================="
            Write-Host -fore green "Application des mises a jour"
            Write-Host -fore green "=========================================="
            Update-RenovateFiles $reportFile $Path
        }
    }
    Write-Host -fore green "=========================================="
    Write-Host
    Write-Host
}

Set-Alias KRENOVATE Invoke-Renovate
