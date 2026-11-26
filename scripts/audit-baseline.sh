#!/usr/bin/env bash
#
# Read-only Linux security baseline checks for RHEL-family systems.
# This script reports configuration; it does not apply remediation.
#
set -u

section() {
    printf '\n===== %s =====\n' "$1"
}

run_check() {
    local title="$1"
    shift
    printf '\n--- %s ---\n' "$title"
    "$@" 2>&1 || printf '[INFO] Command returned a non-zero status. Review whether this is expected.\n'
}

section "System"
run_check "Hostname" hostnamectl
run_check "OS release" cat /etc/redhat-release
run_check "Kernel" uname -r
run_check "Uptime" uptime

section "Accounts and critical file permissions"
if [[ -r /etc/passwd ]]; then
    awk -F: '$3 == 0 {print $1 " (UID 0)"}' /etc/passwd
else
    echo "[INFO] Cannot read /etc/passwd"
fi
run_check "wheel group" getent group wheel
if command -v stat >/dev/null 2>&1; then
    stat -c '%a %U:%G %n' /etc/passwd /etc/group /etc/shadow /etc/gshadow 2>&1
fi

section "SSH effective settings"
if command -v sshd >/dev/null 2>&1; then
    sshd -T 2>/dev/null | grep -E '^(permitrootlogin|passwordauthentication|pubkeyauthentication|x11forwarding)' || true
else
    echo "[INFO] sshd command not found"
fi

section "Firewall"
if command -v systemctl >/dev/null 2>&1; then
    systemctl is-active firewalld 2>&1 || true
fi
if command -v firewall-cmd >/dev/null 2>&1; then
    firewall-cmd --get-active-zones 2>&1 || true
    firewall-cmd --list-all 2>&1 || true
else
    echo "[INFO] firewall-cmd not found"
fi

section "SELinux"
if command -v getenforce >/dev/null 2>&1; then
    getenforce
    sestatus 2>&1 || true
else
    echo "[INFO] SELinux tools not found"
fi

section "Logging and time services"
if command -v systemctl >/dev/null 2>&1; then
    systemctl is-active auditd 2>&1 || true
    systemctl is-active chronyd 2>&1 || true
fi

section "Package update availability"
if command -v dnf >/dev/null 2>&1; then
    dnf -q check-update
    rc=$?
    case "$rc" in
        0) echo "[INFO] No package updates reported by dnf." ;;
        100) echo "[INFO] Updates are available; review the package list above." ;;
        *) echo "[INFO] dnf check-update returned status $rc; check repository/network configuration." ;;
    esac
else
    echo "[INFO] dnf not found"
fi

section "Assessment complete"
echo "Read-only checks finished. Review findings before making any changes."
