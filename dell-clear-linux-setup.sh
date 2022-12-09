#!/bin/bash
set -ex

# must run this script as regular user
if [[ "$USER" == "root" ]]; then
	echo "Run this script as regular user, not a super-user"
	exit 1
fi

USER_HOME_DIR="$(eval echo ~$USER)"

sudo swupd bundle-add desktop-gnomelibs desktop-locales desktop
sudo swupd bundle-add network-basic dev-utils hardware-bluetooth firmware-update
sudo swupd bundle-add git openssl go-basic-dev java11-basic python3-basic llvm gnupg maker-basic jq

sudo systemctl start bluetooth.service
sudo systemctl enable bluetooth.service

sudo swupd bundle-add containers-basic
sudo usermod -a -G docker $USER
sudo systemctl enable docker.service
sudo systemctl start docker.service

sudo sh -c 'echo "HibernateState=disk" > /etc/systemd/sleep.conf'
sudo sh -c 'echo "HibernateMode=shutdown" >> /etc/systemd/sleep.conf'
sudo mkdir -p /etc/modprobe.d
sudo sh -c 'echo "options snd-hda-intel model=auto" > /etc/modprobe.d/fix-audio-input.conf'
sudo mkdir -p /etc/bluetooth
sudo sh -c 'echo "AutoEnable=true" >> /etc/bluetooth/main.conf'

sudo swupd bundle-add zsh
chsh -s $(which zsh)

sudo swupd bundle-add fonts-basic
fc-cache -vf

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrep
flatpak install flathub org.gnome.Extensions
flatpak install flathub com.slack.Slack
flatpak install flathub com.visualudio.code
flatpak install flathub com.spotify.Client
flatpak install flathub com.google.Chrome

rm -rf ~/.jenv || true
git clone https://github.com/jenv/jenv.git ~/.jenv

"${USER_HOME_DIR}/.jenv/bin/jenv" init -

"${USER_HOME_DIR}/.jenv/bin/jenv" add /usr/lib/jvm/java-1.11.0-openjdk
"${USER_HOME_DIR}/.jenv/bin/jenv" global 11

wget --no-check-certificate http://install.ohmyz.sh -O - | sh

mkdir -p "${USER_HOME_DIR}/dev/menny"
git clone https://github.com/menny/dotfiles.git "${USER_HOME_DIR}/dev/menny/dotfiles"
"${USER_HOME_DIR}/dev/menny/dotfiles/dotfiles" restore
pushd "${USER_HOME_DIR}/dev/menny/dotfiles"
git remote remove origin
git remote add origin git@github.com:menny/dotfiles.git
git fetch origin
popd

sudo fwupdmgr refresh --force && sudo fwupdmgr update

zsh android-sdk-setup.sh

read -p "You must reboot to have everything taken effect. Do you want to reboot now? y/n" REBOOT
if [[ "$REBOOT" == "y" ]]; then
	echo "Rebooting..."
	sudo reboot
fi

