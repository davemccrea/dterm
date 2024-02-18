FROM registry.fedoraproject.org/fedora-toolbox:39

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="A cloud-native terminal experience" \
      maintainer="github@dmccrea.me"

RUN dnf upgrade -y

RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc
RUN sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
RUN dnf check-update
RUN dnf install -y systemd inotify-tools curl git neovim fish tmux fzf fd-find ripgrep bat perl-Image-ExifTool go gh zoxide php composer code

# Install Erlang build dependencies
ARG KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac --without-wx --without-odbc"
RUN dnf -y groupinstall -y 'Development Tools' 'C Development Tools and Libraries'
RUN dnf install -y autoconf ncurses-devel openssl-devel xsltproc fop

# Install asdf
RUN \
      git clone https://github.com/asdf-vm/asdf.git /opt/asdf && \
      export PATH="/opt/asdf/bin:/opt/asdf/shims:$PATH" && \
      export ASDF_DATA_DIR=/opt/asdf && \
      asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git && \
      asdf install elixir latest && \
      asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git && \
      asdf install erlang latest && \
      asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git && \
      asdf install nodejs 20.11.0

# Install Elixir tools
WORKDIR /tmp
RUN \
      export ASDF_DATA_DIR=/opt/asdf && \
      export PATH="/opt/asdf/bin:/opt/asdf/shims:$PATH" && \
      asdf local elixir latest && \
      asdf local erlang latest && \
      mix local.hex --force && \
      mix archive.install hex phx_new --force && \
      mix do local.rebar --force, local.hex --force && \
      mix escript.install hex livebook --force 

COPY bootstrap.sh /usr/bin
RUN echo "/bin/bash /usr/bin/bootstrap.sh" >> /etc/profile

RUN \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \ 
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree
