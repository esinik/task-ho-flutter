#!/bin/bash

# macOS DMG Creator Script
# This script creates a distributable DMG file from the signed and notarized app

set -e

# Get version and build number from pubspec.yaml
PUBSPEC_FILE="pubspec.yaml"
FULL_VERSION=$(grep "^version:" "$PUBSPEC_FILE" | sed 's/version: //' | tr -d ' ')
VERSION_NUMBER=$(echo "$FULL_VERSION" | cut -d'+' -f1)
BUILD_NUMBER=$(echo "$FULL_VERSION" | cut -d'+' -f2)

# Configuration
APP_NAME="taskho"
APP_PATH="build/macos/Build/Products/Release/taskho.app"
DMG_NAME="TaskHo-v${VERSION_NUMBER}-b${BUILD_NUMBER}"
DMG_PATH="build/macos/Build/Products/Release/${DMG_NAME}.dmg"
VOLUME_NAME="TaskHo ${VERSION_NUMBER}"
TEMP_DMG="build/macos/Build/Products/Release/temp.dmg"

echo "📦 Creating DMG installer..."
echo "   Version: $VERSION_NUMBER"
echo "   Build: $BUILD_NUMBER"
echo "   DMG name: ${DMG_NAME}.dmg"
echo ""

# Step 1: Check if app exists and is signed
if [ ! -d "$APP_PATH" ]; then
    echo "❌ Error: App not found at $APP_PATH"
    echo "Please run: flutter build macos --release"
    echo "Then run: ./scripts/sign_and_notarize.sh"
    exit 1
fi

# Step 2: Verify app is notarized
echo "🔍 Verifying app is signed and notarized..."
if ! codesign --verify --verbose "$APP_PATH" 2>&1 | grep -q "valid on disk"; then
    echo "⚠️  Warning: App may not be properly signed"
    echo "Please run: ./scripts/sign_and_notarize.sh first"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Step 3: Clean previous DMG
echo "🧹 Cleaning previous DMG..."
rm -f "$DMG_PATH" "$TEMP_DMG"

# Step 4: Create temporary DMG
echo "🔨 Creating temporary DMG..."
hdiutil create -size 200m -fs HFS+ -volname "$VOLUME_NAME" "$TEMP_DMG"

# Step 5: Mount the DMG
echo "📂 Mounting DMG..."
MOUNT_POINT="/Volumes/$VOLUME_NAME"
MOUNTED_DISK=$(hdiutil attach "$TEMP_DMG" -mountpoint "$MOUNT_POINT" 2>&1 | grep "^/dev/disk" | head -1 | awk '{print $1}')
echo "   Mounted disk: ${MOUNTED_DISK}"

# Step 6: Copy app to DMG
echo "📋 Copying app to DMG..."
cp -R "$APP_PATH" "$MOUNT_POINT/"

# Step 7: Create Applications symlink
echo "🔗 Creating Applications symlink..."
ln -s /Applications "$MOUNT_POINT/Applications"

# Step 8: Set custom background (optional - you can add a background image)
# echo "🎨 Setting DMG appearance..."
# You can customize the DMG appearance here with AppleScript if needed

# Step 9: Unmount the DMG
echo "💿 Unmounting DMG..."
hdiutil detach "${MOUNTED_DISK}" -force

# Step 10: Convert to compressed, read-only DMG
echo "🗜️  Compressing DMG..."
hdiutil convert "$TEMP_DMG" -format UDZO -o "$DMG_PATH"

# Step 11: Clean up
echo "🧹 Cleaning up..."
rm -f "$TEMP_DMG"

# Step 12: Sign the DMG
echo "✍️  Signing DMG..."
DEVELOPER_ID="Developer ID Application: Ertan Sinik (58ELYTZDWA)"
codesign --sign "$DEVELOPER_ID" "$DMG_PATH"

# Step 13: Verify DMG signature
echo "🔍 Verifying DMG signature..."
codesign --verify --verbose "$DMG_PATH"

echo ""
echo "✨ Success! DMG created and signed."
echo "📍 DMG location: $DMG_PATH"
echo ""
echo "You can now distribute this DMG file!"
echo ""
echo "💡 Tip: Test the DMG by:"
echo "   1. Double-click to mount"
echo "   2. Drag app to Applications"
echo "   3. Launch from Applications folder"
