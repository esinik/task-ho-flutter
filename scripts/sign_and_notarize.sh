#!/bin/bash

# macOS App Sign and Notarize Script
# This script signs and notarizes a Flutter macOS app

set -e

# Configuration
DEVELOPER_ID="Developer ID Application: Ertan Sinik (58ELYTZDWA)"
APPLE_ID="e_sinik@hotmail.com"
TEAM_ID="58ELYTZDWA"
APP_SPECIFIC_PASSWORD="xqod-rehe-onfr-qacp"
APP_PATH="build/macos/Build/Products/Release/taskho.app"
ZIP_PATH="build/macos/Build/Products/Release/taskho.zip"

echo "🔨 Starting sign and notarization process..."

# Step 1: Clean previous builds if needed
echo "📦 Checking app bundle..."
if [ ! -d "$APP_PATH" ]; then
    echo "❌ Error: App not found at $APP_PATH"
    echo "Please run: flutter build macos --release"
    exit 1
fi

# Step 2: Sign the app
echo "✍️  Signing the app..."
codesign --deep --force --verbose --options runtime \
    --sign "$DEVELOPER_ID" \
    "$APP_PATH"

# Step 3: Verify signing
echo "🔍 Verifying signature..."
codesign --verify --verbose "$APP_PATH"
codesign --display --verbose=4 "$APP_PATH"

# Step 4: Create ZIP for notarization
echo "📦 Creating ZIP archive..."
rm -f "$ZIP_PATH"
ditto -c -k --keepParent "$APP_PATH" "$ZIP_PATH"

# Step 5: Submit for notarization
echo "🚀 Submitting to Apple for notarization..."
echo "This may take a few minutes..."

xcrun notarytool submit "$ZIP_PATH" \
    --apple-id "$APPLE_ID" \
    --team-id "$TEAM_ID" \
    --password "$APP_SPECIFIC_PASSWORD" \
    --wait

# Step 6: Staple the notarization ticket
echo "📌 Stapling notarization ticket..."
xcrun stapler staple "$APP_PATH"

# Step 7: Verify notarization
echo "✅ Verifying notarization..."
spctl --assess --verbose "$APP_PATH"

echo ""
echo "✨ Success! Your app is signed and notarized."
echo "📍 App location: $APP_PATH"
echo "📦 ZIP location: $ZIP_PATH"
echo ""
echo "You can now distribute your app!"
