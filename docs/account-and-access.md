# Account and Access Management

**Scope:** RHEL 9 and RHEL 10  
**Status:** Recommended implementation guidance; not yet validated in a live environment.

## Objectives

- Use named accounts instead of shared administrator accounts.
- Apply least privilege.
- Protect credential and account databases.
- Review access regularly and remove stale access through an approved process.

## 1. Read-only checks

```bash
getent passwd
getent group wheel
sudo passwd -S -a
sudo stat -c '%a %U:%G %n' /etc/passwd /etc/shadow /etc/group /etc/gshadow
sudo visudo -c
```

Review local and centrally managed identities. Do not publish account names or password-aging output that could expose internal policy.

## 2. Administrative access

- Grant administrative privileges only to approved users.
- Use the `wheel` group or narrowly scoped sudoers rules according to organizational policy.
- Edit sudoers files with `visudo` and validate with `visudo -c`.
- Avoid broad `NOPASSWD: ALL` rules.
- Prefer command-specific delegation when feasible.
- Review membership and sudo permissions periodically.

## 3. Account lifecycle

For joiners, movers, and leavers, maintain an approval trail for account creation, privilege changes, lock/disable actions, and removal. Coordinate local accounts with LDAP/AD/IdM or other identity providers where applicable.

## 4. File permissions

Verify that `/etc/shadow` and `/etc/gshadow` are protected by the distribution's expected ownership and permissions. Avoid recursively changing permissions across system directories without a specific diagnosis.

## 5. Secrets handling

Never commit passwords, password hashes, private keys, API tokens, Ansible Vault passwords, or unredacted configuration containing secrets. Use an approved secret manager or encrypted vault workflow, and keep local secret files out of Git.

## 6. Evidence and review

Record access approval, group membership, sudo policy review, account lifecycle actions, and exceptions. Redact personal and system-identifying data before adding evidence to this public repository.
