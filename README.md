# James Mugford's Dotfiles

Dotfiles managed with chezmoi.

## Quick start

Base system handled by Omarchy.
Install core packages.

```sh
sudo pacman -S --needed chezmoi
```

Apply the dotfiles.

```sh
git clone https://github.com/jamesmugford/jm-dotfiles.git .local/share/chezmoi
chezmoi apply
```

## Omarchy stuff

Set pacman parallel downloads to 1 to prevent timeout of Omarchy's Stable package mirror 
sudo perl -0pi -e 's/^ParallelDownloads = 5$/ParallelDownloads = 1/m' /etc/pacman.conf

### GVFS FUSE after suspend

Omarchy unmounts `gvfsd-fuse` before suspend to avoid FUSE hangs. On this system it does not always come back after resume, which breaks apps that need normal paths under `/run/user/1000/gvfs` even though Nautilus, LibreOffice, and other GVFS-aware apps can still access `smb://` locations.

This repo manages `~/.config/systemd/user/gvfsd-fuse.service` with `Restart=always` so systemd brings it back after Omarchy's suspend hook unmounts it. `~/.config/hypr/hypridle.conf` also restarts it after wake as a backup nudge.

Manual recovery:

```sh
systemctl --user restart gvfsd-fuse.service
```

Fallback if the service is not installed yet:

```sh
/usr/lib/gvfsd-fuse "$XDG_RUNTIME_DIR/gvfs" &
```

Verify:

```sh
pgrep -af gvfsd-fuse
findmnt /run/user/1000/gvfs
```

## Optional packages

### Apps

```sh
yay -S --needed github-desktop-bin jetbrains-toolbox synology-drive sublime-text-4
```

### 3D

```sh
sudo pacman -S blender 
yay -S --needed spacenavd spnavcfg 
```
<https://aur.archlinux.org/packages/unreal-engine-bin>

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

### JM Face Gestures

```sh
git clone <https://github.com/jamesmugford/jm-face-gestures.git> ~/Projects
sudo firewall-cmd --permanent --add-port=11111/udp
sudo firewall-cmd --reload
```

### Notes

## Upstream (Tracked)

* <N/A>

## Chezmoi Cheat Sheet

```sh
chezmoi init
chezmoi add ~/.bashrc
chezmoi edit ~/.bashrc
chezmoi diff
chezmoi -v apply
```

### Tmux Restore

Configured with `tmux-resurrect` and `tmux-continuum`.

* Save manually: `C-Space Ctrl-s`
* Restore manually: `C-Space Ctrl-r`
* Auto-save interval: 15 minutes
* Auto-restore runs when the tmux server starts
