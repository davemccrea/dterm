#!/bin/bash

# Set fish as default shell
chsh -s $(which fish) $USER

HOST_HOME=$(echo "$HOME" | sed 's|/distrobox/dterm||')

# Copy SSH key pair from the base system
cp -r $HOST_HOME/.ssh $HOME

# Ensure we are in the container home directory
cd $HOME

# Fetch dotfiles
sudo sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin
chezmoi init --apply git@github.com:davemccrea/dotfiles.git

# Set git global config
git config --global user.name "David McCrea"
git config --global user.email "git@dmccrea.me" 

# Install LazyVim plugins
nvim --headless "+Lazy! sync" +qa

# Setup asdf
sudo mv /root/.asdf $HOME
sudo chown -R $USER $HOME/.asdf
. "$HOME/.asdf/asdf.sh"
asdf global elixir latest
asdf global erlang latest
asdf global nodejs latest
asdf reshim elixir
asdf reshim erlang
asdf reshim nodejs

# Setup Phoenix
mix local.hex --force
mix archive.install hex phx_new --force