#!/bin/bash

set -oue pipefail

flag_file="$HOME/.bootstrap_run_once_flag"

if [ ! -e "$flag_file" ]; then
    # Set Fish as default shell
    chsh -s $(which fish) $USER

    # Copy SSH key pair from the host home dir to the container home dir
    cp -r /home/$USER/.ssh $HOME

    # Get dotfiles
    sudo sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin
    chezmoi init --apply git@github.com:davemccrea/dotfiles.git

    # Configure git
    git config --global pull.rebase true
    git config --global user.name "David McCrea"
    git config --global user.email "git@dmccrea.me" 

    sudo mv /opt/asdf ~/.asdf
    sudo chown -R $USER:$USER ~/.asdf

    cd $HOME
    ~/.asdf/bin/asdf reshim
    ~/.asdf/bin/asdf global elixir 1.16.2-otp-26
    ~/.asdf/bin/asdf global erlang 26.2.5
    ~/.asdf/bin/asdf global nodejs 20.11.0
    ~/.asdf/bin/asdf global gleam latest

    # Install plugins for neovim
    nvim --headless "+Lazy! sync" +qa

    if [ -e "/var/home/david/.gh_token" ]; then
        gh auth login --with-token < /var/home/david/.gh_token
    fi

    # Install rustup
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

    echo "Bootstrap successful."
    touch "$flag_file"
fi
