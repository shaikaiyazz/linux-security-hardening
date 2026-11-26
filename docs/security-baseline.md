# Linux Security Baseline Checklist

Use this checklist during a read-only assessment of a RHEL 10 system. Record the host, date, command output, finding, risk, and follow-up action.

## 1. System and patch state

- [ ] Record hostname, OS release, kernel, and uptime.
- [ ] Check whether security updates are available.
- [ ] Confirm the system uses approved repositories.
- [ ] Record the last successful patch window.

Useful commands:

```bash
hostnamectl
cat /etc/redhat-release
uname -r
dnf check-update
```

## 2. Accounts and authentication

- [ ] Review accounts with UID 0; normally only root should have UID 0.
- [ ] Review privileged users and wheel-group membership.
- [ ] Check for accounts with unexpected interactive shells.
- [ ] Confirm password and account policies align with organizational requirements.
- [ ] Protect `/etc/passwd`, `/etc/group`, `/etc/shadow`, and `/etc/gshadow`.

Useful commands:

```bash
awk -F: '$3 == 0 {print $1 " (UID 0)"}' /etc/passwd
getent group wheel
stat -c '%a %U:%G %n' /etc/passwd /etc/group /etc/shadow /etc/gshadow
```

## 3. SSH

- [ ] Review effective SSH daemon configuration.
- [ ] Check root login policy.
- [ ] Check password authentication policy.
- [ ] Prefer key-based authentication where operationally appropriate.
- [ ] Restrict access through approved users/groups and network controls.

Useful command:

```bash
sshd -T | grep -E '^(permitrootlogin|passwordauthentication|pubkeyauthentication)'
```

Do not change SSH settings remotely without a tested second session and console access. A mistake can lock out administrators.

## 4. Firewall

- [ ] Confirm firewalld state.
- [ ] Review active zones and interfaces.
- [ ] Review allowed services and ports.
- [ ] Confirm required management access is permitted before any rule change.

Useful commands:

```bash
systemctl is-active firewalld
firewall-cmd --get-active-zones
firewall-cmd --list-all
```

## 5. SELinux

- [ ] Confirm SELinux is Enforcing unless an approved exception exists.
- [ ] Review recent AVC denials.
- [ ] Investigate labels and policy issues rather than disabling SELinux.

Useful commands:

```bash
getenforce
sestatus
ausearch -m AVC -ts recent
```

## 6. Logging and auditing

- [ ] Confirm auditd status where required.
- [ ] Confirm system logs are retained and monitored.
- [ ] Review time synchronization.
- [ ] Ensure log storage and forwarding meet operational requirements.

Useful commands:

```bash
systemctl is-active auditd
systemctl is-active chronyd
journalctl -p warning -b
```

## Assessment record

For each check, capture:

| Field | Record |
|---|---|
| Hostname | |
| Assessment date | |
| OS / kernel | |
| Check performed | |
| Evidence | |
| Finding / risk | |
| Recommended action | |
| Validation / rollback | |

This checklist is a learning baseline, not a certification or compliance claim. Tailor it to the system role, business requirements, and applicable security policy.