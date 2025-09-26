#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
list_dir="${repo_root}/pkglists"

sudo pacman -Syu --needed $(< "${list_dir}/pacman-explicit.txt")

if command -v paru >/dev/null 2>&1; then
  paru -S --needed $(< "${list_dir}/pacman-aur.txt")
elif command -v yay >/dev/null 2>&1; then
  yay -S --needed $(< "${list_dir}/pacman-aur.txt")
fi

if command -v flatpak >/dev/null 2>&1; then
  xargs -r -a "${list_dir}/flatpak-apps.txt" flatpak install -y
fi
