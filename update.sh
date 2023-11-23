#!/bin/bash

echo
echo "## Stopping old container ##"
echo

distrobox stop boxkit --yes


echo
echo "## Cleaning up ##"
echo

sudo rm -rf $HOME/distrobox/boxkit && echo
distrobox rm boxkit --force

echo
echo "## Getting latest image ##"
echo

podman pull ghcr.io/davemccrea/boxkit:latest

echo
echo "## Starting up new container ##"
echo

distrobox create --yes --image ghcr.io/davemccrea/boxkit:latest --name boxkit --home ~/distrobox/boxkit
distrobox enter boxkit -- 'sh /bootstrap.sh'
