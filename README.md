# boxkit

## Description

Based on [boxkit](https://github.com/ublue-os/boxkit), a set of GitHub actions and skeleton files to build toolbox and distrobox images.

## How to use

### Create box

    distrobox create -i ghcr.io/$GITHUB_USERNAME/boxkit:latest -n boxkit --home ~/distrobox/boxkit
    distrobox enter boxkit -- 'sh bootstrap'

### Pull down config

Dotfiles are automatically synced with [chezmoi](https://www.chezmoi.io/) when the container is built.

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/ublue-os/boxkit
    
If you're forking this repo you should [read the docs](https://docs.github.com/en/actions/security-guides/encrypted-secrets) on keeping secrets in github. You need to [generate a new keypair](https://docs.sigstore.dev/cosign/overview/) with cosign. The public key can be in your public repo (your users need it to check the signatures), and you can paste the private key in Settings -> Secrets -> Actions.
