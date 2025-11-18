#!/bin/bash

# Complete Build, Sign, Notarize and Create DMG Script
# This script handles the complete macOS app distribution process

set -e

# Production URL configuration (static)
PRODUCTION_URL="https://task-ho-backend.vercel.app/api"

echo "🚀 Starting complete build process for TaskHo..."
echo "🌐 Backend URL: $PRODUCTION_URL"
echo ""

# Step 0: Increment build number
echo "🔢 Step 1/4: Incrementing build number..."
./scripts/increment_build.sh
echo ""

# Step 1: Build with production URL
echo "📱 Step 2/4: Building macOS app (universal arm64+x86_64)..."
flutter build macos --release --darwin-archs=arm64,x86_64 \
	--dart-define=TASKHO_BASE_URL="$PRODUCTION_URL"
echo "✅ Build complete!"
echo ""

# Step 2: Sign and Notarize
echo "✍️  Step 3/4: Signing and notarizing..."
./scripts/sign_and_notarize.sh
echo "✅ Sign and notarize complete!"
echo ""

# Step 3: Create DMG
echo "📦 Step 4/4: Creating DMG installer..."
./scripts/create_dmg.sh
echo "✅ DMG creation complete!"
echo ""

# Get version info for final message
PUBSPEC_FILE="pubspec.yaml"
FULL_VERSION=$(grep "^version:" "$PUBSPEC_FILE" | sed 's/version: //' | tr -d ' ')
VERSION_NUMBER=$(echo "$FULL_VERSION" | cut -d'+' -f1)
BUILD_NUMBER=$(echo "$FULL_VERSION" | cut -d'+' -f2)
DMG_NAME="TaskHo-v${VERSION_NUMBER}-b${BUILD_NUMBER}.dmg"

echo "🎉 All done! Your app is ready for distribution."
echo ""
mv "build/macos/Build/Products/Release/${DMG_NAME}" "dmg/${DMG_NAME}"
echo "📦 Distribution file:"
echo "   dmg/${DMG_NAME}"
echo ""
echo "📊 Version: ${VERSION_NUMBER}"
echo "🔢 Build: ${BUILD_NUMBER}"
echo ""
echo "🚢 You can now distribute this DMG file to users!"
