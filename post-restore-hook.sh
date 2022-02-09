#this script is sourced after successully restoring dotfiles links
#source "$script" "$repo_folder" "$HOME" "$TMPDIR"
pushd "$2/signatures" > /dev/null
mkdir -p "$2/.ssh" || true
mkdir -p "$2/.gnupg" || true
tar -xjf signatures_ssh.tar.bz2 -C "$2/.ssh"
chmod 700 "$2/.ssh"
chmod 600 "$2/.ssh/id_rsa"
tar -xjf signatures_gnupg.tar.bz2 -C "$2/.gnupg/"
popd > /dev/null
