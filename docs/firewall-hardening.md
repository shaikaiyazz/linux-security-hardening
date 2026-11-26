# Firewall Hardening Guide

**Scope:** RHEL 9 and RHEL 10 using firewalld  
**Status:** Recommended implementation guidance; not yet validated in a live environment.

## Objectives

- Apply a default-deny approach where practical.
- Permit only required inbound services.
- Preserve management and application connectivity.
- Keep firewall changes documented and reversible.

## 1. Read-only discovery

```bash
sudo systemctl status firewalld --no-pager
sudo firewall-cmd --state
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --list-all-zones
sudo firewall-cmd --get-services
sudo ss -lntup
```

Compare listening services with approved application and infrastructure requirements. A listening port is not automatically a service that should be exposed.

## 2. Design rules before applying them

For every permitted service or port, document:

- Business/application owner.
- Source network(s) allowed to connect.
- Destination host and interface/zone.
- Protocol and port.
- Reason for access.
- Review or expiry date.

Prefer source-restricted rules over broad exposure. Use named firewalld services when they accurately represent the required service.

## 3. Change control

1. Export or record the current active-zone configuration.
2. Confirm console/out-of-band access and an approved maintenance window.
3. Confirm the management path and required ports with the system owner.
4. Apply the smallest required change.
5. Inspect runtime and permanent configurations.
6. Validate application and administration connectivity from an independent session.
7. Record the change and rollback instructions.

Do not flush rules, change the default zone, or remove services/ports without understanding dependencies. A firewall change can disconnect remote administration.

## 4. Useful review commands

```bash
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --zone=public --list-all
sudo firewall-cmd --permanent --zone=public --list-all
sudo firewall-cmd --check-config
```

Replace `public` with the actual zone in use.

## 5. Rollback

Restore the previously recorded configuration using the approved change procedure. If remote access is lost, use console/out-of-band access. Verify both runtime and permanent state after recovery.

## References

- RHEL documentation: https://docs.redhat.com/
- firewalld documentation: https://firewalld.org/documentation/
