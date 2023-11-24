#!/bin/bash

# Set fish as default shell
chsh -s $(which fish) $USER

# Copy SSH key pair from the base system
cp -r /var/home/$USER/.ssh ~/

# Fetch dotfiles
sudo sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin
chezmoi init --apply git@github.com:davemccrea/dotfiles.git

git config --global user.name "David McCrea"
git config --global user.email "git@dmccrea.me" 

# Setup asdf
sudo mv /var/tmp/.asdf ~/.asdf
sudo chown -R $USER ~/.asdf
. "$HOME/.asdf/asdf.sh"
asdf reshim elixir
asdf reshim erlang
asdf global elixir latest
asdf global erlang latest

# Setup Phoenix
mix local.hex --force
mix archive.install hex phx_new --force

nvim --headless "+Lazy! sync" +qa
