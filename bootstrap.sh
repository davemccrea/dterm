#!/bin/bash

HOST_HOME=$(echo "$HOME" | sed 's|/distrobox/dterm||')

# Set Fish as default shell
chsh -s $(which fish) $USER

# Copy SSH key pair from the base system
cp -r $HOST_HOME/.ssh $HOME

# Get dotfiles
sudo sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin
chezmoi init --apply git@github.com:davemccrea/dotfiles.git

# Configure git
git config --global user.name "David McCrea"
git config --global user.email "git@dmccrea.me" 

# Install plugins for neovim
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
# We want to use the .tool-versions in the container home dir not the host home directory
cd $HOME 
mix local.hex --force
mix archive.install hex phx_new --force

# Setup Livebook
mix do local.rebar --force, local.hex --force
mix escript.install hex livebook --force

