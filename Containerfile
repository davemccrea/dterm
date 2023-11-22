FROM  registry.fedoraproject.org/fedora-toolbox:39

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="A cloud-native terminal experience" \
      maintainer="github@dmccrea.me"

COPY  extra-packages /

RUN   dnf upgrade -y && \
      dnf install -y dnf-plugins-core && \
      dnf config-manager --add-repo https://rtx.pub/rpm/rtx.repo && \
      dnf install -y rtx && \
      grep -v '^#' /extra-packages | xargs dnf install -y

RUN   rm /extra-packages

RUN   sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin

RUN   ln -fs /bin/sh /usr/bin/sh && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \ 
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/transactional-update
 