#!/usr/bin/env bash
# Read-only firewalld posture snapshot for RHEL-family systems.
set -uo pipefail

info() { printf '[INFO] %s\n' "$*"; }
warn() { printf '[WARN] %s\n' "$*"; }

if ! command -v firewall-cmd >/dev/null 2>&1; then
  warn "firewall-cmd not found; firewalld may not be installed."
  exit 0
fi

state="$(firewall-cmd --state 2>/dev/null || true)"
if [[ "$state" == "running" ]]; then
  info "firewalld state: running"
else
  warn "firewalld state: ${state:-unknown}"
fi

info "Active zones:"
firewall-cmd --get-active-zones 2>&1 || warn "Unable to query active zones."

info "Default zone:"
firewall-cmd --get-default-zone 2>&1 || warn "Unable to query default zone."

info "Runtime configuration:"
firewall-cmd --list-all-zones 2>&1 || warn "Unable to list runtime zones."

info "Permanent configuration is not modified or reloaded by this script."
info "Compare allowed services with approved network requirements."
