#!/bin/bash
set -ex

# must run this script as regular user
if [[ "$USER" == "root" ]]; then
	echo "Run this script as regular user, not a super-user"
	exit 1
fi


sudo pacman -Sy archlinux-keyring
sudo pacman -S --needed base-devel git
sudo pacman -Sy openssl wget curl go jdk11-openjdk python3 clang

yay_git=$(mktemp -d)
git clone https://aur.archlinux.org/yay-git.git "$yay_git"
pushd "$yay_git"
makepkg -sri
popd

yay -S google-chrome

yay -S bazelisk
sudo ln -s $(which bazel) /usr/bin/bazelisk

yay -S snapd
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap
snap install snap-store

sudo echo "HibernateState=disk" > /etc/systemd/sleep.conf
sudo echo "HibernateMode=shutdown" >> /etc/systemd/sleep.conf
sudo echo "options snd-hda-intel model=auto" > /etc/modprobe.d/fix-audio-input.conf
sudo echo "AutoEnable=true" >> /etc/bluetooth/main.conf

sudo pacman -Syy fwupd gnome-firmware \
	networkmanager wireless_tools \
	bluez bluez-utils \
	wmctrl xdotool imagemagick \
	zsh zsh-completions \
	cups cups-pdf
chsh -s $(which zsh)
#homectl update --shell=$(which zsh)
sudo pacman -S nvidia nvidia-dkms \
	libxnvctrl nvidia-utils nvidia-settings \
	libvdpau opencl-nvidia \
	ffnvcodec-headers \
	xorg-server-devel xorg-xwayland egl-wayland \
	primus_vk bumblebee mesa nvidia-prime
sudo bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
sudo gpasswd -a $USER bumblebee
sudo systemctl enable bumblebeed.service

sudo pacman -S gnome-themes-extra
sudo pacman -S ttf-dejavu

sudo systemctl start bluetooth.service
sudo systemctl enable bluetooth.service

sudo systemctl disable cups.service
sudo systemctl enable cups.socket

sudo pacman -Syyu

git clone https://github.com/jenv/jenv.git ~/.jenv
snap install slack --classic
snap install spotify
snap install code --classic
snap alias code code

wget --no-check-certificate http://install.ohmyz.sh -O - | sh
