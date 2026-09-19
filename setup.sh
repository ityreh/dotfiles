#!/usr/bin/env bash
#
# Symlink every package into $HOME with GNU stow.
#
#   ./setup.sh          # stow every package
#   ./setup.sh nvim     # stow a single package
#
# The repo layout mirrors real home paths inside each package dir:
#   nvim/.config/nvim/init.lua  ->  ~/.config/nvim/init.lua
#   bash/.bashrc                ->  ~/.bashrc
#
# Install stow first:  sudo pacman -S stow  (or brew install stow).
#
set -euo pipefail

PACKAGES=(wezterm bash starship tmux workmux nvim)

stow_static() {
	stow --verbose=2 --target="$HOME" "$@"
}

if (( $# == 0 )); then
	stow_static "${PACKAGES[@]}"
else
	stow_static "$@"
fi

# Install tmux plugin manager if tmux is available and TPM is missing.
if command -v tmux >/dev/null 2>&1 && [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
	printf 'Installing tmux plugin manager (TPM)…\n'
	git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
	printf 'Run Prefix+I inside tmux to install plugins.\n'
fi

printf 'Done. Configs symlinked into %s\n' "$HOME"