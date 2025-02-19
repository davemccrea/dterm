#!/usr/bin/env bash

flag_file="$HOME/.dterm_bootstrap_finished"

# Exit on any error
set -e
# Exit on pipe failure (e.g., when using |)
set -o pipefail

# Colors and formatting
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Logging functions
log_header() {
    echo -e "\n${BOLD}${BLUE}=== $1 ===${NC}\n"
}

log_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

log_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

error_handler() {
    local line_number=$1
    local error_code=$2
    echo -e "\n${RED}❌ Error occurred in script at line ${line_number}, exit code: ${error_code}${NC}"
    exit $error_code
}

# Set up error trap
trap 'error_handler ${LINENO} $?' ERR

if [ ! -e "$flag_file" ]; then
    log_header "Starting bootstrap script"

    log_info "Copying SSH keys..."
    cp -r "/var/home/$USER/.ssh" "$HOME"
    log_success "SSH keys copied"

    log_info "Configuring git..."
    git config --global pull.rebase true
    git config --global user.name "David McCrea"
    git config --global user.email "git@dmccrea.me"
    git config --global init.defaultBranch main
    log_success "Git configured"

    log_info "Installing dotfiles..."
    chezmoi init --apply "git@github.com:davemccrea/dotfiles.git"
    log_success "Dotfiles installed"

    log_info "Installing neovim plugins..."
    /usr/bin/nvim --headless "+Lazy! sync" +qa
    log_success "Neovim plugins installed"

    if [ -e "/var/home/david/.gh_token" ]; then
        log_info "Configuring GitHub CLI..."
        gh auth login --with-token < "/var/home/david/.gh_token"
        log_success "GitHub CLI configured"
    fi

    log_info "Installing Hex..."
    mix do local.rebar --force, local.hex --force
    log_success "Hex installed"

    log_info "Installing Phoenix..."
    mix archive.install hex phx_new --force
    log_success "Phoenix installed"

    log_info "Installing Livebook..."
    mix escript.install hex livebook --force
    log_success "Livebook installed"

    touch "$flag_file"
    log_header "Bootstrap complete! 🎉"
fi
