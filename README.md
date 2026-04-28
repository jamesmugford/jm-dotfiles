# James Mugford's Dotfiles

EndeavourOS i3 (X11) dotfiles managed with chezmoi.

## Quick start
Base system handled by the EndeavourOS installer.
Install core packages.
```sh
sudo pacman -S --needed chezmoi btop code fastfetch alacritty papirus-icon-theme picom ttf-jetbrains-mono-nerd neovim autotiling lazygit
```
Apply the dotfiles.
```sh
git clone https://github.com/jamesmugford/jm-dotfiles.git .local/share/chezmoi
chezmoi apply
```
Optional: Neovim starter.
```sh
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
```

## Optional packages

### Utilities
```sh
sudo pacman -S --needed fzf bat bluetui gnome-keyring snixembed yazi
```

### Apps
```sh
sudo pacman -S --needed 7zip firefox-developer-edition gimp inkscape gparted obs-studio obsidian qalculate-gtk pavucontrol seahorse keepassxc chromium
yay -S --needed github-desktop-bin jetbrains-toolbox visual-studio-code-bin opencode-bin snapper-gui-git synology-drive
```

### 3D
```sh
sudo pacman -S blender 
yay -S --needed spacenavd spnavcfg 
```
https://aur.archlinux.org/packages/unreal-engine-bin

### Unreal Engine (AUR, system-wide)

```sh
mkdir -p ~/build/aur
rm -rf ~/build/aur/unreal-engine-bin
git clone https://aur.archlinux.org/unreal-engine-bin.git ~/build/aur/unreal-engine-bin
cd ~/build/aur/unreal-engine-bin

# Apply patch copied from AUR comments
patch -p1 < ~/patches/aur-ue-5.7.0-to-5.7.2.patch

# Download from https://www.unrealengine.com/linux
# If your browser renamed it (for example with " (1)"), adjust the source filename.
cp ~/Downloads/Linux_Unreal_Engine_5.7.2.zip .

makepkg -si

# Optional cleanup
cd ~/build/aur && rm -rf unreal-engine-bin
```

For future versions, update the patch filename and the zip version in the `cp` command.


### Nvidia
```sh
sudo pacman -S --needed nvidia-settings nvtop
```

### Programming
```sh
sudo pacman -S --needed mise
```

## Keybindings Overview

| Keybinding | Action | Keybinding | Action |
|---|---|---|---|
| `Mod + Return` | Launch terminal | `Mod + H` | Split in horizontal orientation |
| `Mod + D` | Open menu | `Mod + V` | Split in vertical orientation |
| `Mod + Shift + Q` | Close focused window | `Mod + Space` | Toggle focus mode (tiling / floating) |
| `Mod + F` | Toggle fullscreen | `Mod + Shift + Space` | Toggle tiling / floating mode |
| `Mod + Q` | Launch Firefox Developer Edition | `Mod + J/K/L/;` | Change focus direction |
| `Mod + W` | Open recent VSC workspace | `Mod + Shift + J/K/L/;` | Move focused window |
| `Mod + E` | Open file manager (Nemo) | `Mod + 1 to 0` | Switch to workspaces 1 to 10 |
| `Mod + A` | Open menu (drun version) | `Mod + Shift + 1 to 0` | Move focused window to workspaces 1 to 10 |
| `Mod + S` | Open screenshots dir in Nemo | `Mod + Shift + E` | Exit i3 |
| `Mod + X` | Open powermenu | `Mod + Shift + C` | Reload i3 config file |
| `Mod + C` | Launch screenshot script | `Mod + B` | Move workspace to the other monitor |
| `Mod + I` | Lock screen | `Mod + N` | Set dual monitor mode |
| `Mod + G` | Enter gap mode | `Mod + M` | Set single-monitor mode |

## Color palette

