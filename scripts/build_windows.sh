#!/bin/bash

# Windows Build Script for TaskHo
# This script builds a Windows release and creates a distributable archive

set -e

# Production URL configuration (static)
PRODUCTION_URL="https://task-ho-backend.vercel.app/api"

echo "🚀 Starting Windows build process for TaskHo..."
echo "🌐 Backend URL: $PRODUCTION_URL"
echo ""

# Step 1: Increment build number
echo "🔢 Step 1/3: Incrementing build number..."
./scripts/increment_build.sh
echo ""

# Step 2: Build Windows release
echo "📱 Step 2/3: Building Windows app..."
flutter build windows --release --dart-define=TASKHO_BASE_URL="$PRODUCTION_URL"
echo "✅ Build complete!"
echo ""

# Step 3: Create distributable archive
echo "📦 Step 3/3: Creating Windows distribution package..."

# Get version info
PUBSPEC_FILE="pubspec.yaml"
FULL_VERSION=$(grep "^version:" "$PUBSPEC_FILE" | sed 's/version: //' | tr -d ' ')
VERSION_NUMBER=$(echo "$FULL_VERSION" | cut -d'+' -f1)
BUILD_NUMBER=$(echo "$FULL_VERSION" | cut -d'+' -f2)

# Create windows-dist directory if it doesn't exist
mkdir -p windows-dist

# Archive name
ARCHIVE_NAME="TaskHo-Windows-v${VERSION_NUMBER}-b${BUILD_NUMBER}.zip"
BUILD_DIR="build/windows/x64/runner/Release"

# Create ZIP archive
echo "Creating archive: $ARCHIVE_NAME"
cd "$BUILD_DIR"
zip -r "../../../../../windows-dist/$ARCHIVE_NAME" . -x "*.pdb" "*.exp" "*.lib"
cd - > /dev/null

echo "✅ Archive creation complete!"
echo ""

echo "🎉 All done! Your Windows app is ready for distribution."
echo ""
echo "📦 Distribution file:"
echo "   windows-dist/${ARCHIVE_NAME}"
echo ""
echo "📋 Distribution contents:"
echo "   - TaskHo.exe (main executable)"
echo "   - flutter_windows.dll"
echo "   - Required DLL files"
echo "   - data/ folder (app resources)"
echo ""
echo "ℹ️  To distribute:"
echo "   1. Share the entire ZIP file with users"
echo "   2. Users should extract all contents to a folder"
echo "   3. Run TaskHo.exe from the extracted folder"
echo ""
