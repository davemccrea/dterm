#!/bin/bash

# Tidy up old container
distrobox stop boxkit -Y
rm -rf ~/distrobox
distrobox rm boxkit --force

# Fetch new container
distrobox create -i ghcr.io/davemccrea/boxkit:latest -n boxkit --home ~/distrobox/boxkit
distrobox enter boxkit -- './bootstrap.sh'
