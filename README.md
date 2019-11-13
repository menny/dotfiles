# dotfiles
My personal dotfiles repo and related tools.

# Usage

 * `dotfiles.sh restore` - links the dotfiles in this repo to the correct locations.
 * `dotfiles.sh add [backup-name] [full/path/to/.dotfile]` - adds a dotfile to this repo with the given name.
 * _(not supported)_ `dotfiles.sh add-enc [backup-name] [full/path/to/.dotfile]` - adds a dotfile to this repo with the given name, and encrypts it.
 * `dotfiles.sh remove [backup-name]` - removes a dotfile from the list of backuped dotfiles.
 * `dotfiles.sh add-bin [binary-name]` - adds a required bin.
 * `dotfiles.sh remove-bin [binary-name]` - removes a required bin.
 * `dotfiles.sh list` - prints out a list of all backup dotfiles and required bins.

# Helpers

 ## dirty-repo checker
 You might want to add a check to your shell rc file to see if there are changes in the repo that need to pushed.
 ```
 #dot-files check
if [[ $(git --git-dir=dev/menny/dotfiles/.git --work-tree=dev/menny/dotfiles diff --stat) != '' ]]; then
  echo '[DOTFILES] your dotfiles repo is marked as dirty. You might want to push the recent changes to your remote repo.'
fi
```
