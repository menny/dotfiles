# 🏠 Dotfiles Managed by chezmoi

This repository contains my personal configuration files for macOS and Linux, managed using [chezmoi](https://www.chezmoi.io/).

## 🚀 Getting Started on a New Machine

Because this repository manages my SSH keys, you must use **HTTPS** for the initial setup.

### 1. Install chezmoi
**macOS (Homebrew):**
```bash
brew install chezmoi
```

**Linux (One-liner):**
```bash
sh -c "$(curl -fsLS get.chezmoi.io)"
```

### 2. Restore the Decryption Key
My secrets (like SSH keys and `.secrets.rc`) are encrypted with `age`. 
1. Download `key.txt` from my **private Google Drive**.
2. Place it at: `~/.config/chezmoi/key.txt`
3. Set permissions: `chmod 600 ~/.config/chezmoi/key.txt`

### 3. Initialize and Apply
Run the following command to clone the repo and apply the configuration:
```bash
# Use HTTPS because SSH keys aren't deployed yet
chezmoi init --apply https://github.com/menny/dotfiles.git
```

---

## 🛠️ Basic Commands

### Syncing Changes
| Command | Action |
| :--- | :--- |
| `chezmoi add <file>` | Add a new file to the managed state |
| `chezmoi edit <file>` | Edit the source version of a managed file |
| `chezmoi apply` | Update your home directory with changes from the repo |
| `chezmoi diff` | View changes between your home directory and the repo |
| `chezmoi status` | See which files are modified |

### Pushing to GitHub
Chezmoi is just a Git repo under the hood. To push updates:
```bash
chezmoi cd
git add .
git commit -m "Update config"
git push
exit
```

---

## 🔐 Encryption
This setup uses **age** for file encryption.
- **Encrypted files:** Named with `encrypted_` prefix in the source.
- **Identity file:** Required at `~/.config/chezmoi/key.txt`.
- **Recipient:** Stored in `.chezmoi.toml.tmpl`.

---

## 🖥️ Supported OS
- **macOS** (Homebrew required)
- **Linux** (Ubuntu/Debian, Arch, Fedora)

> [!TIP]
> **Existing Local Clone:** If you already have this repo checked out locally (e.g. at `~/dev/dotfiles`), you can initialize chezmoi directly from your local path instead of cloning from GitHub:
> ```bash
> chezmoi init --source ~/dev/dotfiles
> chezmoi diff   # Preview changes before applying
> chezmoi apply  # Apply dotfiles to home directory
> ```