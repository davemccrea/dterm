FROM quay.io/toolbx-images/alpine-toolbox:edge

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="A cloud-native terminal experience" \
      maintainer="github@dmccrea.me"

RUN apk add inotify-tools gcc clang make fzf fd ripgrep bat zoxide jq eza xsel clipboard \
	atuin chezmoi lazygit fish tmux exiftool ffmpeg github-cli neovim starship \
	elixir npm go rustup zig

COPY bootstrap.sh /usr/bin

RUN echo "/bin/bash /usr/bin/bootstrap.sh" >> /etc/profile
