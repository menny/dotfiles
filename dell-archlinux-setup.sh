#!/bin/bash
set -ex

# must run this script as regular user
if [[ "$USER" == "root" ]]; then
	echo "Run this script as regular user, not a super-user"
	exit 1
fi

USER_HOME_DIR="$(eval echo ~$USER)"

sudo pacman -Syy archlinux-keyring
sudo pacman -S --needed base-devel git git-lfs
sudo pacman -S openssl wget curl go jdk11-openjdk python3 python-pip clang gnupg

yay_git=$(mktemp -d)
git clone https://aur.archlinux.org/yay-git.git "$yay_git"
pushd "$yay_git"
makepkg -sri
popd

yay -Syy google-chrome
yay -S globalprotect-openconnect-git

yay -S bazelisk
sudo ln -s $(which bazel) /usr/bin/bazelisk

yay -S snapd
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap
snap install snap-store

sudo sh -c 'echo "HibernateState=disk" > /etc/systemd/sleep.conf'
sudo sh -c 'echo "HibernateMode=shutdown" >> /etc/systemd/sleep.conf'
sudo sh -c 'echo "options snd-hda-intel model=auto" > /etc/modprobe.d/fix-audio-input.conf'
sudo sh -c 'echo "AutoEnable=true" >> /etc/bluetooth/main.conf'

sudo pacman -Syy fwupd gnome-firmware \
	networkmanager wireless_tools \
	usbutils \
	bluez bluez-utils \
	wmctrl xdotool imagemagick \
	shellcheck yamllint \
	zsh zsh-completions \
	cups cups-pdf \
	man-db man-pages

sudo pacman -S docker
sudo usermod -a -G docker $USER
sudo systemctl enable docker.service
sudo systemctl start docker.service

chsh -s $(which zsh)
#homectl update --shell=$(which zsh)
sudo pacman -S nvidia nvidia-dkms \
	libxnvctrl nvidia-utils nvidia-settings \
	libvdpau opencl-nvidia \
	ffnvcodec-headers \
	xorg-server-devel xorg-xwayland egl-wayland \
	primus_vk bumblebee mesa nvidia-prime
sudo bash -c "echo 'blacklist nouveau' > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
sudo gpasswd -a $USER bumblebee
sudo systemctl enable bumblebeed.service

sudo mkdir -p /etc/pacman.d/hooks
sudo sh -c 'echo "[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia

[Action]
Description=Update Nvidia module in initcpio
Depends=mkinitcpio
When=PostTransaction
Exec=/usr/bin/mkinitcpio -P" > /etc/pacman.d/hooks/nvidia.hook'

sudo pacman -S gnome-themes-extra
sudo pacman -S ttf-dejavu noto-fonts ttf-ms-fonts noto-fonts-emoji
fc-cache -vf

sudo systemctl start bluetooth.service
sudo systemctl enable bluetooth.service

sudo systemctl disable cups.service
sudo systemctl enable cups.socket

sudo pacman -S flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrep
flatpak install org.gnome.Extensions

yay -S chrome-gnome-shell
yay -S keybase-bin
run_keybase

yay -Syyu

git clone https://github.com/jenv/jenv.git ~/.jenv
snap install slack --classic
snap install spotify
snap install code --classic

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

sudo bootctl list
read -p "Enter kernel ID to use in boot. Empty to skip." KERNEL_ID
if [[ ! -z "$KERNEL_ID" ]]; then
	sudo bootctl set-default "$KERNEL_ID"
	sudo bootctl list
fi

echo "*** Looking for lm-sensors (fan-control). This might be better to repeat after reboot!"
sudo sensors-detect

read -p "You must reboot to have everything taken effect. Do you want to reboot now? y/n" REBOOT
if [[ "$REBOOT" == "y" ]]; then
	echo "Rebooting..."
	sudo reboot
fi
