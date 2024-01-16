#!/bin/bash
set -ex

# set up ADB permissions
sudo groupadd androiddev
sudo usermod -aG androiddev "$USER"
# vendor 18d1 is Google
sudo sh -c 'echo "SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"18d1\", MODE=\"0666\"" /etc/udev/rules.d/99-android.rules'

# installing stuff
USER_HOME_DIR="$(eval echo ~$USER)"

pushd "$USER_HOME_DIR/dev/menny"
git clone git@github.com:AnySoftKeyboard/AnySoftKeyboard.git
pushd AnySoftKeyboard
git remote add upstream git@github.com:AnySoftKeyboard/AnySoftKeyboard.git
git remote add menny git@github.com:menny/AnySoftKeyboard.git
popd
popd

mkdir -p "$USER_HOME_DIR/dev/sdk/temp-tools"
wget https://dl.google.com/android/repository/commandlinetools-linux-8092744_latest.zip -O "$USER_HOME_DIR/android-command-line-tools.zip"
unzip "$USER_HOME_DIR/android-command-line-tools.zip" -d "$USER_HOME_DIR/dev/sdk/temp-tools"
rm "$USER_HOME_DIR/android-command-line-tools.zip"

"$USER_HOME_DIR/dev/sdk/temp-tools/cmdline-tools/bin/sdkmanager" --sdk_root="$USER_HOME_DIR/dev/sdk" \
	"sources;android-34" "platforms;android-34" \
	"platform-tools" "cmdline-tools;latest" \

rm -rf "$USER_HOME_DIR/dev/sdk/temp-tools"

# wget "https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2021.1.1.22/android-studio-2021.1.1.22-linux.tar.gz" -O "$USER_HOME_DIR/android_studio.tar.gz"
# tar -xf "$USER_HOME_DIR/android_studio.tar.gz" -C "$USER_HOME_DIR/dev/"
# rm "$USER_HOME_DIR/android_studio.tar.gz"

# "$USER_HOME_DIR/dev/android-studio/bin/studio.sh"
