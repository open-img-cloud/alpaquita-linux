#!/usr/bin/env bash
# Prints the latest Alpaquita stream version on stdout (single line).
#
# Alpaquita Stream is a rolling release: Bell-Sw only exposes a stable
# URL pointing at the most recent build (`alpaquita-stream-latest-...`).
# We synthesise a date-based version from the upstream qcow2's
# `Last-Modified` HTTP header. Format: YYYY.MM.DD. The corresponding
# git tag is `v<VERSION>`.
#
# This script runs in the upstream-watch reusable workflow (no KVM
# needed) — keep it portable bash + curl + GNU date only.

set -euo pipefail

URL='https://packages.bell-sw.com/alpaquita/glibc/stream/releases/x86_64/alpaquita-stream-latest-glibc-x86_64.qcow2.xz'

last_mod=$(curl -fsSI "$URL" \
  | awk -F': ' 'tolower($1)=="last-modified"{sub(/\r$/,"",$2); print $2; exit}')

if [[ -z "${last_mod:-}" ]]; then
  echo "::error::could not read Last-Modified header from $URL" >&2
  exit 1
fi

# RFC 7231: "Sat, 11 Apr 2026 07:50:31 GMT"
date -u -d "$last_mod" +'%Y.%m.%d'
