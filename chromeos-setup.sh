#!/bin/bash
set -ex

# must run this script as regular user
if [[ "$USER" == "root" ]]; then
	echo "Run this script as regular user, not a super-user"
	exit 1
fi
USER_HOME_DIR="$(eval echo ~$USER)"

# making sure root has a password
sudo sh -c "passwd $USER"
sudo apt update
sudo apt upgrade

sudo apt install -y git git-lfs
sudo apt install -y openssl wget curl golang openjdk-17-jdk
sudo apt install -y python3 python3-pip clang gnupg

go install github.com/bazelbuild/bazelisk@latest
sudo ln -s "$(go env GOPATH)/bin/bazelisk" "/usr/bin/bazelisk"
sudo ln -s "$(go env GOPATH)/bin/bazelisk" "/usr/bin/bazel"

sudo apt install -y usbutils
sudo apt install -y imagemagick
sudo apt install -y shellcheck yamllint jq

# z-shell
sudo apt install -y zsh nano

chsh -s $(which zsh)

sudo apt install -y docker docker-compose docker.io
sudo usermod -a -G docker $USER
sudo systemctl enable docker
sudo systemctl start docker

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

pushd "$USER_HOME_DIR/dev/menny"
git clone git@github.com:AnySoftKeyboard/AnySoftKeyboard.git
pushd AnySoftKeyboard
git remote add upstream git@github.com:AnySoftKeyboard/AnySoftKeyboard.git
git remote add menny git@github.com:menny/AnySoftKeyboard.git
popd
popd

echo ""
echo "Setup completed!"
echo "Run additional setup scripts after reboot."
