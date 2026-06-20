function Get-SccBinary() {
    $sccPath = "$env:USERPROFILE\.krosoft\tools\scc.exe"
    if (-not (Test-Path $sccPath)) {
        Write-Host -fore Blue "SCC non trouve, telechargement en cours..."
        $toolsDir = "$env:USERPROFILE\.krosoft\tools"
        if (-not (Test-Path $toolsDir)) {
            New-Item -ItemType Directory -Path $toolsDir | Out-Null
        }
        $zipPath = "$toolsDir\scc.zip"
        $url = "https://github.com/boyter/scc/releases/latest/download/scc_Windows_x86_64.zip"
        Invoke-WebRequest -Uri $url -OutFile $zipPath
        Expand-Archive -Path $zipPath -DestinationPath $toolsDir -Force
        Remove-Item $zipPath
        Write-Host -fore Blue "SCC telecharge."
    }
    return $sccPath
}

function Get-SccMdHeader($title, $path, [string[]]$lang, $description) {
    $date = Get-Date -Format "yyyy-MM-dd HH:mm"
    $header  = "# $title`n`n"
    if ($description) { $header += "$description`n`n" }
    $header += "> **Date** : $date  `n"
    $header += "> **Path** : $path  `n"
    if ($lang) { $header += "> **Langages** : $($lang -join ', ')  `n" }
    $header += "`n"
    return $header
}

function ConvertTo-SccMarkdown($results, $title) {
    $lines = @()
    if ($title) { $lines += "## $title"; $lines += "" }
    $lines += "| Langage | Fichiers | Lignes | Code | Commentaire | Vide | Complexite |"
    $lines += "|---------|----------|--------|------|-------------|------|------------|"
    $results |
        Where-Object { $_.Name -ne "Total" } |
        Sort-Object Lines -Descending |
        ForEach-Object {
            $lines += "| $($_.Name) | $($_.Count) | $($_.Lines) | $($_.Code) | $($_.Comment) | $($_.Blank) | $($_.Complexity) |"
        }
    $total = $results | Where-Object { $_.Name -eq "Total" }
    if ($total) {
        $lines += ""
        $lines += "> **Total** : $($total.Lines) lignes, $($total.Code) code, $($total.Count) fichiers"
    }
    $lines += ""
    return $lines -join "`n"
}

