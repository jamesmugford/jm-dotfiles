# Install
git clone https://github.com/jamesmugford/jm-dotfiles.git .local/share/chezmoi

# Upstream (Tracked)
https://github.com/endeavouros-team/endeavouros-i3wm-setup/commits/main/

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


# Todo

install catpuccin theme

## Todo Install
howdy
espanso
starship?



# Extra

https://github.com/endeavouros-team/endeavouros-i3wm-setup
Tracked to:
e144575

https://github.com/endeavouros-team/EndeavourOS-packages-lists/


https://github.com/ChrisTitusTech/linutil
