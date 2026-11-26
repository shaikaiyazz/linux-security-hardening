#!/usr/bin/env bash
# Read-only SELinux posture snapshot for RHEL-family systems.
set -uo pipefail

info() { printf '[INFO] %s\n' "$*"; }
warn() { printf '[WARN] %s\n' "$*"; }

if ! command -v getenforce >/dev/null 2>&1; then
  warn "getenforce not found; SELinux utilities may not be installed."
  exit 0
fi

mode="$(getenforce 2>/dev/null || true)"
case "$mode" in
  Enforcing) info "SELinux runtime mode: Enforcing" ;;
  Permissive) warn "SELinux runtime mode: Permissive" ;;
  Disabled) warn "SELinux runtime mode: Disabled" ;;
  *) warn "Could not determine SELinux runtime mode." ;;
esac

if command -v sestatus >/dev/null 2>&1; then
  info "SELinux status details:"
  sestatus
fi

if command -v semanage >/dev/null 2>&1; then
  info "Non-default SELinux boolean review is available with: semanage boolean -l"
else
  info "semanage not installed; skipping boolean inventory."
fi

info "Recent AVC review command: sudo ausearch -m AVC,USER_AVC -ts recent"
info "This script is read-only and does not change SELinux settings."
