#!/bin/bash

# Set fish as default shell
chsh -s $(which fish) $USER

# Copy SSH key pair from the base system
cp -r /var/home/$USER/.ssh $HOME/

# Fetch dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
$HOME/.local/bin/chezmoi init --apply git@github.com:davemccrea/dotfiles.git

# Move asdf
sudo mv /var/tmp/.asdf $HOME/.asdf
sudo chown -R $USER $HOME/.asdf