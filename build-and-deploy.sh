#!/bin/bash

# Build and Deploy Tank Game to GitHub Pages
# This script exports the Godot project to HTML5 and deploys it to GitHub Pages

echo "🎮 Tank Game - Build and Deploy Script"
echo "======================================"
echo ""

# Find Godot executable
GODOT_PATH=""
POSSIBLE_PATHS=(
    "/c/Program Files/Godot/Godot_v4.3-stable_win64.exe"
    "/c/Program Files/Godot/Godot.exe"
    "/c/Godot/Godot_v4.3-stable_win64.exe"
    "/c/Godot/Godot.exe"
    "$LOCALAPPDATA/Godot/Godot.exe"
)

for path in "${POSSIBLE_PATHS[@]}"; do
    if [ -f "$path" ]; then
        GODOT_PATH="$path"
        break
    fi
done

# If not found, try to find it in PATH
if [ -z "$GODOT_PATH" ]; then
    if command -v godot &> /dev/null; then
        GODOT_PATH=$(which godot)
    fi
fi

if [ -z "$GODOT_PATH" ]; then
    echo "❌ Error: Godot executable not found!"
    echo ""
    echo "Please specify the path to your Godot executable:"
    read -p "Godot path: " GODOT_PATH
    
    if [ ! -f "$GODOT_PATH" ]; then
        echo "❌ Path not found. Exiting."
        exit 1
    fi
fi

echo "✅ Found Godot: $GODOT_PATH"
echo ""

# Clean and create docs directory
echo "📁 Preparing output directory..."
if [ -d "./docs" ]; then
    rm -rf ./docs/*
else
    mkdir -p ./docs
fi

# Export the project
echo "🔨 Exporting project to HTML5..."
"$GODOT_PATH" --headless --export-release "Web" "./docs/index.html"

if [ $? -ne 0 ]; then
    echo "❌ Export failed"
    echo ""
    echo "Make sure you have the Web export templates installed."
    echo "In Godot Editor: Editor > Manage Export Templates"
    exit 1
fi

# Create .nojekyll file (tells GitHub Pages not to use Jekyll)
echo "📝 Creating .nojekyll file..."
touch ./docs/.nojekyll

# Check if docs directory has the exported files
if [ ! -f "./docs/index.html" ]; then
    echo "❌ Export failed - index.html not found"
    exit 1
fi

echo "✅ Export successful!"
echo ""

# Git operations
echo "📤 Committing and pushing to GitHub..."
git add docs/ export_presets.cfg
git commit -m "Build and deploy HTML5 version"
git push origin main

if [ $? -eq 0 ]; then
    echo "✅ Pushed to GitHub successfully!"
    echo ""
    echo "🌐 Next steps:"
    echo "1. Go to: https://github.com/afstarosta/tank_game/settings/pages"
    echo "2. Under 'Source', select 'Deploy from a branch'"
    echo "3. Select branch 'main' and folder '/docs'"
    echo "4. Click 'Save'"
    echo ""
    echo "Your game will be available at:"
    echo "https://afstarosta.github.io/tank_game/"
else
    echo "❌ Git push failed"
fi
