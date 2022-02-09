#this script is sourced before adding a file to the dotfiles
#source "$script" "$repo_folder" "$HOME" "$TMPDIR"
mkdir -p "$2/signatures" || true
pushd "$2/signatures" > /dev/null
tar -cjf signatures_ssh.tar.bz2 -C "$2/.ssh" .
tar -cjf signatures_gnupg.tar.bz2 -C "$2/.gnupg/" .
popd > /dev/null
