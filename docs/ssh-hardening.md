# SSH Hardening Guide

**Scope:** RHEL 9 and RHEL 10  
**Status:** Recommended implementation guidance; not yet validated in a live environment.

## Objectives

- Reduce exposure of the SSH service.
- Prefer individual named accounts and key-based authentication.
- Keep administrative access recoverable during changes.
- Record and review effective SSH settings.

## 1. Review the current configuration

Run these read-only checks before changing anything:

```bash
sudo sshd -t
sudo sshd -T | sort
sudo systemctl status sshd --no-pager
sudo ss -lntp | grep sshd
```

Review both `/etc/ssh/sshd_config` and any files included from `/etc/ssh/sshd_config.d/`. On RHEL, drop-in configuration files may affect the effective settings.

## 2. Recommended policy

Evaluate the following settings against the environment's access requirements:

| Setting | Recommended direction | Notes |
|---|---|---|
| `PermitRootLogin` | `no` | Use named accounts with controlled privilege escalation. |
| `PubkeyAuthentication` | `yes` | Prefer managed SSH keys. |
| `PasswordAuthentication` | Consider `no` | Only after key-based access has been confirmed for every required administrator. |
| `X11Forwarding` | `no` unless required | Disable unused forwarding features. |
| `AllowTcpForwarding` | Restrict where practical | Some applications and admin workflows require it. |
| `MaxAuthTries` | Set a reasonable low value | Validate automation and operational requirements. |

Do not copy these values blindly. Configuration precedence, identity management, automation, and support requirements vary.

## 3. Safe change sequence

1. Confirm console or out-of-band access.
2. Keep the current administrator session open.
3. Back up the configuration: `sudo cp -a /etc/ssh/sshd_config /etc/ssh/sshd_config.pre-hardening`.
4. Apply a reviewed configuration using the site's change process.
5. Validate syntax with `sudo sshd -t`.
6. Review effective settings with `sudo sshd -T`.
7. Reload SSH only after validation: `sudo systemctl reload sshd`.
8. Open a second terminal and verify a new login before closing the original session.

**Lockout warning:** Do not disable password authentication until public-key login has been tested with a separate session and recovery access is available.

## 4. Review and evidence

Capture the effective settings, service status, listening sockets, change record, and successful access verification. Remove usernames, hostnames, addresses, and key material before publishing evidence.

## 5. Rollback

If access or service behavior is affected, use console/out-of-band access to restore the backed-up configuration, run `sshd -t`, and reload the service. Follow the site's approved rollback procedure.

## References

- RHEL documentation: https://docs.redhat.com/
- OpenSSH manual pages: `man sshd_config`, `man sshd`
