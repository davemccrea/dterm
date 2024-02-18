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
    asdf reshim

    cd $HOME
    export PATH="~/.asdf/bin:$PATH"
    asdf global elixir latest
    asdf global erlang latest
    asdf global nodejs 20.11.0

    # Install plugins for neovim
    nvim --headless "+Lazy! sync" +qa

    if [ -e "/var/home/david/.gh_token" ]; then
        gh auth login --with-token < /var/home/david/.gh_token
    fi

    echo "Bootstrap successful."
    touch "$flag_file"
fi
