# James Mugford's Dotfiles. 

System:
Arch, Chezmoi. 
Built on top of Endevour OS's i3 install.

### [Installation](#installation) · [Contributions](#support-and-contributions) · [Detailed information](#detailed-information)

## Installation
Install base system.
```sh
sudo pacman -S --needed pulseaudio xorg
```
Install dependencies.
```sh
yay -S --needed btop code fastfetch alacritty kitty mate-polkit mpd ncmpcpp papirus-icon-theme picom zsh zed ttf-roboto-mono ttf-iosevka-nerd ffcast inotify-tools libnotify rofi-vscode-mode slop xclip
```

Clone this repository and copy files.
```sh
# Install
git clone https://github.com/jamesmugford/jm-dotfiles.git .local/share/chezmoi
chezmoi apply
```



Set zsh as default shell.
```sh
chsh -s /bin/zsh
```

```sh
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
```


```sh
yay -S dhcpcd
sudo systemctl enable --now dhcpcd.service
```

Install optional dependencies.
```sh
yay -S --needed bc fzf mpc nano vim net-tools tree
```
```sh
yay -S --needed 7zip czkawka-gui firefox-beta-bin firefox-developer-edition gimp inkscape gparted libreoffice-fresh vlc nemo nemo-fileroller obs-studio obsidian qalculate-gtk vnstat yt-dlp
```
```sh
yay -S --needed cpupower-gui ntfs-3g nvidia cuda nvtop vulkan-radeon
```
```sh
yay -S --needed cloc cronie docker gcc clang make npm python pypy python-numpy python-pandas python-scipy python-matplotlib python-requests tmux
```
Enable optional services.
```sh
sudo systemctl enable ntpd.service
sudo systemctl enable vnstat.service
```


# James new
```sh
yay -S github-desktop-bin snapper-gui-git synology-drive visual-studio-code-bin
```

```sh
yay -S plex-desktop
```

```sh
sudo pacman -S chezmoi bat bluetui gnome-keyring seahorse mise nvidia-settings pavucontrol snixembed yazi
```




### Dependencies

#### Base (~190 Mib)
- `dhcpcd` - DHCP client *(optional)*  
- `pulseaudio` - sound server for handling audio
- `xorg` - display server

#### Programs (~607 Mib)
- `btop` - resource monitor
- `code` - code editor
- `fastfetch` - system information fetcher
- `kitty` - terminal emulator
- `i3lock-color` - lock screen *(AUR)*
- `mate-polkit` - controlling system-wide privileges
- `mpd` - music playback service
- `ncmpcpp` - MPD client
- `papirus-icon-theme` - modern icon pack
- `picom` - compositor for X11
- `polybar` - status bar
- `zsh` - shell
- `zed` - code editor

#### Fonts (~1040 Mib)
- `ttf-roboto-mono ttf-iosevka-nerd`

#### Scripts (~3 Mib)
- `ffcast` - script for recording your screen *(AUR)* 
- `inotify-tools` - command-line utilities for monitoring filesystem events
- `libnotify` - library for sending desktop notifications  
- `rofi-vscode-mode` - lauch recently used vsc workspace
- `slop` - select a region on screen
- `xclip` - clipboard manager for X

### Additional dependencies
All of these packages are optional, but without them, some things may not work correctly.
I recommend atleast installing basic utilities.
To install all packages, you need approximately 8.4 GiB of free disk space (5 GiB takes cuda package).

#### Basic utilities (optional) (~21 Mib)
`yay -S bc fzf mpc nano vim net-tools tree`
- `bc` - command-line calculator  
- `fzf` - fuzzy finder  
- `mpc` - comand-line MPD client  
- `nano vim` - text editors  
- `net-tools` - network tools  
- `tree` - directory tree viewer  

#### Basic programs (optional) (~1700Mib)
`yay -S 7zip czkawka-gui firefox-beta-bin firefox-developer-edition gimp inkscape gparted libreoffice-fresh vlc nemo nemo-fileroller obs-studio obsidian qalculate-gtk vnstat yt-dlp`
- `7zip` - archiver  
- `czkawka-gui` - duplicate finder  
- `firefox-beta-bin firefox-developer-edition`  - web browsers
- `gimp inkscape` - image editors
- `gparted` - partition tool
- `libreoffice-fresh` - office suite  
- `vlc` - media player 
- `nemo nemo-fileroller` - file manager  
- `obs-studio` - screen recorder  
- `obsidian` - notes app  
- `qalculate-gtk` - calculator with advanced functions
- `vnstat` - network monitor 
- `yt-dlp` - video downloader  

