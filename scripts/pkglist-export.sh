#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
out_dir="${repo_root}/pkglists"

mkdir -p "${out_dir}"

pacman -Qqne > "${out_dir}/pacman-explicit.txt"
pacman -Qqme > "${out_dir}/pacman-aur.txt"

if command -v flatpak >/dev/null 2>&1; then
  flatpak list --app --columns=application > "${out_dir}/flatpak-apps.txt"
else
  : # Flatpak not installed; skip export
fi