|   Bg   |   Bg 2   |   Bg 3   |  Border  |   Fg   |  White   |  Gray   |  Black   |
|:------:|:--------:|:--------:|:--------:|:------:|:--------:|:-------:|:--------:|
| `#1b1b25` | `#282A36` | `#16161e` | `#343746` | `#dedede` | `#eeffff` | `#727480` | `#15121c` |
| ![#1b1b25](https://placehold.co/77x15/1b1b25/1b1b25.png) | ![#282A36](https://placehold.co/77x15/282A36/282A36.png) | ![#16161e](https://placehold.co/77x15/16161e/16161e.png) | ![#343746](https://placehold.co/77x15/343746/343746.png) | ![#dedede](https://placehold.co/77x15/dedede/dedede.png) | ![#eeffff](https://placehold.co/77x15/eeffff/eeffff.png) | ![#727480](https://placehold.co/77x15/727480/727480.png) | ![#15121c](https://placehold.co/77x15/15121c/15121c.png) |

| Red       | Green    | Yellow   | Blue     | Purple   | Cyan     | Pink     | Orange   |
|:------:|:--------:|:--------:|:--------:|:------:|:--------:|:-------:|:--------:|
| `#cb5760` | `#999f63`| `#d4a067`| `#6c90a8`| `#776690`| `#528a9b`| `#ffa8c5`| `#c87c3e`|
| ![#cb5760](https://placehold.co/77x15/cb5760/cb5760.png) | ![#999f63](https://placehold.co/77x15/999f63/999f63.png) | ![#d4a067](https://placehold.co/77x15/d4a067/d4a067.png) | ![#6c90a8](https://placehold.co/77x15/6c90a8/6c90a8.png) | ![#776690](https://placehold.co/77x15/776690/776690.png) | ![#528a9b](https://placehold.co/77x15/528a9b/528a9b.png) | ![#ffa8c5](https://placehold.co/77x15/ffa8c5/ffa8c5.png) | ![#c87c3e](https://placehold.co/77x15/c87c3e/c87c3e.png) |


## Niri outputs Toggle
```sh
ln -sfn "$HOME/.config/niri/outputs-primary.kdl" "$HOME/.config/niri/outputs-current.kdl"

```

## OpenTabletDriver

```sh
# May require more commands. See: https://opentabletdriver.net/Wiki/Install/Linux#aur-helper-method

yay -S opentabletdriver

systemctl --user enable opentabletdriver.service --now

sudo tee /etc/udev/rules.d/99-uinput-permissions.rules >/dev/null <<'EOF'
KERNEL=="uinput", GROUP="input", MODE="0660", TAG+="uaccess", OPTIONS+="static_node=uinput"
EOF
sudo udevadm control --reload
sudo udevadm trigger /dev/uinput
systemctl --user restart opentabletdriver

```


## Extras

[Secure boot with sbctl](https://wiki.cachyos.org/configuration/secure_boot_setup/)


### Talon
```sh
mkdir -p "$HOME/.local/opt/talon" &&
  tar -Jxf $HOME/Downloads/talon-linux-*.tar.xz --directory="$HOME/.local/opt"
git clone https://github.com/talonhub/community $HOME/.talon/user/community
git clone https://github.com/jamesmugford/jm-talon $HOME/.talon/user/jm-talon
git clone https://github.com/jamesmugford/jm-talon-lite $HOME/.talon/user/jm-talon-lite
```

### Notes
Stop screen tearing: https://wiki.archlinux.org/title/NVIDIA/Troubleshooting#Avoid_screen_tearing
https://github.com/ChrisTitusTech/linutil

## Upstream (Tracked)
* https://github.com/endeavouros-team/endeavouros-i3wm-setup/commits/main/
* https://github.com/Keyitdev/dotfiles/

## Chezmoi Cheat Sheet
```sh
chezmoi init
chezmoi add ~/.bashrc
chezmoi edit ~/.bashrc
chezmoi diff
chezmoi -v apply
```
