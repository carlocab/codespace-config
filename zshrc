# Start tmux
export TMUX_TMPDIR="$HOME"
export EDITOR=nvim
if [[ -z "${TMUX}" ]] && (( $+commands[tmux] )) && tmux -V &>/dev/null; then
  exec tmux new-session -A -s main
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Flag -U guarantees entries are unique
typeset -U PATH path

export ZSH="${HOME}/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

COMPLETION_WAITING_DOTS="true"

export ZSH_CUSTOM="${HOME}/.config/zsh/custom"

plugins=(
    brew
    gitfast
    git
    command-not-found
    pip
    fzf
    F-Sy-H
    history-substring-search
)

source ${ZSH}/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.config/zsh/p10k.zsh ]] || source ~/.config/zsh/p10k.zsh