function Invoke-SccOnPath($sccPath, $targetPath, [switch]$table, [switch]$md, [string[]]$lang) {
    $json = & $sccPath --format json $targetPath
    $results = $json | ConvertFrom-Json
    if ($lang) { $results = $results | Where-Object { $_.Name -in $lang } }

    if ($table) {
        $results |
            Where-Object { $_.Name -ne "Total" } |
            Sort-Object Lines -Descending |
            Select-Object `
                @{N="Langage";    E={$_.Name}},
                @{N="Fichiers";   E={$_.Count}},
                @{N="Lignes";     E={$_.Lines}},
                @{N="Code";       E={$_.Code}},
                @{N="Commentaire";E={$_.Comment}},
                @{N="Vide";       E={$_.Blank}},
                @{N="Complexite"; E={$_.Complexity}} |
            Format-Table -AutoSize
    } elseif ($md) {
        ConvertTo-SccMarkdown $results $null
    } else {
        $results | ConvertTo-Json -Depth 5
    }
}

function Get-SccRows($sccPath, $targetPath, $projet, [string[]]$lang) {
    $json = & $sccPath --format json $targetPath
    $results = $json | ConvertFrom-Json | Where-Object { $_.Name -ne "Total" }
    if ($lang) { $results = $results | Where-Object { $_.Name -in $lang } }
    return $results | ForEach-Object {
        [PSCustomObject]@{
            Projet      = $projet
            Langage     = $_.Name
            Lignes      = $_.Lines
            Code        = $_.Code
            Commentaire = $_.Comment
            Vide        = $_.Blank
            Fichiers    = $_.Count
            Complexite  = $_.Complexity
        }
    }
}

function SccAnalyse {
    param($path, [switch]$table, [switch]$md, [string[]]$lang, [switch]$folders, [switch]$summary, [string]$filter, [string]$description)

    Write-Host -fore Green "=========================================="
    Write-Host -fore Green "SCC : Analyse du code"
    Write-Host -fore Green "=========================================="

    if ([string]::IsNullOrEmpty($path)) {
        Write-Host -fore red "ERROR : Le chemin est requis."
        return
    }
    if ($filter -and -not $folders) {
        Write-Host -fore red "ERROR : -filter necessite -folders."
        return
    }
    if (-not (Test-Path $path)) {
        Write-Host -fore red "ERROR : Chemin introuvable : $path."
        return
    }

    $sccPath = Get-SccBinary

    Write-Host -fore Blue "Path    : " $path
    Write-Host -fore Blue "SCC     : " $sccPath
    if ($lang)    { Write-Host -fore Blue "Langages: " ($lang -join ", ") }
    if ($filter)  { Write-Host -fore Blue "Filtre  :  $filter" }
    if ($folders) { Write-Host -fore Blue "Mode    :  folders" }
    if ($md)      { Write-Host -fore Blue "Export  :  markdown" }
    if ($summary) { Write-Host -fore Blue "Mode    :  summary" }
    Write-Host -fore Green "=========================================="

    if ($summary) {
        $targets = if ($folders) {
            Get-ChildItem -Path $path -Directory | Where-Object { -not $filter -or $_.Name -like $filter }
        } else {
            @([PSCustomObject]@{ Name = Split-Path $path -Leaf; FullName = $path })
        }
        if (-not $targets) {
            Write-Host -fore red "ERROR : Aucun dossier trouve dans $path."
            return
        }
        $rows = foreach ($dir in $targets) {
            Get-SccRows $sccPath $dir.FullName $dir.Name $lang
        }
        if ($md) {
            $mdContent = Get-SccMdHeader "SCC - Synthese" $path $lang $description
            $mdContent += "| Projet | Langage | Lignes | Code | Commentaire | Vide | Fichiers | Complexite |`n"
            $mdContent += "|--------|---------|--------|------|-------------|------|----------|------------|`n"
            foreach ($r in $rows) {
                $mdContent += "| $($r.Projet) | $($r.Langage) | $($r.Lignes) | $($r.Code) | $($r.Commentaire) | $($r.Vide) | $($r.Fichiers) | $($r.Complexite) |`n"
            }
            $outFile = Join-Path $path "scc-summary.md"
            $mdContent | Out-File -FilePath $outFile -Encoding utf8
            Write-Host -fore Green "Export  :  $outFile"
        } else {
            $rows | Sort-Object Lignes -Descending | Format-Table -AutoSize
        }
        return
    }

    if ($folders) {
        $subDirs = Get-ChildItem -Path $path -Directory | Where-Object { -not $filter -or $_.Name -like $filter }
        if (-not $subDirs) {
            Write-Host -fore red "ERROR : Aucun sous-dossier trouve dans $path."
            return
        }
        if ($md) {
            $mdContent = Get-SccMdHeader "SCC - Analyse par dossier" $path $lang $description
            foreach ($dir in $subDirs) {
                $json = & $sccPath --format json $dir.FullName
                $results = $json | ConvertFrom-Json
                if ($lang) { $results = $results | Where-Object { $_.Name -in $lang } }
                $mdContent += ConvertTo-SccMarkdown $results $dir.Name
            }
            $outFile = Join-Path $path "scc-report.md"
            $mdContent | Out-File -FilePath $outFile -Encoding utf8
            Write-Host -fore Green "Export  :  $outFile"
        } else {
            foreach ($dir in $subDirs) {
                Write-Host -fore Green "--- $($dir.Name) ---"
                Invoke-SccOnPath $sccPath $dir.FullName -table:$table -md:$md -lang $lang
            }
        }
    } else {
        if ($md) {
            $json = & $sccPath --format json $path
            $results = $json | ConvertFrom-Json
            if ($lang) { $results = $results | Where-Object { $_.Name -in $lang } }
            $mdContent = Get-SccMdHeader "SCC - Analyse du code" $path $lang $description
            $mdContent += ConvertTo-SccMarkdown $results $null
            $outFile = Join-Path $path "scc-report.md"
            $mdContent | Out-File -FilePath $outFile -Encoding utf8
            Write-Host -fore Green "Export  :  $outFile"
        } else {
            Invoke-SccOnPath $sccPath $path -table:$table -md:$md -lang $lang
        }
    }
}
Set-Alias KSCC SccAnalyse
