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

virt-customize -a "$QCOW2" \
  --run-command 'apk update' \
  --run-command 'apk upgrade' \
  --install cloud-init,python3,py3-yaml,py3-requests,e2fsprogs-extra,util-linux,shadow,sudo,qemu-guest-agent,openssh-server,dhcpcd \
  --copy-in "${CONFIG_DIR}/cloud.cfg:/etc/cloud/" \
  --copy-in "${CONFIG_DIR}/grub:/etc/default/" \
  --copy-in "${CONFIG_DIR}/serial-config.sh:/usr/local/sbin/" \
  --run-command 'chmod +x /usr/local/sbin/serial-config.sh && /usr/local/sbin/serial-config.sh' \
  --run-command 'grub-mkconfig -o /boot/grub/grub.cfg' \
  --run-command 'setup-cloud-init' \
  --run-command 'rc-update add qemu-guest-agent default' \
  --run-command 'rc-update add sshd default' \
  --run-command 'rc-update add dhcpcd boot'

echo "[customize] done"
