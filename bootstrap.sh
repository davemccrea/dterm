#!/bin/bash

# Set fish as default shell
chsh -s $(which fish) $USER

HOST_HOME=$(echo "$HOME" | sed 's|/distrobox/dterm||')

# Copy SSH key pair from the base system
cp -r $HOST_HOME/.ssh ~/

# Ensure we are in the container home directory
cd ~/

# Fetch dotfiles
sudo sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin
chezmoi init --apply git@github.com:davemccrea/dotfiles.git

git config --global user.name "David McCrea"
git config --global user.email "git@dmccrea.me" 

# Install LazyVim plugins
nvim --headless "+Lazy! sync" +qa

# Setup asdf
sudo mv /var/tmp/.asdf ~/.asdf
sudo chown -R $USER ~/.asdf
. "$HOME/.asdf/asdf.sh"
asdf reshim elixir
asdf reshim erlang
asdf global elixir latest
asdf global erlang latest

# TODO: move to Containerfile
# Due to how the nodejs asdf plugin is implemented
# the install script errors when run in Containerfile
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs 20.10.0
asdf global nodejs 20.10.0

# TODO: move to Containerfile
# Setup Phoenix
mix local.hex --force
mix archive.install hex phx_new --force

