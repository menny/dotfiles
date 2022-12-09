#!/bin/bash
set -ex

USER_HOME_DIR="$(eval echo ~$USER)"

# pushd "$USER_HOME_DIR/dev/menny"
# git clone git@github.com:menny/AnySoftKeyboard.git
# pushd AnySoftKeyboard
# git remote add upstream git@github.com:AnySoftKeyboard/AnySoftKeyboard.git
# git pull upstream main
# git push origin main
# popd
# popd

# mkdir -p "$USER_HOME_DIR/dev/sdk/temp-tools"
# wget https://dl.google.com/android/repository/commandlinetools-linux-8092744_latest.zip -O "$USER_HOME_DIR/android-command-line-tools.zip"
# unzip "$USER_HOME_DIR/android-command-line-tools.zip" -d "$USER_HOME_DIR/dev/sdk/temp-tools"
# rm "$USER_HOME_DIR/android-command-line-tools.zip"

"$USER_HOME_DIR/dev/sdk/temp-tools/cmdline-tools/bin/sdkmanager" --sdk_root="$USER_HOME_DIR/dev/sdk" \
	"sources;android-31" "platforms;android-31" \
	"platform-tools" "patcher;v4" "cmdline-tools;latest" \

rm -rf "$USER_HOME_DIR/dev/sdk/temp-tools"

wget "https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2021.1.1.22/android-studio-2021.1.1.22-linux.tar.gz" -O "$USER_HOME_DIR/android_studio.tar.gz"
tar -xf "$USER_HOME_DIR/android_studio.tar.gz" -C "$USER_HOME_DIR/dev/"
rm "$USER_HOME_DIR/android_studio.tar.gz"

"$USER_HOME_DIR/dev/android-studio/bin/studio.sh"