#### Drivers (optional) (~4900 Mib)
`yay -S cpupower-gui ntfs-3g nvidia cuda nvtop vulkan-radeon`
- `cpupower-gui` - CPU settings 
- `ntfs-3g` - NTFS filesystem support  
- `nvidia cuda nvtop` - NVIDIA drivers
- `vulkan-radeon` - AMD Vulkan 

#### Programming (optional) (~1000Mib)
`yay -S cloc cronie docker gcc clang make npm python pypy python-numpy python-pandas python-scipy python-matplotlib python-requests tmux`
- `cloc` - counts lines of code  
- `cronie` - task scheduler  
- `docker` - container platform  
- `gcc clang make` - compilers and build tools  
- `npm` - Node.js package manager  
- `python pypy python-numpy python-pandas python-scipy python-matplotlib python-requests` - Python interpreters and libraries  
- `tmux` - terminal multiplexer  

### Keybindings Overview

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
| `Mod + Z` | Launch ncmpcpp | `Mod + Shift + R` | Restart i3 |
| `Mod + X` | Open powermenu | `Mod + Shift + C` | Reload i3 config file |
| `Mod + C` | Launch screenshot script | `Mod + B` | Move workspace to the other monitor |
| `Mod + I` | Lock screen | `Mod + N` | Set dual monitor mode |
| `Mod + G` | Enter gap mode | `Mod + M` | Set single-monitor mode |

### Color palette

|   Bg   |   Bg 2   |   Bg 3   |  Border  |   Fg   |  White   |  Gray   |  Black   |
|:------:|:--------:|:--------:|:--------:|:------:|:--------:|:-------:|:--------:|
| `#1b1b25` | `#282A36` | `#16161e` | `#343746` | `#dedede` | `#eeffff` | `#727480` | `#15121c` |
| ![#1b1b25](https://placehold.co/77x15/1b1b25/1b1b25.png) | ![#282A36](https://placehold.co/77x15/282A36/282A36.png) | ![#16161e](https://placehold.co/77x15/16161e/16161e.png) | ![#343746](https://placehold.co/77x15/343746/343746.png) | ![#dedede](https://placehold.co/77x15/dedede/dedede.png) | ![#eeffff](https://placehold.co/77x15/eeffff/eeffff.png) | ![#727480](https://placehold.co/77x15/727480/727480.png) | ![#15121c](https://placehold.co/77x15/15121c/15121c.png) |

| Red       | Green    | Yellow   | Blue     | Purple   | Cyan     | Pink     | Orange   |
|:------:|:--------:|:--------:|:--------:|:------:|:--------:|:-------:|:--------:|
| `#cb5760` | `#999f63`| `#d4a067`| `#6c90a8`| `#776690`| `#528a9b`| `#ffa8c5`| `#c87c3e`|
| ![#cb5760](https://placehold.co/77x15/cb5760/cb5760.png) | ![#999f63](https://placehold.co/77x15/999f63/999f63.png) | ![#d4a067](https://placehold.co/77x15/d4a067/d4a067.png) | ![#6c90a8](https://placehold.co/77x15/6c90a8/6c90a8.png) | ![#776690](https://placehold.co/77x15/776690/776690.png) | ![#528a9b](https://placehold.co/77x15/528a9b/528a9b.png) | ![#ffa8c5](https://placehold.co/77x15/ffa8c5/ffa8c5.png) | ![#c87c3e](https://placehold.co/77x15/c87c3e/c87c3e.png) |

## License
  
Distributed under the **[GPLv3+](https://www.gnu.org/licenses/gpl-3.0.html) License**.    
Copyright (C) 2025-2026 James Mugford.



# Upstream (Tracked)
* https://github.com/endeavouros-team/endeavouros-i3wm-setup/commits/main/
* https://github.com/Keyitdev/dotfiles/

# Chezmoi Cheat Sheet
chezmoi init
chezmoi add ~/.bashrc
chezmoi edit ~/.bashrc
chezmoi diff
chezmoi -v apply

# Todo

install catpuccin theme

## Todo Install
howdy
espanso



# Extra

## Talon
mkdir -p "$HOME/.local/opt/talon" &&
  tar -Jxf $HOME/Downloads/talon-linux-*.tar.xz --directory="$HOME/.local/opt"
git clone https://github.com/talonhub/community     $HOME/.talon/user/community
git clone https://github.com/jamesmugford/jm-talon  $HOME/.talon/user/jm-talon


*Stop screen tearing*: https://wiki.archlinux.org/title/NVIDIA/Troubleshooting#Avoid_screen_tearing



https://github.com/ChrisTitusTech/linutil
