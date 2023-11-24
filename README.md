# dterm

## Description

A stable and predictible terminal experience. David's Terminal = dterm.

When I start using a new package or tool I add it to the `Containerfile` and push the repo to Github. A Github Action then builds the custom image and pushes it to the registry. I run the `update` script on each device. 

The bootstrap script runs after Distrobox/Toolbox has created the container and performs tasks such as installing and invoking [chezmoi](https://www.chezmoi.io/) to grab my [dotfiles](https://github.com/davemccrea/dotfiles).

This repo is based on [boxkit](https://github.com/ublue-os/boxkit), a set of GitHub actions and skeleton files to build toolbox and distrobox images.

## Setup

Clone this repo on a machine running Distrobox or Toolbox:

```
cd dterm
./update
```

## Additional setup

### On host

- [Ingegrate VSCode and Distrobox](https://github.com/89luca89/distrobox/blob/main/docs/posts/integrate_vscode_distrobox.md#integrate-vscode-and-distrobox)
- Add custom keyboard shortcut to Gnome
  - `gnome-terminal --profile dterm --full-screen`
- Add custom command to Gnome Terminal profile
  - `distrobox enter dterm`

### In container

- tmux
  - Open tmux and invoke `prefix + I` to install plugins

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). [Generate a new keypair](https://docs.sigstore.dev/cosign/overview/) with cosign. The public key is kept in the public repo. Paste the private key in Settings -> Secrets -> Actions.
