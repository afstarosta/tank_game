# Build and Deploy Tank Game to GitHub Pages
# This script exports the Godot project to HTML5 and deploys it to GitHub Pages

Write-Host "🎮 Tank Game - Build and Deploy Script" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Find Godot executable
$godotPath = $null
$possiblePaths = @(
    "C:\Program Files\Godot\Godot_v4.3-stable_win64.exe",
    "C:\Program Files\Godot\Godot.exe",
    "C:\Godot\Godot_v4.3-stable_win64.exe",
    "C:\Godot\Godot.exe",
    "$env:LOCALAPPDATA\Godot\Godot.exe"
)

foreach ($path in $possiblePaths) {
    if (Test-Path $path) {
        $godotPath = $path
        break
    }
}

# If not found, try to find it in PATH
if (-not $godotPath) {
    $godotCmd = Get-Command godot -ErrorAction SilentlyContinue
    if ($godotCmd) {
        $godotPath = $godotCmd.Source
    }
}

if (-not $godotPath) {
    Write-Host "❌ Error: Godot executable not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please specify the path to your Godot executable:" -ForegroundColor Yellow
    $godotPath = Read-Host "Godot path"
    
    if (-not (Test-Path $godotPath)) {
        Write-Host "❌ Path not found. Exiting." -ForegroundColor Red
        exit 1
    }
}

Write-Host "✅ Found Godot: $godotPath" -ForegroundColor Green
Write-Host ""

# Clean and create docs directory
Write-Host "📁 Preparing output directory..." -ForegroundColor Yellow
if (Test-Path ".\docs") {
    Remove-Item ".\docs\*" -Recurse -Force
} else {
    New-Item -ItemType Directory -Path ".\docs" | Out-Null
}

# Export the project
Write-Host "🔨 Exporting project to HTML5..." -ForegroundColor Yellow
& $godotPath --headless --export-release "Web" ".\docs\index.html"

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Export failed with exit code: $LASTEXITCODE" -ForegroundColor Red
    Write-Host ""
    Write-Host "Make sure you have the Web export templates installed." -ForegroundColor Yellow
    Write-Host "In Godot Editor: Editor > Manage Export Templates" -ForegroundColor Yellow
    exit 1
}

# Create .nojekyll file (tells GitHub Pages not to use Jekyll)
Write-Host "📝 Creating .nojekyll file..." -ForegroundColor Yellow
New-Item -ItemType File -Path ".\docs\.nojekyll" -Force | Out-Null

# Check if docs directory has the exported files
if (-not (Test-Path ".\docs\index.html")) {
    Write-Host "❌ Export failed - index.html not found" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Export successful!" -ForegroundColor Green
Write-Host ""

# Git operations
Write-Host "📤 Committing and pushing to GitHub..." -ForegroundColor Yellow
& "C:\Program Files\Git\bin\bash.exe" -c @"
git add docs/ export_presets.cfg
git commit -m 'Build and deploy HTML5 version'
git push origin main
"@

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Pushed to GitHub successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🌐 Next steps:" -ForegroundColor Cyan
    Write-Host "1. Go to: https://github.com/afstarosta/tank_game/settings/pages" -ForegroundColor White
    Write-Host "2. Under 'Source', select 'Deploy from a branch'" -ForegroundColor White
    Write-Host "3. Select branch 'main' and folder '/docs'" -ForegroundColor White
    Write-Host "4. Click 'Save'" -ForegroundColor White
    Write-Host ""
    Write-Host "Your game will be available at:" -ForegroundColor Green
    Write-Host "https://afstarosta.github.io/tank_game/" -ForegroundColor Cyan
} else {
    Write-Host "❌ Git push failed" -ForegroundColor Red
}
