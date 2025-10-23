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

## Talon
mkdir -p "$HOME/.local/opt/talon" &&
  tar -Jxf $HOME/Downloads/talon-linux-*.tar.xz --directory="$HOME/.local/opt"
git clone https://github.com/talonhub/community     $HOME/.talon/user/community
git clone https://github.com/jamesmugford/jm-talon  $HOME/.talon/user/jm-talon




https://github.com/ChrisTitusTech/linutil
