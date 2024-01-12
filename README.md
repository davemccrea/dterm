# dterm

## Description

A stable and predictible terminal experience. David's Terminal = dterm.

When I start using a new package or tool I add it to the `Containerfile` and push the repo to Github. A Github Action then builds the custom image and pushes it to the registry. The bootstrap script runs after Distrobox/Toolbox has created the container and performs tasks such as installing and invoking [chezmoi](https://www.chezmoi.io/) to grab my [dotfiles](https://github.com/davemccrea/dotfiles).

This repo is based on [boxkit](https://github.com/ublue-os/boxkit), a set of GitHub actions and skeleton files to build toolbox and distrobox images.

## Setup

### Step 1

With [Distrobox](https://github.com/89luca89/distrobox) installed run:

```
distrobox create --image ghcr.io/davemccrea/dterm:latest --name dterm --home ~/distrobox/dterm
```

### Step 2

```
distrobox enter dterm
``` 

The bootstrap script will run on first load to change the default shell, load dotfiles, etc. 

## Update

```
distrobox stop dterm; \
distrobox rm dterm; \
podman pull ghcr.io/davemccrea/dterm
```

## Additional setup

### In container

- tmux
  - Open tmux and invoke `prefix + I` to install plugins

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). [Generate a new keypair](https://docs.sigstore.dev/cosign/overview/) with cosign. The public key is kept in the public repo. Paste the private key in Settings -> Secrets -> Actions.
