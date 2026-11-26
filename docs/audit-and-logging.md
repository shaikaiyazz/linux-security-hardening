# Auditing, Logging and Time Synchronization

**Scope:** RHEL 9 and RHEL 10  
**Status:** Recommended implementation guidance; not yet validated in a live environment.

## Objectives

- Maintain useful security and operational event records.
- Synchronize system time.
- Protect logs from unauthorized access and accidental loss.
- Define retention and forwarding requirements.

## 1. Inspect current services

```bash
sudo systemctl status auditd --no-pager
sudo systemctl status systemd-journald --no-pager
sudo systemctl status chronyd --no-pager
sudo auditctl -s
sudo journalctl --disk-usage
timedatectl
```

A service being active does not by itself prove that its configuration meets organizational requirements.

## 2. auditd

Review loaded audit rules and persistent rule files:

```bash
sudo auditctl -l
sudo ls -l /etc/audit/rules.d/
sudo augenrules --check
```

Design rules around system identity, privilege use, authentication, critical configuration changes, and applicable regulatory or business requirements. Avoid copying large rule sets without understanding performance and event volume.

## 3. journald and log retention

Review journal storage configuration and available capacity. Define retention, maximum disk use, access controls, and whether logs must persist across reboot. Ensure log rotation and storage settings align with the organization's retention policy.

## 4. Time synchronization

Use the organization's approved time sources. Verify synchronization with:

```bash
chronyc tracking
chronyc sources -v
timedatectl
```

Accurate time is important for correlating events across systems.

## 5. Centralized logging and monitoring

Where available, forward relevant logs to an approved central platform or SIEM. Protect transport, access, retention, and alerting configuration. Monitor for audit service failure, repeated authentication failures, privilege changes, unexpected service changes, and storage exhaustion.

## 6. Evidence

Record service state, active audit rules, time synchronization status, retention settings, and log-forwarding health. Redact hostnames, usernames, IP addresses, and sensitive event details before publishing evidence.
