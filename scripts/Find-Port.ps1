# Find-Port.ps1
# Usage: .\Find-Port.ps1 -Port 8080
# Usage: .\Find-Port.ps1 -Port 8080 -Kill

param(
    [Parameter(Mandatory = $true)]
    [int]$Port,

    [switch]$Kill
)

Write-Host "`n🔍 Recherche du processus sur le port $Port...`n" -ForegroundColor Cyan

$connections = netstat -ano | Select-String ":$Port\s"

if (-not $connections) {
    Write-Host "✅ Aucun processus n'utilise le port $Port." -ForegroundColor Green
    exit 0
}

$pids = $connections |
    ForEach-Object { ($_ -split '\s+')[-1] } |
    Sort-Object -Unique

foreach ($pid in $pids) {
    try {
        $proc = Get-Process -Id $pid -ErrorAction Stop
        Write-Host "Port $Port  →  PID: $pid  |  Processus: $($proc.ProcessName)  |  Path: $($proc.Path)" -ForegroundColor Yellow

        if ($Kill) {
            $confirm = Read-Host "`n⚠️  Tuer '$($proc.ProcessName)' (PID $pid) ? [o/N]"
            if ($confirm -match '^[oO]$') {
                Stop-Process -Id $pid -Force
                Write-Host "✅ Processus $pid tué." -ForegroundColor Green
            } else {
                Write-Host "❌ Annulé." -ForegroundColor Red
            }
        }
    } catch {
        Write-Host "PID $pid  →  (processus introuvable ou accès refusé)" -ForegroundColor DarkGray
    }
}
