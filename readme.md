## Installing packages

In this directory, use `stow`:
- only one package: `stow -t ~/ -S git`
- or multiple: `stow -t ~/ -S git kitty nvim...`
- or all: `./stow.sh`
Remove links by replacing `-S` by `-D`, and force reinstall by using `-R` instead.

## Useful notes

# Git
To avoid committing git user.name and user.email, add them to the file `~/.config/git/config` (create it if it doesn't exist).
