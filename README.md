<p align="center">
  <a href="https://openimages.cloud/images/alpaquita-linux/">
    <img src="https://openimages.cloud/img/og/alpaquita-linux.png" alt="Alpaquita Linux cloud image for OpenStack and Proxmox" width="720">
  </a>
</p>

<p align="center">
  <a href="https://openimages.cloud/images/alpaquita-linux/"><img alt="Latest version (glibc)" src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fimages.openimages.cloud%2Falpaquita-linux%2Flatest%2FMANIFEST-glibc.json&query=%24.version&label=latest%20glibc&color=2459c4&cacheSeconds=3600"></a>
  <a href="https://openimages.cloud/images/alpaquita-linux/"><img alt="Latest version (musl)" src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fimages.openimages.cloud%2Falpaquita-linux%2Flatest%2FMANIFEST-musl.json&query=%24.version&label=latest%20musl&color=2459c4&cacheSeconds=3600"></a>
  <a href="https://github.com/open-img-cloud/alpaquita-linux/actions/workflows/release.yml"><img alt="Release" src="https://github.com/open-img-cloud/alpaquita-linux/actions/workflows/release.yml/badge.svg"></a>
  <a href="https://openimages.cloud/verify/"><img alt="Signed with Sigstore cosign" src="https://img.shields.io/badge/signed-Sigstore%20cosign-2459c4"></a>
  <a href="https://openimages.cloud/quality/"><img alt="Boot-tested on OpenStack" src="https://img.shields.io/badge/boot--tested-OpenStack-2459c4"></a>
  <a href="LICENSE"><img alt="License GPL-2.0" src="https://img.shields.io/badge/license-GPL--2.0-555"></a>
</p>

<p align="center">
  <a href="https://openimages.cloud/images/alpaquita-linux/"><b>Catalog page</b></a> ·
  <a href="https://images.openimages.cloud/alpaquita-linux/latest/">Download</a> ·
  <a href="https://openimages.cloud/verify/">Verify</a> ·
  <a href="https://github.com/open-img-cloud/docs">Documentation</a> ·
  <a href="https://github.com/open-img-cloud/alpaquita-linux/issues">Report an issue</a>
</p>

Alpaquita Linux cloud image (qcow2) for **OpenStack** and **Proxmox**: the BellSoft Alpaquita
Stream image, verified, made ready for both clouds with the same rules as every
[openimages.cloud](https://openimages.cloud) image, signed with Sigstore cosign and boot-tested
on a real OpenStack before it is published. Two C library variants are built from each release.

## At a glance

| | |
|---|---|
| **Upstream** | [Alpaquita Linux](https://bell-sw.com/alpaquita-linux/) Stream `alpaquita-stream-latest-<libc>-x86_64.qcow2.xz` from BellSoft, checked against the `.sha256` published next to it |
| **Default user** | `alpaquita`, SSH key only, passwordless `sudo` |
| **Variants** | `glibc`: GNU C library, widest binary compatibility. `musl`: musl libc, smallest footprint |
| **Firmware** | BIOS |
| **Format** | qcow2, x86_64, root filesystem grown to the disk at first boot |
| **Version** | the upstream publication date, `YYYY.MM.DD`, e.g. `2026.11.11`; one manifest per variant, `MANIFEST-glibc.json` and `MANIFEST-musl.json` ([all versions](https://images.openimages.cloud/alpaquita-linux/versions.json)) |
| **Support** | follows the Alpaquita Stream releases: each new upstream image becomes a new image |

## Quick start

```sh
# Pick the variant: glibc or musl
VARIANT=glibc
# Latest version and its file name, from the signed manifest of that variant
M=https://images.openimages.cloud/alpaquita-linux/latest/MANIFEST-$VARIANT.json
V=$(curl -fsS $M | jq -r .version); F=$(curl -fsS $M | jq -r .filename)
curl -fLO https://images.openimages.cloud/alpaquita-linux/$V/$F
```

<details>
<summary><b>OpenStack</b></summary>

```sh
openstack image create --disk-format qcow2 --container-format bare \
  --property os_distro=alpaquita \
  --property hw_qemu_guest_agent=yes --property os_admin_user=alpaquita \
  --file "$F" "Alpaquita Linux $V ($VARIANT)"
```

The full property set (SCSI disk, multiqueue, quiesced snapshots) is on the
[catalog page](https://openimages.cloud/images/alpaquita-linux/) and in
[`index.json`](https://images.openimages.cloud/index.json). To keep images up to date
automatically, use [oic-sync](https://github.com/open-img-cloud/oic-sync).

</details>

<details>
<summary><b>Proxmox VE</b></summary>

The commands to create a cloud-init template from this image are on the
[catalog page](https://openimages.cloud/images/alpaquita-linux/).

</details>

<details>
<summary><b>Verify the signature</b></summary>

```sh
curl -fLO https://images.openimages.cloud/alpaquita-linux/$V/$F.bundle
cosign verify-blob "$F" --bundle "$F.bundle" \
  --certificate-identity-regexp '^https://github.com/open-img-cloud/\.github/\.github/workflows/build-(libguestfs|dib|nix-flake|freebsd)-image\.yml@' \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com
```

</details>

## What this image changes

The upstream image is a plain system, so this one does more than most:

- upgrades all packages at build time, then installs cloud-init (with its Python
  dependencies), `qemu-guest-agent`, OpenSSH, dhcpcd, `sudo` and the tools cloud-init needs to
  grow the disk, and enables them at boot;
- sends the kernel and GRUB to the serial console (`ttyS0`) as well as the screen, and enables
  a login there;
- IPv6: accepts router advertisements on every interface and sets dhcpcd to `slaac hwaddr`
  instead of `slaac private`, so the instance keeps the MAC-derived link-local address Neutron
  expects and gets the IPv6 address of its port;
- adds an SSH drop-in that turns off password and keyboard-interactive authentication;
- unlocks the default user for SSH at every boot: cloud-init locks its password with `!`, and
  without PAM (musl) OpenSSH then refuses even key logins. The password is replaced with `*`,
  which still allows no password login;
- adds the openimages.cloud cloud-init policy: config drive read first, then the metadata
  service; no root login, no SSH password;
- cleans package caches and machine identity so every instance starts fresh.

Every release must pass the same [runtime contract](https://openimages.cloud/quality/) on
OpenStack: SSH with the injected key, cloud-init finished, DNS, hostname, root filesystem grown,
passwordless `sudo`, IPv6 address and egress.

## How releases happen

1. Every day at 06:17 UTC a watcher looks for a new upstream image and opens a pull request
   that bumps [`VERSION`](VERSION).
2. Merging it is all it takes: the release is tagged, both variants are built, signed,
   boot-tested and published, then `latest/` and the [catalog](https://openimages.cloud/images/)
   move to it.

This repository only holds what is specific to Alpaquita Linux: [`VERSION`](VERSION),
[`build/customize.sh`](build/customize.sh), [`build/config/`](build/config),
[`build/detect-upstream.sh`](build/detect-upstream.sh) and thin workflows calling the shared
pipeline in [`open-img-cloud/.github`](https://github.com/open-img-cloud/.github).

## License

The build tooling in this repository is under [GPL-2.0](LICENSE). The image keeps the licensing
terms of Alpaquita Linux (each package under its own license). Alpaquita is a trademark of its
owner; this project is not affiliated with BellSoft.
