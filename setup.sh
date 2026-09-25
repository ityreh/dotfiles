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

PACKAGES=(wezterm bash git opencode tmux workmux nvim)

stow_dir="$(cd "$(dirname "$0")" && pwd)"

stow_static() {
	stow --verbose=2 --dir="$stow_dir" --target="$HOME" "$@"
}

link_workspace_agents() {
	local src="$stow_dir/code" dst="$HOME/code" file rel dir
	[[ -d "$src" && -d "$dst" ]] || return 0
	while IFS= read -r -d '' file; do
		rel="${file#"$src"/}"
		dir="$(dirname "$dst/$rel")"
		mkdir -p "$dir"
		ln -sfnT "$(realpath --relative-to="$dir" "$file")" "$dst/$rel"
	done < <(find "$src" -type f -name AGENTS.md -print0)
}

if (( $# == 0 )); then
	stow_static "${PACKAGES[@]}"
else
	stow_static "$@"
fi

link_workspace_agents

# Install tmux plugin manager if tmux is available and TPM is missing.
if command -v tmux >/dev/null 2>&1 && [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
	printf 'Installing tmux plugin manager (TPM)…\n'
	git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
	printf 'Run Prefix+I inside tmux to install plugins.\n'
fi

if command -v workmux >/dev/null 2>&1; then
	mkdir -p "$HOME/.config/workmux"
	workmux completions bash > "$HOME/.config/workmux/workmux-completion.bash"
fi

printf 'Done. Configs symlinked into %s\n' "$HOME"