function BunInstall() {
    Write-Host -fore green "=========================================="
    Write-Host -fore green "Bun install..."
    Write-Host -fore green "=========================================="
    $path = Get-Location
    Write-Host "Path            : " $path
    Write-Host -fore green "=========================================="
    bun install
    Write-Host -fore green "=========================================="
    Write-Host
    Write-Host
}
Set-Alias KBI BunInstall

function BunDev() {
    Write-Host -fore green "=========================================="
    Write-Host -fore green "Bun run dev..."
    Write-Host -fore green "=========================================="
    $path = Get-Location
    Write-Host "Path            : " $path
    Write-Host -fore green "=========================================="
    bun run dev
    Write-Host -fore green "=========================================="
    Write-Host
    Write-Host
}
Set-Alias KBD BunDev
