#!/usr/bin/env bash
# Fetch the Khronos OpenXR loader for Android and place it where the Godot
# gradle template packages it. Stock Godot dlopens libopenxr_loader.so at
# runtime and ships no Android loader, so a template built without this step
# produces APKs whose OpenXR fails to start ("OpenXR loader not found").
# Run from the godot checkout root after the android scons build, before
# ./gradlew generateGodotTemplates.
set -euo pipefail
LV="${OPENXR_LOADER_VERSION:-1.1.49}"
DEST=platform/android/java/lib/libs/release/arm64-v8a
[ -d "$DEST" ] || { echo "run from the godot checkout root after the android build"; exit 1; }
TMP=$(mktemp -d)
curl -fsSL -o "$TMP/loader.aar" \
  "https://repo1.maven.org/maven2/org/khronos/openxr/openxr_loader_for_android/${LV}/openxr_loader_for_android-${LV}.aar"
unzip -qo "$TMP/loader.aar" -d "$TMP"
cp "$TMP/jni/arm64-v8a/libopenxr_loader.so" "$DEST/"
rm -rf "$TMP"
echo "bundled Khronos OpenXR loader ${LV} into $DEST"
