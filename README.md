# dotfiles
My personal dotfiles repo and related tools.

# Setup from web:
wget --no-check-certificate https://raw.githubusercontent.com/menny/dotfiles/master/dell-fedora-setup.sh -O - | sh

# Usage

 * `dotfiles restore` - links the dotfiles in this repo to the correct locations. This is usually happens once, when you restoring to a new machine.
 * `dotfiles commit` - commits and pushes local changes to repo.
 * `dotfiles add [backup-name] [full/path/to/.dotfile]` - adds a dotfile to this repo with the given name.
 * _(not supported)_ `dotfiles.sh add-enc [backup-name] [full/path/to/.dotfile]` - adds a dotfile to this repo with the given name, and encrypts it.
 * `dotfiles remove [backup-name]` - removes a dotfile from the list of backuped dotfiles.
 * `dotfiles add-bin [binary-name]` - adds a required bin.
 * `dotfiles remove-bin [binary-name]` - removes a required bin.
 * `dotfiles list` - prints out a list of all backup dotfiles and required bins.
 * `dotfiles noop` - does not do anything, but will run the git-dirty check and notify if the repo is dirty.

# Helpers

## add `dotfiles` script to PATH
To allow adding dotfiles from any folder, add to you shell rc script:
```
export PATH=$PATH:~/dev/menny/dotfiles
```

## dirty-repo checker
You might want to add a check to your shell rc file to see if there are changes in the repo that need to pushed.
```
#dot-files check
dotfiles noop
```
