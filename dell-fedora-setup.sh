#!/bin/bash
set -ex

# must run this script as regular user
if [[ "$USER" == "root" ]]; then
	echo "Run this script as regular user, not a super-user"
	exit 1
fi
USER_HOME_DIR="$(eval echo ~$USER)"

# making DNF faster
sudo sh -c 'echo "max_parallel_downloads=5" >> /etc/dnf/dnf.conf'
sudo sh -c 'echo "fastestmirror=True" >> /etc/dnf/dnf.conf'

sudo dnf install -y dnf-plugins-core

sudo dnf update

sudo dnf install -y fedora-workstation-repositories

sudo dnf install -y gnome-keyring
sudo dnf install -y kernel-devel
sudo dnf install -y git git-lfs
sudo dnf install -y openssl wget curl golang java-11-openjdk-devel.x86_64 java-17-openjdk-devel.x86_64 python3 python-pip clang gnupg
sudo dnf install -y ruby rubygems

#required for Pano clipboard extesion
sudo dnf install libgda libgda-sqlite

sudo dnf config-manager --set-enabled google-chrome
sudo dnf install -y google-chrome-stable

sudo dnf install -y openconnect

go install github.com/bazelbuild/bazelisk@latest
sudo ln -s "$(go env GOPATH)/bin/bazelisk" "/usr/bin/bazelisk"
sudo ln -s "$(go env GOPATH)/bin/bazelisk" "/usr/bin/bazel"

sudo dnf install -y snapd
sudo systemctl enable --now snapd.socket
sudo systemctl start --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap
sudo snap refresh
sudo snap install snap-store || true

sudo dnf install -y fwupd gnome-firmware
sudo dnf install -y NetworkManager NetworkManager-openconnect NetworkManager-openconnect-gnome
sudo dnf install -y gnome-tweaks gnome-themes-extra
sudo dnf install -y usbutils
sudo dnf install -y ImageMagick
sudo dnf install -y ShellCheck yamllint jq
sudo dnf install -y cups cups-pdf
sudo dnf install -y man-db man-pages

sudo dnf install -y zsh nano util-linux-user

chsh -s $(which zsh)

sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

sudo dnf remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -a -G docker $USER
sudo systemctl enable docker
sudo systemctl start docker

sudo dnf install -y akmod-nvidia \
	nvidia-settings nvidia-gpu-firmware

sudo dnf install -y dejavu-fonts-all google-roboto-fonts google-noto-emoji-color-fonts
fc-cache -vf

sudo systemctl start bluetooth.service
sudo systemctl enable bluetooth.service

sudo systemctl disable cups.service
sudo systemctl enable cups.socket

sudo systemctl enable nvidia-suspend.service
sudo systemctl enable nvidia-hibernate.service
sudo systemctl enable nvidia-resume.service

sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrep

flatpak install -y flathub org.gnome.Extensions
flatpak install -y flathub com.slack.Slack
flatpak install -y flathub com.raggesilver.BlackBox
flatpak install -y flathub org.openscad.OpenSCAD
flatpak install -y flathub com.ultimaker.cura

sudo dnf install -y gnome-browser-connector
sudo dnf install -y https://prerelease.keybase.io/keybase_amd64.rpm
run_keybase

sudo dnf install -y system-config-printer

git clone https://github.com/jenv/jenv.git "${USER_HOME_DIR}/.jenv"
"${USER_HOME_DIR}/.jenv/bin/jenv" init -

"${USER_HOME_DIR}/.jenv/bin/jenv" add /usr/lib/jvm/java-17-openjdk
"${USER_HOME_DIR}/.jenv/bin/jenv" add /usr/lib/jvm/java-11-openjdk
"${USER_HOME_DIR}/.jenv/bin/jenv" global 17

snap install spotify
snap install code --classic

wget --no-check-certificate http://install.ohmyz.sh -O - | sh

mkdir -p "${USER_HOME_DIR}/dev/menny"
git clone https://github.com/menny/dotfiles.git "${USER_HOME_DIR}/dev/menny/dotfiles"
"${USER_HOME_DIR}/dev/menny/dotfiles/dotfiles" restore
pushd "${USER_HOME_DIR}/dev/menny/dotfiles"
#switching from http to ssh
git remote remove origin
git remote add origin git@github.com:menny/dotfiles.git
popd

ssh-keygen -R github.com

#gnome extensions
pip3 install --upgrade gnome-extensions-cli
gnome_ext_array=( 4651 615 1460 5278 )

for i in "${gnome_ext_array[@]}"
do
    gnome-extensions-cli install "$i"
    gnome-extensions-cli enable "$i"
done

#firmwares
sudo fwupdmgr refresh --force && sudo fwupdmgr update

echo ""
echo "Setup completed!"
echo "Run additional setup scripts after reboot."
read -p "You must reboot to have everything taken effect. Do you want to reboot now? y/n" REBOOT
if [[ "$REBOOT" == "y" ]]; then
	echo "Rebooting..."
	sudo reboot
fi
