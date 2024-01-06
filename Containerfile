FROM registry.fedoraproject.org/fedora-toolbox:39

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="A cloud-native terminal experience" \
      maintainer="github@dmccrea.me"

COPY bootstrap.sh /

COPY extra-packages /

RUN dnf upgrade -y && grep -v '^#' /extra-packages | xargs dnf install -y

# VSCode
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc
RUN sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
RUN dnf check-update
RUN dnf install code -y

RUN ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \ 
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree

RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf

ENV PATH="${PATH}:/root/.asdf/bin"

RUN asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git && asdf install nodejs latest

RUN asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git && asdf install elixir latest

# Erlang build dependencies
ARG KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac --without-wx --without-odbc"
RUN dnf -y groupinstall -y 'Development Tools' 'C Development Tools and Libraries'
RUN dnf install -y autoconf ncurses-devel openssl-devel xsltproc fop
RUN asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git && asdf install erlang latest

RUN rm /extra-packages
