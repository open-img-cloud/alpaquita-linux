#!/usr/bin/env bash
# Prints the latest Alpaquita stream version on stdout (single line).
#
# Alpaquita Stream is a rolling release: Bell-Sw only exposes a stable
# URL pointing at the most recent build (`alpaquita-stream-latest-...`),
# with no version-bearing redirect. We synthesise a date-based version
# from the `Last-Modified` HTTP header of the upstream qcow2.xz.
#
# Bell-Sw rebuilds glibc and musl images independently, often on
# different days. We take the MAX of the two Last-Modified dates so a
# rebuild of either flavor bumps VERSION (consumers of either flavor
# get a fresh release). Format: YYYY.MM.DD. Git tag: `v<VERSION>`.
#
# This script runs in the upstream-watch reusable workflow (no KVM
# needed) — keep it portable bash + curl + GNU date only.

set -euo pipefail

URLS=(
  'https://packages.bell-sw.com/alpaquita/glibc/stream/releases/x86_64/alpaquita-stream-latest-glibc-x86_64.qcow2.xz'
  'https://packages.bell-sw.com/alpaquita/musl/stream/releases/x86_64/alpaquita-stream-latest-musl-x86_64.qcow2.xz'
)

max_epoch=0
for url in "${URLS[@]}"; do
  last_mod=$(curl -fsSI "$url" \
    | awk -F': ' 'tolower($1)=="last-modified"{sub(/\r$/,"",$2); print $2; exit}')

  if [[ -z "${last_mod:-}" ]]; then
    echo "::error::could not read Last-Modified header from $url" >&2
    exit 1
  fi

  epoch=$(date -u -d "$last_mod" +%s)
  if (( epoch > max_epoch )); then
    max_epoch=$epoch
  fi
done

date -u -d "@${max_epoch}" +'%Y.%m.%d'
