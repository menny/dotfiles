# dotfiles
My personal dotfiles repo

#Usage

 * `dotfiles.sh restore` - links the dotfiles in this repo to the correct locations.
 * `dotfiles.sh add [backup-name] [full/path/to/.dotfile]` - adds a dotfile to this repo with the given name.
 * _(not supported)_ `dotfiles.sh add-enc [backup-name] [full/path/to/.dotfile]` - adds a dotfile to this repo with the given name, and encrypts it.
 * `dotfiles.sh remove [backup-name]` - removes a dotfile from the list of backuped dotfiles.
 * `dotfiles.sh add-bin [binary-name]` - adds a required bin.
 * `dotfiles.sh remove-bin [binary-name]` - removes a required bin.
 * `dotfiles.sh list` - prints out a list of all backup dotfiles and required bins.
 