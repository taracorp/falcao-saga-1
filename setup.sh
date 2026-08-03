#!/bin/bash
# Falcao Saga - Environment Setup  
# Uses Godot 4.5.1 (stable, GLES3 renderer for Mali GPU compatibility)
export JAVA_HOME=/home/taradfs/.local/jdk17/jdk-17.0.20+8
export ANDROID_HOME=/home/taradfs/.android
export ANDROID_SDK_ROOT=/home/taradfs/.android
export PATH=$HOME/.local/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$JAVA_HOME/bin:$PATH

echo "=== Falcao Saga Environment ==="
echo "Godot: $(godot45 --version 2>&1 | head -1)"
echo "JDK:   $($JAVA_HOME/bin/java -version 2>&1 | head -1)"
echo "SDK:   $(ls $ANDROID_HOME/platforms/ 2>/dev/null)"
echo ""
echo "Build APK:"
echo "  godot45 --headless --path . --export-release \"Android\" build/falcao-saga.apk"
echo ""
echo "Run editor:"
echo "  godot45 --path . --editor"
echo "================================"
