FROM quay.io/fedora/fedora-toolbox:rawhide

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="A cloud-native terminal experience" \
      maintainer="github@dmccrea.me"

ENV LC_ALL=en_GB.UTF-8 LANG=en_GB.UTF-8

RUN dnf install -y inotify-tools fish tmux fzf fd-find ripgrep bat perl-Image-ExifTool gh zoxide jq xsel neovim python3-neovim golang lsd
RUN dnf --repo=rawhide install -y elixir elixir-doc erlang erlang-doc
RUN dnf copr enable atim/lazygit -y && dnf install -y lazygit
RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/bin

COPY bootstrap.sh /usr/bin
RUN echo "/bin/bash /usr/bin/bootstrap.sh" >> /etc/profile
