#!/bin/bash

# Set fish as default shell
chsh -s $(which fish) $USER

# Copy SSH key pair from the base system
cp -r /var/home/$USER/.ssh /var/home/$USER/distrobox/boxkit/

# Fetch dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
$HOME/.local/bin/chezmoi init git@github.com:davemccrea/dotfiles.git
$HOME/.local/bin/chezmoi update

# Move asdf
mv /var/tmp/.asdf $HOME/.asdf
