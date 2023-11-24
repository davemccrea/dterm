FROM  registry.fedoraproject.org/fedora-toolbox:39

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="A cloud-native terminal experience" \
      maintainer="github@dmccrea.me"

COPY  bootstrap.sh /

COPY  extra-packages /

RUN   dnf upgrade -y && grep -v '^#' /extra-packages | xargs dnf install -y

RUN   ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \ 
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree

# erlang dependencies
ARG   KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac --without-wx --without-odbc"
RUN   dnf -y groupinstall -y 'Development Tools' 'C Development Tools and Libraries'
RUN   dnf install -y autoconf ncurses-devel openssl-devel xsltproc fop

ARG   ASDF_DIR="/var/tmp/.asdf"
ARG   ASDF_DATA_DIR="/var/tmp/.asdf"
ARG   ASDF_PATH="/var/tmp/.asdf/bin/asdf"
RUN   git clone https://github.com/asdf-vm/asdf.git /var/tmp/.asdf
RUN   $ASDF_PATH plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git && \
      $ASDF_PATH install elixir latest && \
      $ASDF_PATH plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git && \
      $ASDF_PATH install erlang latest

RUN   rm /extra-packages
