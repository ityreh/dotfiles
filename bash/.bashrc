#
# ~/.bashrc — hand-rolled, replaces CachyOS zsh config + oh-my-zsh.
# Prompt: Starship. Shell: bash 5.3.
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# History
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Ignore commands that start with spaces and duplicates.
export HISTCONTROL=ignoreboth

# Don't add certain commands to the history file.
export HISTIGNORE="&:[bf]g:c:clear:history:exit:q:pwd:* --help"

# Append to history instead of overwriting; share across shells.
shopt -s histappend
export PROMPT_COMMAND="history -a; ${PROMPT_COMMAND:-}"

export HISTSIZE=50000
export HISTFILESIZE=50000

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# `less` colors for `man` pages
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export LESS_TERMCAP_md="$(tput bold 2>/dev/null; tput setaf 2 2>/dev/null)"
export LESS_TERMCAP_me="$(tput sgr0 2>/dev/null)"
export FZF_BASE=/usr/share/fzf

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Aliases (carried over from CachyOS zsh config)
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

alias grep='grep --color=auto'
alias make='make -j"$(nproc)"'
alias ninja='ninja -j"$(nproc)"'
alias n='ninja'
alias c='clear'
alias rmpkg='sudo pacman -Rsn'
alias cleanch='sudo pacman -Scc'
alias fixpacman='sudo rm /var/lib/pacman/db.lck'
alias update='sudo pacman -Syu'
alias apt='man pacman'
alias apt-get='man pacman'
alias please='sudo'
alias tb='nc termbin.com 9999'
alias cleanup='sudo pacman -Rsn $(pacman -Qtdq)'
alias jctl='journalctl -p 3 -xb'
alias rip='expac --timefmt="%Y-%m-%d %T" "%l\t%n %v" | sort | tail -200 | nl'

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# PATH
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$PATH:$HOME/go/bin"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Editors / tools
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

alias v='nvim'
alias vim='nvim'
alias t='tmux'
alias g='lazygit'
alias oc='opencode'
alias wm='workmux'

# Truecolor for TUI apps (opencode, starship, etc.)
export COLORTERM=truecolor
export EDITOR=nvim
export VISUAL=nvim

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Color schemes: `ls`/`eza`, `bat`, `vivid`, `man`
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# LS_COLORS from a vivid theme (fall back to the dircolors default grid).
# Swap the theme to taste:  vivid themes  →  dracula, nord, tokyonight, ...
if command -v vivid >/dev/null 2>&1; then
  export LS_COLORS="$(vivid generate catppuccin)"
else
  eval "$(dircolors -b)"
fi

# `ls` → eza (icons, git status, better palette). Same flags still work:
#   ls -lart  →  long format, all, reverse, mtime
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --color=auto --group-directories-first --icons=auto'
  alias ll='eza -al --color=auto --group-directories-first --icons=auto'
  alias la='eza -la --color=auto --icons=auto'
  alias l='eza --color=auto --icons=auto'
  alias tree='eza --tree --level=2 --color=auto --icons=auto'
else
  alias ls='ls --color=auto'
fi

# `cat` → bat (syntax highlighting for files)
if command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never'
  # man pages rendered through bat
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# workmux shell completions
[ -f ~/.config/workmux/workmux-completion.bash ] && source ~/.config/workmux/workmux-completion.bash

# dotfiles alias for the bare git repo at ~/.dotfiles
alias dotfiles='git --git-dir="$HOME/.dotfiles" --work-tree="$HOME"'

# pkgfile "command not found" handler
if [ -r /usr/share/doc/pkgfile/command-not-found.bash ]; then
  source /usr/share/doc/pkgfile/command-not-found.bash
fi

# fzf keybindings + completion
[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Angular CLI autocompletion is zsh-only (`compdef`); skipped under bash.

# ble.sh — Bash Line Editor (syntax highlighting, autosuggestions, vi-mode)
[[ $- == *i* ]] && [[ -f ~/.local/share/ble-0.4.0-devel3/ble.sh ]] && source ~/.local/share/ble-0.4.0-devel3/ble.sh --noattach

# Starship prompt (ble.sh picks up PS1 automatically)
eval "$(starship init bash)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export JAVA_HOME="$HOME/.sdkman/candidates/java/current"

# ble.sh attach (must be last line)
[[ ${_ble_version+set} ]] && ble-attach