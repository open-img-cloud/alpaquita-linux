#!/usr/bin/env bash
# Customize hook called by the build-libguestfs-image reusable workflow.
# Receives the qcow2 path as $1. Runs inside the stackopshq builder
# container with /dev/kvm exposed.
#
# Same set of operations as the legacy inline workflow had, but moved
# to a script so the reusable workflow stays generic.

set -euo pipefail

QCOW2="${1:?usage: customize.sh <path-to-qcow2>}"
CONFIG_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/config"

if [[ ! -f "$QCOW2" ]]; then
  echo "::error::qcow2 not found: $QCOW2" >&2
  exit 1
fi

echo "[customize] target: $QCOW2"
echo "[customize] config: $CONFIG_DIR"

# NOTE: virt-customize's `--install` relies on libguestfs's OS inspection to
# pick the right package manager. Alpaquita is an Alpine fork but isn't
# recognized; libguestfs returns "no package manager detected". Use explicit
# `--run-command 'apk add ...'` instead (matches the legacy workflow).
# Org-wide cloud-init policy (datasource_list, disable_root, ssh_pwauth,
# mount_default_fields) is now injected by the reusable workflow via
# `templates/cloud.cfg.d/99_oic-policy.cfg` AFTER this script runs. Cloud-init
# merges the drop-in with whatever cloud.cfg the upstream alpaquita-cloud-init
# package ships, so we no longer maintain a full-replacement cloud.cfg here.
virt-customize -a "$QCOW2" \
  --run-command 'apk update' \
  --run-command 'apk upgrade' \
  --run-command 'apk add cloud-init python3 py3-yaml py3-requests e2fsprogs-extra util-linux shadow sudo qemu-guest-agent openssh-server dhcpcd' \
  --copy-in "${CONFIG_DIR}/grub:/etc/default/" \
  --mkdir /usr/local/sbin \
  --copy-in "${CONFIG_DIR}/serial-config.sh:/usr/local/sbin/" \
  --run-command 'chmod +x /usr/local/sbin/serial-config.sh && /usr/local/sbin/serial-config.sh' \
  --run-command 'grub-mkconfig -o /boot/grub/grub.cfg' \
  --run-command 'setup-cloud-init' \
  --run-command 'rc-update add qemu-guest-agent default' \
  --run-command 'rc-update add sshd default' \
  --run-command 'rc-update add dhcpcd boot' \
  --run-command 'rm -rf /var/cache/apk/* /tmp/* /var/tmp/*'

echo "[customize] done"
