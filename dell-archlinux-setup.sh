#!/bin/bash
set -e

ACTUAL_USER="$1"
if [[ -z "$ACTUAL_USER" ]]; then
	echo "First arg is the actual username to install stuff on"
	exit 1
fi

function install_from_git() {
	local git_url="$1"
	local temp_git=$(mktemp -d)
	chown -R "$ACTUAL_USER" "$temp_git"
	runuser -u "$ACTUAL_USER" -- git clone "$git_url" "$temp_git"
	pushd "$temp_git"
	runuser -u "$ACTUAL_USER" -- makepkg -sri
	pacman -U $(ls *.tar.zst)
	popd
}

pacman -Sy archlinux-keyring
pacman -S --needed base-devel git
pacman -Sy openssl wget curl go
pacman -Sy flatpak
pacman -Sy jdk11-openjdk

install_from_git https://aur.archlinux.org/google-chrome.git
install_from_git https://aur.archlinux.org/bazelisk.git
install_from_git https://aur.archlinux.org/yaru.git

echo "HibernateState=disk" > /etc/systemd/sleep.conf
echo "HibernateMode=shutdown" >> /etc/systemd/sleep.conf
echo "options snd-hda-intel model=auto" > /etc/modprobe.d/fix-audio-input.conf
echo "AutoEnable=true" >> /etc/bluetooth/main.conf

pacman -Sy fwupd gnome-firmware
pacman -Sy networkmanager wireless_tools
pacman -Sy bluez bluez-utils
pacman -Sy xorg-xwayland
pacman -Sy wmctrl xdotool imagemagick
pacman -Sy zsh zsh-completions
pacman -Sy cups cups-pdf
chsh -s $(which zsh) "$ACTUAL_USER"
#homectl update --shell=$(which zsh) "$ACTUAL_USER"
pacman -S nvidia nvidia-utils nvidia-settings xorg-server-devel opencl-nvidia
bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
pacman -Sy gnome-themes-extra
pacman -Syyu

runuser -u "$ACTUAL_USER" -- git clone https://github.com/jenv/jenv.git ~/.jenv
runuser -u "$ACTUAL_USER" -- flatpak install Slack
runuser -u "$ACTUAL_USER" -- flatpak install Spotify
runuser -u "$ACTUAL_USER" -- flatpak install com.visualstudio.code

runuser -u "$ACTUAL_USER" -- wget --no-check-certificate http://install.ohmyz.sh -O - | sh

systemctl start bluetooth.service
systemctl enable bluetooth.service

systemctl start cups.socket
systemctl enable cups.socket
systemctl disable cups.service