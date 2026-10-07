# Krosoft.Scripts

Scripts PowerShell utilitaires exposés via le module `Krosoft`.

## Installation

```powershell
.\powershell\modules\install_krosoft.ps1
```

Le module est ensuite disponible dans chaque session via `Import-Module Krosoft -Force`.

---

## Antigravity IDE

**Alias :** `kai`  
**Fonction :** `Invoke-AntigravityIde`  
**Fichier :** `powershell/modules/Krosoft/scripts/antigravity.ps1`

Lance l'éditeur Antigravity IDE dans le dossier courant. L'équivalent d'un `antigravity-ide .`.

### Syntaxe

```powershell
kai
```

---

## KSCC — Analyse de code avec SCC

**Alias :** `KSCC`  
**Fonction :** `SccAnalyse`  
**Fichier :** `powershell/modules/Krosoft/scripts/scc.ps1`

Lance une analyse de code source avec [scc (Sloc Cloc and Code)](https://github.com/boyter/scc). Le binaire est téléchargé automatiquement dans `~\.krosoft\tools\scc.exe` s'il est absent.

### Syntaxe

```powershell
KSCC <path> [-table] [-md] [-folders] [-summary] [-lang <langage,...>]
```

### Paramètres

| Paramètre   | Type     | Description |
|-------------|----------|-------------|
| `path`      | `string` | Chemin du dossier à analyser (obligatoire) |
| `-table`    | switch   | Affiche les résultats en tableau dans la console |
| `-md`       | switch   | Exporte les résultats dans un fichier Markdown |
| `-folders`  | switch   | Boucle sur tous les sous-dossiers de `path` |
| `-summary`  | switch   | Tableau de synthèse avec une ligne par projet |
| `-lang`     | `string[]` | Filtre sur un ou plusieurs langages |
| `-filter`   | `string`   | Filtre les sous-dossiers par pattern wildcard (requiert `-folders`) |

### Modes

#### JSON (défaut)

Retourne le JSON brut de scc, exploitable via `ConvertFrom-Json`.

```powershell
KSCC .
KSCC . | ConvertFrom-Json
```

#### Table (`-table`)

Affiche un tableau formaté dans la console, trié par nombre de lignes décroissant.

```powershell
KSCC . -table
KSCC C:\Dev\MonProjet -table -lang TypeScript,CSS
```

#### Export Markdown (`-md`)

Génère un fichier `scc-report.md` dans le dossier `path`.

```powershell
KSCC . -md
KSCC . -md -lang TypeScript
```

Exemple de contenu généré :

```markdown
# SCC - Analyse du code
> Path : C:\Dev\MonProjet

| Langage | Fichiers | Lignes | Code | Commentaire | Vide | Complexite |
|---------|----------|--------|------|-------------|------|------------|
| TypeScript | 375 | 23167 | 20962 | 169 | 2036 | 1296 |
| CSS | 2 | 250 | 197 | 2 | 51 | 0 |

> **Total** : 23417 lignes, 21159 code, 377 fichiers
```

#### Dossiers (`-folders`)

Boucle sur chaque sous-dossier direct de `path` et applique le mode choisi.

```powershell
KSCC C:\Dev -folders -table
KSCC C:\Dev -folders -md
KSCC C:\Dev -folders -table -lang TypeScript
KSCC C:\Dev -folders -table -filter "modulus*"
KSCC C:\Dev -folders -summary -md -filter "Krosoft.*"
```

Supporte la syntaxe wildcard PowerShell : `*` (n caractères), `?` (1 caractère), `[abc]` (ensemble).

Avec `-md`, génère `scc-report.md` avec une section `##` par sous-dossier.

#### Synthèse (`-summary`)

Produit un tableau unique avec une ligne par projet et les totaux agrégés.  
Compatible avec `-folders` (un projet = un sous-dossier) ou sans (un seul projet).

```powershell
# Affichage console
KSCC C:\Dev -folders -summary

# Export Markdown → scc-summary.md
KSCC C:\Dev -folders -summary -md

# Filtré sur un langage
KSCC C:\Dev -folders -summary -lang TypeScript
```

Exemple de contenu `scc-summary.md` :

```markdown
# SCC - Synthese
> Path : C:\Dev

| Projet | Lignes | Code | Commentaire | Vide | Fichiers | Complexite |
|--------|--------|------|-------------|------|----------|------------|
| modulus | 23167 | 20962 | 169 | 2036 | 375 | 1296 |
| api | 12400 | 11200 | 300 | 900 | 180 | 540 |
```

### Combinaisons utiles

```powershell
# Comparer tous les projets de C:\Dev en une table console
KSCC C:\Dev -folders -summary

# Générer un rapport MD complet par projet
KSCC C:\Dev -folders -md

# Générer une synthèse MD multi-projets filtrée TypeScript
KSCC C:\Dev -folders -summary -md -lang TypeScript

# Analyser un projet et parser le JSON
KSCC . | ConvertFrom-Json | Where-Object { $_.Lines -gt 100 }
```

---

## KRENOVATE — Renovate en local via Docker

**Alias :** `KRENOVATE`  
**Fonction :** `Invoke-Renovate`  
**Fichier :** `powershell/modules/Krosoft/scripts/renovate.ps1`

Lance [Renovate](https://docs.renovatebot.com/) dans Docker (image `renovate/renovate`), sans pipeline CI. Chaque repo garde son `renovate.json`, la fonction ne fait que l'exécuter.

### Syntaxe

```powershell
KRENOVATE <profil.js> [-DryRun]   # exécute Renovate avec un profil
KRENOVATE [<dossier>]             # analyse un dossier local (défaut : dossier courant), aucune PR
```

| Paramètre | Type     | Description |
|-----------|----------|-------------|
| `Path`    | `string` | Fichier profil `.js`, ou dossier à analyser en local (défaut : `.`) |
| `-DryRun` | switch   | Aucune PR créée, affiche un tableau des mises à jour disponibles (implicite pour un dossier) |

### Profils

Un profil est un fichier de config global Renovate (`config.js`), à stocker hors de ce repo. Un profil couvre une organisation, et un seul lancement traite tous ses repos.

```js
// mon-orga.js
module.exports = {
  platform: 'azure',
  endpoint: 'https://dev.azure.com/mon-orga/',
  token: process.env.AZDO_MON_ORGA_PAT,

  // Seuls les repos qui ont un renovate.json sont traités (pas de PR d'onboarding)
  autodiscover: true,
  onboarding: false,
  requireConfig: 'required',
};
```

### Secrets

Aucun token dans les profils : ils sont lus via `process.env.XXX`. La fonction détecte ces variables dans le profil et les transmet au conteneur (erreur si l'une d'elles n'est pas définie).

`GITHUB_COM_TOKEN` (token GitHub sans scope) est transmis s'il est défini : il évite le rate limit sur les presets `github>...` et active les changelogs dans les PR.

```powershell
[Environment]::SetEnvironmentVariable("AZDO_MON_ORGA_PAT", "<pat>", "User")
[Environment]::SetEnvironmentVariable("GITHUB_COM_TOKEN", "<token>", "User")
```

---

## Find-Port

**Fichier :** `scripts/Find-Port.ps1`

Identifie le processus qui occupe un port réseau, avec option de kill.

```powershell
.\scripts\Find-Port.ps1 -Port 8080
.\scripts\Find-Port.ps1 -Port 8080 -Kill
```
