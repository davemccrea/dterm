FROM registry.fedoraproject.org/fedora-toolbox:39

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="A cloud-native terminal experience" \
      maintainer="github@dmccrea.me"

RUN dnf upgrade -y
RUN dnf install -y systemd inotify-tools curl git neovim fish tmux fzf fd-find ripgrep bat perl-Image-ExifTool go gh zoxide

# Install Erlang build dependencies
ARG KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac --without-wx --without-odbc"
RUN dnf -y groupinstall -y 'Development Tools' 'C Development Tools and Libraries'
RUN dnf install -y autoconf ncurses-devel openssl-devel xsltproc fop

# Install asdf
ENV PATH="$PATH:/opt/asdf/bin"
ENV PATH="$PATH:/opt/asdf/shims"
RUN \
      git clone https://github.com/asdf-vm/asdf.git /opt/asdf && \
      export ASDF_DATA_DIR=/opt/asdf && \
      asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git && \
      asdf install elixir latest && \
      asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git && \
      asdf install erlang latest && \
      asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git && \
      asdf install nodejs latest

# Install Elixir tools
WORKDIR /tmp
RUN \
      export ASDF_DATA_DIR=/opt/asdf && \
      asdf local elixir latest && \
      asdf local erlang latest && \
      mix local.hex --force && \
      mix archive.install hex phx_new --force && \
      mix do local.rebar --force, local.hex --force && \
      mix escript.install hex livebook --force 

COPY bootstrap.sh /usr/bin
RUN echo "/bin/bash /usr/bin/bootstrap.sh" >> /etc/profile

RUN \
      ln -fs /usr/bin/distrobox-host-exec /usr/bin/code && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \ 
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree
