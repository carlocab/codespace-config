#!/usr/bin/env bash

OS="$(uname -s)"

if [[ ${OS} != Linux ]]; then
    echo "Error: this script works only on Linux" >&2
    exit 1
fi

if [[ ! -d /home/linuxbrew/.linuxbrew ]] || [[ ! -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    bash -c "$(curl --fail --silent --show-error --location https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if ! command -v brew &>/dev/null && [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if [[ -r Brewfile ]] && ! brew bundle check; then
    brew bundle install
fi

if [[ -f ~/.bashrc ]]; then
    if ! grep TMUX_TMPDIR ~/.bashrc; then
        cat <<'BASH' >> ~/.bashrc

[[ -x /home/linuxbrew/.linuxbrew/bin/zsh ]] && exec /home/linuxbrew/.linuxbrew/bin/zsh -l
command -v zsh &>/dev/null && exec zsh -l

export EDITOR=nvim
export TMUX_TMPDIR="${HOME}"
if [[ -z "${TMUX}" ]] && command -v tmux &>/dev/null; then
    exec tmux new-session -A -s main
fi
BASH
    fi
fi

curl --fail --silent --show-error --location --output omz-install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh

bash omz-install.sh --skip-chsh --unattended --keep-zshrc

export ZSH_CUSTOM="${HOME}/.config/zsh/custom"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}/themes/powerlevel10k"
git clone https://github.com/z-shell/F-Sy-H.git "${ZSH_CUSTOM}/plugins/F-Sy-H"
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

install -b -m 644 zshenv "${HOME}/.zshenv"
install -b -m 644 zshrc "${HOME}/.config/zsh/.zshrc"
install -b -m 644 p10k.zsh "${HOME}/.config/zsh/p10k.zsh"
install -b -m 644 tmux.conf "${HOME}/.config/tmux/tmux.conf"
install -b -m 644 Brewfile "${HOME}/Brewfile"
install -b -m 644 environment.zsh "${ZSH_CUSTOM}/environment.zsh"

~/.config/tmux/plugins/tpm/bin/install_plugins
"${ZSH_CUSTOM}/themes/powerlevel10k/gitstatus/install"
