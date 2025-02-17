FROM quay.io/toolbx-images/alpine-toolbox:edge

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="A cloud-native terminal experience" \
      maintainer="github@dmccrea.me"

RUN apk add inotify-tools lazygit fish tmux fzf fd ripgrep bat exiftool ffmpeg github-cli zoxide jq eza xsel clipboard neovim elixir chezmoi

COPY bootstrap.sh /usr/bin

RUN echo "/bin/bash /usr/bin/bootstrap.sh" >> /etc/profile
