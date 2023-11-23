#!/bin/bash

# Set fish as default shell
chsh -s $(which fish) $USER

# Copy SSH key pair from the base system
cp -r /var/home/$USER/.ssh $HOME/

# Fetch dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
$HOME/.local/bin/chezmoi init --apply git@github.com:davemccrea/dotfiles.git

git config --global user.name "David McCrea"
git config --global user.email "git@dmccrea.me" 

# Setup asdf
sudo mv /var/tmp/.asdf $HOME/.asdf
sudo chown -R $USER $HOME/.asdf
$HOME/.asdf/bin/asdf reshim elixir
$HOME/.asdf/bin/asdf reshim erlang
$HOME/.asdf/bin/asdf reshim nodejs
$HOME/.asdf/bin/asdf global elixir latest
$HOME/.asdf/bin/asdf global erlang latest
$HOME/.asdf/bin/asdf global nodejs lts

# Setup Phoenix
mix local.hex --force
mix archive.install hex phx_new --force
