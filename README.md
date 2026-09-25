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

| Package    | Files                                     | Target               |
| ---------- | ----------------------------------------- | -------------------- |
| `wezterm`  | `.config/wezterm/wezterm.lua`             | `~/.config/wezterm/` |
| `bash`     | `.bashrc`, `.bash_profile`, `.blerc`, `.local/bin/tmux-preset` | `~/` |
| `git`      | `.gitconfig`                              | `~/`                 |
| `opencode` | `.config/opencode/**`                     | `~/.config/opencode/` |
| `tmux`     | `.config/tmux/tmux.conf`                  | `~/.config/tmux/`    |
| `workmux`  | `.config/workmux/config.yaml`             | `~/.config/workmux/` |
| `nvim`     | `.config/nvim/**`                         | `~/.config/nvim/`    |

## First-time install notes

- The target files must not already exist as real files, otherwise stow
  refuses to touch them. On an existing machine either remove them first
  or adopt them into the repo:
  ```bash
  stow --adopt nvim && git add -A && git commit   # pull live configs into the repo
  ```
- `.stowrc` may only contain stow options: stow parses it with Getopt and
  aborts on `#` lines, so all documentation lives in this file.
- tmux: TPM and every plugin listed in `tmux.conf` live in `~/.tmux/plugins/`
  (never in the stow package). `setup.sh` clones TPM if missing, `Prefix+I`
  installs/updates the plugins.
- workmux: `setup.sh` regenerates `~/.config/workmux/workmux-completion.bash`
  from `workmux completions bash` (the file itself is git-ignored).

## Mouseless

Everything is keyboard-driven.

- **wezterm** — `Alt+hjkl` pane navigation, `Alt+Shift+hjkl` splits,
  `Alt+m` maximize, tab bar hidden when a single tab.
- **bash** — vi-mode line editing (ble.sh), fzf everywhere, starship prompt.
- **tmux** — mouse on, vi-style copy mode, `C-a` prefix, `vim-tmux-navigator`
  so `C-h/j/k/l` cross vim/tmux panes. `~/.local/bin/tmux-preset` fills the
  `dev`/`ops` sessions at login; `t` attaches to `dev`.
- **nvim** — mouse off, LazyVim base.
- **workmux** — worktrees opened as tmux windows with nvim focused, no mouse.