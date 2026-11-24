# Starts GTA VI in VIctory (test/fx-prs build) with the settings that work on this PC
# (RTX 5070 12 GB, Ryzen 5 5600). Usage: right-click > Run with PowerShell, or
#   powershell -ExecutionPolicy Bypass -File C:\Users\julio\VIctory-fx\jogar.ps1

$ErrorActionPreference = 'Stop'
$root = 'C:\Users\julio\VIctory-fx'
$game = 'C:\Users\julio\Downloads\GTA6.Xbox.v1.0.2.1-CYBERLEEK\game_scarlett_master.exe'
$exe  = Join-Path $root 'target\release\victory.exe'

if (Get-Process victory -ErrorAction SilentlyContinue) {
    Write-Host 'VIctory is already running. Close the game first.' -ForegroundColor Red
    Read-Host 'Enter to exit'; exit 1
}

# Programs that take video memory: textures then come out black.
$hogs = 'chrome','msedge','firefox','opera','brave','Discord','obs64','GameBar','NVIDIA Share','Spotify' |
    ForEach-Object { Get-Process $_ -ErrorAction SilentlyContinue } | Select-Object -ExpandProperty ProcessName -Unique
if ($hogs) {
    Write-Host "These programs use video memory and can leave textures black: $($hogs -join ', ')" -ForegroundColor Yellow
    Write-Host 'Close them for the best image (Enter continues anyway).'
    Read-Host | Out-Null
}

# Switches that hurt on this PC (pipelines built very slowly, builder crashes the game).
# VICTORY_DISPLAY_MODE=1920x1080 turns the indoor lighting off in GTA VI (tested 2026-11-24): leave it unset.
foreach ($v in 'VICTORY_BVH_BUILDER','VICTORY_BVH_QUARANTINE','VICTORY_FIRSTLANE_OWN','VICTORY_FIRST_HALF',
               'VICTORY_WIDE_BACK','VICTORY_CARD_BUFFERS_MIN_MB','VICTORY_CARD_BUFFERS_MB','VICTORY_DISPLAY_MODE') {
    Remove-Item "Env:$v" -ErrorAction SilentlyContinue
}
$env:VICTORY_TEXTURE_CATCHUP   = '0'  # catch-up sends ~600 MB of textures a frame after a load: 0.2 fps for minutes
$env:VICTORY_LATE_WAIT         = '1'
$env:VICTORY_RELAY             = '2'
$env:VICTORY_SHADER_LOOP_LIMIT = '256'

# Keep the previous log as run-prev.log.
$log = Join-Path $root 'run.log'
if (Test-Path $log) { Move-Item $log (Join-Path $root 'run-prev.log') -Force -ErrorAction SilentlyContinue }

Set-Location $root
# The emulator logs on stderr; with 'Stop' PowerShell 5.1 would end the run at its first line.
$ErrorActionPreference = 'Continue'
& $exe run $game --execute 2>&1 | Tee-Object -FilePath $log
