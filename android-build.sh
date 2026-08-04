#!/bin/sh
set -eu

export ANDROID_HOME="${ANDROID_HOME:-$HOME/Android/Sdk}"
export ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-$ANDROID_HOME}"

cd "$(dirname "$0")"

BUILD_DIR="Builds"
mkdir -p "$BUILD_DIR"

# Resolve a short commit hash, prefixed so it's obviously the modded build at a glance
# (matches the M-{commit} scheme update.sh uses for the web deploy).
SHORT_HASH="$(git rev-parse --short=8 HEAD 2>/dev/null || true)"
if [ -z "$SHORT_HASH" ]; then
    SHORT_HASH="dev"
fi
VALOUR_SHORT_HASH="M-${SHORT_HASH}"
export VALOUR_SHORT_HASH
echo "Using VALOUR_SHORT_HASH=${VALOUR_SHORT_HASH}"

# Back up + patch source files before publish, restore after (mirrors cf-build's approach).
SHORTHASH_FILE_LIST="$(mktemp)"
SHORTHASH_BACKUP_DIR="$(mktemp -d)"
trap '
  if [ -f "$SHORTHASH_FILE_LIST" ]; then
    while IFS= read -r file; do
      if [ -f "$SHORTHASH_BACKUP_DIR/$file" ]; then
        cp "$SHORTHASH_BACKUP_DIR/$file" "$file"
      fi
    done < "$SHORTHASH_FILE_LIST"
  fi
  rm -rf "$SHORTHASH_BACKUP_DIR"
  rm -f "$SHORTHASH_FILE_LIST"
' EXIT

grep -RIl '$(SHORTHASH)' Valour > "$SHORTHASH_FILE_LIST" || true
while IFS= read -r file; do
    [ -n "$file" ] || continue
    mkdir -p "$SHORTHASH_BACKUP_DIR/$(dirname "$file")"
    cp "$file" "$SHORTHASH_BACKUP_DIR/$file"
    perl -pi -e 's/\$\(SHORTHASH\)/$ENV{VALOUR_SHORT_HASH}/g' "$file"
done < "$SHORTHASH_FILE_LIST"

dotnet publish Valour/Client.Maui/Valour.Client.Maui.csproj \
    -f net11.0-android \
    -c Release

PUBLISH_DIR="Valour/Client.Maui/bin/Release/net11.0-android/publish"

APK=$(find "$PUBLISH_DIR" -maxdepth 1 -iname "*-Signed.apk" | head -n1)
if [ -z "$APK" ]; then
    APK=$(find "$PUBLISH_DIR" -maxdepth 1 -iname "*.apk" | head -n1)
fi

if [ -z "$APK" ]; then
    echo "No APK found in $PUBLISH_DIR"
    exit 1
fi

OUTPUT_NAME="Modded Valour.apk"
cp "$APK" "$BUILD_DIR/$OUTPUT_NAME"
echo "APK copied to $BUILD_DIR/$OUTPUT_NAME"
