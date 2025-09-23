# Chezmoi Cheat Sheet
chezmoi init
chezmoi add ~/.bashrc
chezmoi edit ~/.bashrc
chezmoi diff
chezmoi -v apply

# Current packages:

## Explicit native (from official repos)
pacman -Qqen > pkglist-native.txt

## Explicit foreign (AUR/local builds)
pacman -Qqem > pkglist-aur.txt

