#!/usr/bin/env bash

OS="$(uname -s)"

if [[ ${OS} != Linux ]]; then
    echo "Error: this script works only on Linux" >&2
    exit 1
fi

if [[ ! -d /home/linuxbrew/.linuxbrew ]] || [[ ! -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    bash -c "$(curl --fail --silent --show-error --location https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -r Brewfile ]] && ! brew bundle check; then
    brew bundle install
fi

if [[ -f ~/.bashrc ]]; then
    grep EDITOR ~/.bashrc || echo "export EDITOR=nvim" >> ~/.bashrc
    if ! grep TMUX_TMPDIR ~/.bashrc; then
        cat <<'BASH' >> ~/.bashrc
command -v zsh &>/dev/null && exec zsh
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

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

install -b -m 644 .zshrc "${HOME}/.zshrc"
install -b -m 644 .p10k.zsh "${HOME}/.p10k.zsh"
install -b -m 644 tmux.conf "${HOME}/.config/tmux/tmux.conf"

~/.config/tmux/plugins/tpm/bin/install_plugins
