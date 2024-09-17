#!/usr/bin/env bash

OS="$(uname -s)"

if [[ ${OS} != Linux ]]; then
    echo "Error: this script works only on Linux" >&2
    exit 1
fi

if [[ ! -d /home/linuxbrew/.linuxbrew ]] || [[ ! -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew install neovim tmux

if [[ -f ~/.bashrc ]]; then
    grep EDITOR ~/.bashrc || echo "export EDITOR=nvim" >> ~/.bashrc
    if ! grep TMUX_TMPDIR ~/.bashrc; then
        cat <<'BASH' >> ~/.bashrc
export TMUX_TMPDIR="${HOME}"
if [[ -z "${TMUX}" ]]; then
    exec tmux new-session -A -s main
fi
BASH
    fi
fi
