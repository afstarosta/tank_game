# Tank Game

A tank game built with Godot Engine 4.6.

## 🎮 Play Online

Once deployed, play the game at: [https://afstarosta.github.io/tank_game/](https://afstarosta.github.io/tank_game/)

## 🚀 Build and Deploy

This project includes scripts to automatically build the game to HTML5 and deploy it to GitHub Pages.

### Prerequisites

1. **Godot 4.x installed** with Web export templates
   - Download from: https://godotengine.org/
   - Install export templates: Editor > Manage Export Templates
   
2. **Git configured** (already set up if you cloned this repo)

### Using PowerShell (Windows)

```powershell
.\build-and-deploy.ps1
```

### Using Git Bash

```bash
./build-and-deploy.sh
```

### First-Time Setup

After running the build script for the first time:

1. Go to your repository settings: https://github.com/afstarosta/tank_game/settings/pages
2. Under **Source**, select **"Deploy from a branch"**
3. Select branch **main** and folder **/docs**
4. Click **Save**

GitHub will take a few minutes to deploy your game. Once ready, it will be available at:
**https://afstarosta.github.io/tank_game/**

## 🛠️ Development

Open the project in Godot Engine 4.6+ to edit and develop the game.

### Project Structure

- `main.tscn` - Main game scene
- `tank.gd` - Tank controller script
- `assets/` - Game assets (sprites, etc.)
- `docs/` - Built HTML5 version (auto-generated)
- `export_presets.cfg` - Export configuration

## 📝 Rebuilding

Every time you make changes to your game:

1. Run the build script again
2. The script will automatically commit and push to GitHub
3. GitHub Pages will automatically update your game

