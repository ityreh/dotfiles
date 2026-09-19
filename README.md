# Mouseless dotfiles

A GNU stow dotfiles repo synced between machines. Layout follows
[omerxx/dotfiles](https://github.com/omerxx/dotfiles): one directory per
tool, mirroring real home paths inside it.

## Install

```bash
sudo pacman -S stow            # or: brew install stow
./setup.sh                     # stow every package into ~
./setup.sh nvim                # stow a single package
```

## Layout

| Package   | Files                                     | Target               |
| --------- | ----------------------------------------- | -------------------- |
| `wezterm` | `.config/wezterm/wezterm.lua`             | `~/.config/wezterm/` |
| `bash`    | `.bashrc`, `.bash_profile`                | `~/`                 |
| `starship`| `.config/starship.toml`                   | `~/.config/`         |
| `tmux`    | `.config/tmux/tmux.conf`                  | `~/.config/tmux/`    |
| `workmux` | `.config/workmux/config.yaml`             | `~/.config/workmux/` |
| `nvim`    | `.config/nvim/**`                         | `~/.config/nvim/`    |

## First-time install notes

- The target files must not already exist as real files, otherwise stow
  refuses to touch them. On an existing machine either remove them first
  or adopt them into the repo:
  ```bash
  stow --adopt nvim && git add -A && git commit   # pull live configs into the repo
  ```
- tmux: `Prefix+I` installs the plugins listed in `tmux.conf`.
- workmux: copy/generate the bash completions (run `workmux completion bash`
  or use the installed copy) to `~/.config/workmux/workmux-completion.bash`.

## Mouseless

Everything is keyboard-driven.

- **wezterm** — `Alt+hjkl` pane navigation, `Alt+Shift+hjkl` splits,
  `Alt+m` maximize, tab bar hidden when a single tab.
- **bash** — vi-mode line editing (ble.sh), fzf everywhere, starship prompt.
- **tmux** — mouse off, vi-style copy mode, `C-a` prefix, `vim-tmux-navigator`
  so `C-hjkl` cross vim/tmux panes.
- **nvim** — mouse off, kickstart.nvim base with LSP, treesitter, telescope.
- **workmux** — worktrees opened as tmux windows with nvim focused, no mouse.