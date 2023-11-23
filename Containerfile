FROM  registry.fedoraproject.org/fedora-toolbox:39

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="A cloud-native terminal experience" \
      maintainer="github@dmccrea.me"

COPY  extra-packages /

RUN   dnf upgrade -y && \
      dnf copr enable -y atim/starship && \
      dnf install -y starship && \
      grep -v '^#' /extra-packages | xargs dnf install -y

RUN   ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \ 
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree

RUN   git config --global user.name "David McCrea"
RUN   git config --global user.email "git@dmccrea.me" 

# erlang dependencies
RUN   dnf -y groupinstall -y 'Development Tools' 'C Development Tools and Libraries' && \
      dnf install -y autoconf ncurses-devel wxGTK-devel wxBase openssl-devel java-1.8.0-openjdk-devel libiodbc unixODBC-devel.x86_64 erlang-odbc.x86_64 libxslt fop

ARG   ASDF_DIR="var/tmp/.asdf"
ARG   ASDF_DATA_DIR="/var/tmp/.asdf"

# asdf is moved from /var/temp/.asdf to ~/.asdf by the bootstrap script
RUN   git clone https://github.com/asdf-vm/asdf.git /var/tmp/.asdf && \
      /var/tmp/.asdf/bin/asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git && \
      /var/tmp/.asdf/bin/asdf install elixir latest && \
      /var/tmp/.asdf/bin/asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git && \
      /var/tmp/.asdf/bin/asdf install erlang latest

COPY  bootstrap.sh /

RUN   rm /extra-packages