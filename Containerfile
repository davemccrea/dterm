FROM registry.fedoraproject.org/fedora-toolbox:39

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="A cloud-native terminal experience" \
      maintainer="github@dmccrea.me"

RUN dnf upgrade -y

RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc
RUN sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

RUN dnf copr enable varlad/helix -y
RUN dnf copr enable atim/lazygit -y

RUN dnf check-update
RUN dnf install -y systemd inotify-tools curl git lazygit neovim fish tmux fzf fd-find ripgrep bat perl-Image-ExifTool gh zoxide php composer code helix rust cargo erlang-26.2.2-1.fc39 jq

# Install asdf
RUN \
      git clone https://github.com/asdf-vm/asdf.git /opt/asdf && \
      export PATH="/opt/asdf/bin:/opt/asdf/shims:$PATH" && \
      export ASDF_DATA_DIR=/opt/asdf && \
      asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git && \
      asdf install elixir 1.16.1-otp-26 && \
      asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git && \
      asdf install nodejs 20.11.0 && \
      asdf plugin-add gleam https://github.com/asdf-community/asdf-gleam.git && \
      asdf install gleam latest

# Install asdf tooling
WORKDIR /tmp
RUN \
      export ASDF_DATA_DIR=/opt/asdf && \
      export PATH="/opt/asdf/bin:/opt/asdf/shims:$PATH" && \
      asdf local elixir 1.16.1-otp-26 && \
      asdf local nodejs 20.11.0 && \
      mix local.hex --force && \
      mix archive.install hex phx_new --force && \
      mix do local.rebar --force, local.hex --force && \
      mix escript.install hex livebook --force && \
      npm install -g @tailwindcss/language-server && \
      npm install -g vscode-langservers-extracted

COPY bootstrap.sh /usr/bin
RUN echo "/bin/bash /usr/bin/bootstrap.sh" >> /etc/profile

# Install go
WORKDIR /tmp
RUN \
	wget https://go.dev/dl/go1.22.0.linux-amd64.tar.gz && \
	rm -rf /usr/local/go && tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz && \
	rm go*.tar.gz

# Install go dev packages
RUN \
	export PATH="/usr/local/go:/usr/local/go/bin:$PATH" && \
	go install github.com/a-h/templ/cmd/templ@latest && \
	go install -tags 'postgres sqlite3' github.com/golang-migrate/migrate/v4/cmd/migrate@latest

RUN \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \ 
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree
