#!/bin/bash

flag_file="$HOME/.dterm_bootstrap_finished"

set -oue pipefail

if [ ! -e "$flag_file" ]; then
    # Copy SSH key pair from the host home dir to the container home dir
    cp -r /var/home/$USER/.ssh $HOME

    # Configure git
    git config --global pull.rebase true
    git config --global user.name "David McCrea"
    git config --global user.email "git@dmccrea.me" 
    git config --global init.defaultBranch main

    # Get dotfiles
    sudo sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin
    chezmoi init --apply git@github.com:davemccrea/dotfiles.git

    # Install atuin
    # Note: the SQLite database is configured in the config file to be saved outside the distrobox container
    curl --proto '=https' --tlsv1.2 -LsSf https://github.com/atuinsh/atuin/releases/latest/download/atuin-installer.sh | sh

    # Install rustup
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

    # Setup asdf
    sudo mv /opt/asdf ~/.asdf
    sudo chown -R $USER:$USER ~/.asdf
    export PATH="$PATH:~/.asdf/bin:~/.asdf/shims"
    cd $HOME
    asdf reshim
    asdf global elixir 1.17.1-otp-26
    asdf global erlang 26.2.5
    asdf global nodejs 20.11.0
    asdf global gleam 1.2.1

    # Install neovim plugins
    /opt/nvim-linux64/bin/nvim --headless "+Lazy! sync" +qa

    npm i -g @bitwarden/cli nvm eslint prettier

    if [ -e "/var/home/david/.gh_token" ]; then
        gh auth login --with-token < /var/home/david/.gh_token
    fi

    echo "Bootstrap successful."
    touch "$flag_file"
fi
