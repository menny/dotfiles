
function install_from_git() {
	local git_url="$1"
	local temp_git=$(mktemp -d)
	git clone "$git_url" "$temp_git"
	pushd "$temp_git"
	makepkg -sri
	sudo pacman -U $(ls *.tar.zst)
	popd
}

install_from_git "$1"
