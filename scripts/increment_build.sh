#!/bin/bash

# Auto-increment build number in pubspec.yaml
# This script increases the build number (+1) automatically

set -e

PUBSPEC_FILE="pubspec.yaml"

echo "📝 Reading current version..."

# Extract current version and build number
CURRENT_VERSION=$(grep "^version:" "$PUBSPEC_FILE" | sed 's/version: //' | tr -d ' ')
VERSION_NUMBER=$(echo "$CURRENT_VERSION" | cut -d'+' -f1)
BUILD_NUMBER=$(echo "$CURRENT_VERSION" | cut -d'+' -f2)

echo "   Current: $VERSION_NUMBER+$BUILD_NUMBER"

# Increment build number
NEW_BUILD_NUMBER=$((BUILD_NUMBER + 1))
NEW_VERSION="${VERSION_NUMBER}+${NEW_BUILD_NUMBER}"

echo "   New:     $NEW_VERSION"

# Update pubspec.yaml
sed -i '' "s/version: $CURRENT_VERSION/version: $NEW_VERSION/" "$PUBSPEC_FILE"

echo "✅ Build number incremented!"
echo ""
