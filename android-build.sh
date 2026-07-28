#!/bin/sh
set -eu

export ANDROID_HOME="${ANDROID_HOME:-$HOME/Android/Sdk}"
export ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-$ANDROID_HOME}"

cd "$(dirname "$0")"

BUILD_DIR="Builds"
mkdir -p "$BUILD_DIR"

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
