# Dossiers jamais parcourus pour juger de l'activite d'un projet ni pour chercher des cibles
$DevCleanSkipDirs = @("node_modules", "bin", "obj", ".git", ".vs", ".idea", ".angular", ".turbo", ".next", ".nuxt", "dist")

function Get-DevCleanLastWrite($projectPath, $cutoff) {
    # Date du fichier source le plus recent du projet (hors dossiers generes).
    # S'arrete des qu'un fichier plus recent que $cutoff est trouve : le projet est actif.
    $newest = [datetime]::MinValue
    $stack = New-Object System.Collections.Stack
    $stack.Push($projectPath)
    while ($stack.Count -gt 0) {
        $current = $stack.Pop()
        try {
            foreach ($file in [IO.Directory]::EnumerateFiles($current)) {
                $lastWrite = [IO.File]::GetLastWriteTime($file)
                if ($lastWrite -gt $newest) {
                    $newest = $lastWrite
                    if ($newest -gt $cutoff) {
                        return $newest
                    }
                }
            }
            foreach ($dir in [IO.Directory]::EnumerateDirectories($current)) {
                $name = [IO.Path]::GetFileName($dir)
                $isLink = [IO.File]::GetAttributes($dir) -band [IO.FileAttributes]::ReparsePoint
                if ($DevCleanSkipDirs -notcontains $name -and -not $isLink) {
                    $stack.Push($dir)
                }
            }
        }
        catch {
            # Dossier inaccessible : ignore
        }
    }
    return $newest
}

function Get-DevCleanProjectRoot($path, $root) {
    # Racine du repo git contenant $path (sans remonter au-dessus de $root), sinon $path.
    # Evite de nettoyer un sous-package dormant d'un monorepo actif.
    $current = $path
    while ($current -and $current.Length -ge $root.Length) {
        if (Test-Path -LiteralPath (Join-Path $current ".git")) {
            return $current
        }
        $current = [IO.Path]::GetDirectoryName($current)
    }
    return $path
}

function Find-DevCleanTargets($root) {
    # node_modules a cote d'un package.json, bin/obj a cote d'un .csproj/.fsproj/.vbproj.
    # Ne descend jamais dans une cible trouvee.
    $stack = New-Object System.Collections.Stack
    $stack.Push($root)
    while ($stack.Count -gt 0) {
        $current = $stack.Pop()
        try {
            $dirs = [IO.Directory]::GetDirectories($current)
        }
        catch {
            continue
        }
        foreach ($dir in $dirs) {
            $name = [IO.Path]::GetFileName($dir)
            if ($name -eq "node_modules") {
                if (Test-Path -LiteralPath (Join-Path $current "package.json")) {
                    [PSCustomObject]@{ Path = $dir; Project = $current; Type = "node" }
                }
                continue
            }
            if ($name -eq "bin" -or $name -eq "obj") {
                $hasProject = [IO.Directory]::EnumerateFiles($current, "*.*proj") | Where-Object { $_ -match '\.(cs|fs|vb)proj$' } | Select-Object -First 1
                if ($hasProject) {
                    [PSCustomObject]@{ Path = $dir; Project = $current; Type = "dotnet" }
                }
                continue
            }
            if ($DevCleanSkipDirs -contains $name) {
                continue
            }
            if ([IO.File]::GetAttributes($dir) -band [IO.FileAttributes]::ReparsePoint) {
                continue
            }
            $stack.Push($dir)
        }
    }
}

function Get-DevCleanSize($path) {
    $sum = (Get-ChildItem -LiteralPath $path -Recurse -File -Force -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum
    if ($null -eq $sum) {
        return 0
    }
    return $sum
}

function Write-DevCleanElapsed($stopwatch) {
    $stopwatch.Stop()
    Write-Host -fore Blue "Temps : " $stopwatch.Elapsed.ToString("hh\:mm\:ss")
}

function Invoke-DevClean {
    param(
        [int]$Days = 30,
        [switch]$Apply
    )

    $stopwatch = [Diagnostics.Stopwatch]::StartNew()
    $root = (Get-Location).Path
    $cutoff = (Get-Date).AddDays(-$Days)

    Write-Host -fore green "=========================================="
    Write-Host -fore green "Nettoyage node_modules / bin / obj"
    Write-Host -fore green "=========================================="
    Write-Host -fore Blue "Path  : " $root
    Write-Host -fore Blue "Days  : " $Days "(projets non modifies depuis le $($cutoff.ToString('dd/MM/yyyy')))"
    Write-Host -fore Blue "Mode  : " $(if ($Apply) { "Suppression" } else { "Simulation (ajouter -Apply pour supprimer)" })
    Write-Host -fore green "=========================================="

    $lastWrites = @{}
    $targets = foreach ($target in Find-DevCleanTargets $root) {
        $project = Get-DevCleanProjectRoot $target.Project $root
        if (-not $lastWrites.ContainsKey($project)) {
            $lastWrites[$project] = Get-DevCleanLastWrite $project $cutoff
        }
        if ($lastWrites[$project] -gt $cutoff) {
            continue
        }
        $size = Get-DevCleanSize $target.Path
        # Dossiers vides : sans interet
        if ($size -lt 1MB) {
            continue
        }
        [PSCustomObject]@{
            Path      = $target.Path
            Type      = $target.Type
            Size      = $size
            LastWrite = $lastWrites[$project]
        }
    }

    if (-not $targets) {
        Write-Host -fore Green "Rien a nettoyer."
        Write-DevCleanElapsed $stopwatch
        Write-Host -fore green "=========================================="
        Write-Host
        return
    }

    $targets = @($targets | Sort-Object Size -Descending)
    $total = ($targets | Measure-Object Size -Sum).Sum

    if (-not $Apply) {
        $targets |
            Select-Object `
                @{N = "Taille (Go)"; E = { "{0:N2}" -f ($_.Size / 1GB) } },
                Type,
                @{N = "Modifie le"; E = { $_.LastWrite.ToString("dd/MM/yyyy") } },
                Path |
            Format-Table -AutoSize
        Write-Host -fore green "=========================================="
        Write-Host -fore Green ("{0} dossier(s), {1:N2} Go recuperables." -f $targets.Count, ($total / 1GB))
        Write-DevCleanElapsed $stopwatch
        Write-Host -fore green "=========================================="
        Write-Host
        return
    }

    $freed = 0
    foreach ($target in $targets) {
        $label = "{0,8:N2} Go  {1}" -f ($target.Size / 1GB), $target.Path
        # rd gere les chemins longs de node_modules mieux que Remove-Item
        cmd /c "rd /s /q `"\\?\$($target.Path)`"" 2>$null
        if (Test-Path -LiteralPath $target.Path) {
            Write-Host -fore Red "Echec    $label"
        }
        else {
            $freed += $target.Size
            Write-Host -fore Blue "Supprime $label"
        }
    }
    Write-Host -fore green "=========================================="
    Write-Host -fore Green ("{0:N2} Go liberes." -f ($freed / 1GB))
    Write-DevCleanElapsed $stopwatch
    Write-Host -fore green "=========================================="
    Write-Host
}

Set-Alias KCLEAN Invoke-DevClean
