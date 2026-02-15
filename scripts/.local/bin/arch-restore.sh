#!/usr/bin/env bash
set -euo pipefail

install_base_packages() {
  sudo pacman -Syu --noconfirm
  sudo pacman -S --needed --noconfirm \
    git neovim cliphist stow firefox yazi ffmpeg 7zip jq poppler fd \
    ripgrep fzf zoxide resvg imagemagick starship eza hypridle 
}

install_yay() {
  if command -v yay >/dev/null 2>&1; then
    return 0
  fi

  sudo pacman -S --needed --noconfirm base-devel git

  local tmp_dir
  tmp_dir="$(mktemp -d)"
  git clone https://aur.archlinux.org/yay.git "$tmp_dir/yay"
  (
    cd "$tmp_dir/yay"
    makepkg -si --noconfirm
  )
}

install_noctalia_shell() {
  yay -S --needed --noconfirm noctalia-shell
}

clone_dotfiles_repo() {
  if [ -d "$HOME/dotfiles" ]; then
    return 0
  fi

  git clone https://github.com/ydannielmamede/dotfiles.git "$HOME/dotfiles"
}

stow_dotfiles_packages() {
  local repo_dir="$HOME/dotfiles"
  local pkg
  [ -d "$repo_dir" ] || return 0

  shopt -s nullglob
  for dir in "$repo_dir"/*/; do
    pkg="$(basename "$dir")"
    stow --dir="$repo_dir" --target="$HOME" "$pkg"
  done
  shopt -u nullglob
}

install_base_packages
install_yay
install_noctalia_shell
clone_dotfiles_repo
stow_dotfiles_packages
