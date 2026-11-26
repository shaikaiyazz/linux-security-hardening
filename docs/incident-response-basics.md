# Linux Security Incident Response Basics

**Purpose:** A practical first-response checklist for Linux administrators. Follow the organization's incident response policy and escalation process.

## 1. Recognize and report

Potential indicators include unexpected privileged accounts, suspicious SSH logins, unexplained services or listening ports, unexpected scheduled tasks, repeated authentication failures, unexplained SELinux denials, and unusual resource or network activity.

Record the time, affected host, observed behavior, and detection source. Escalate promptly to the security or incident response team.

## 2. Preserve evidence

- Avoid rebooting or making unnecessary changes before coordinating with responders.
- Preserve relevant logs and monitoring alerts.
- Record commands run and actions taken.
- Maintain timestamps and chain-of-custody requirements where applicable.
- Do not copy sensitive data to personal devices or public repositories.

## 3. Initial triage

Only perform actions authorized by the incident response lead. Useful initial context may include:

```bash
date -Is
hostnamectl
uptime
who
last -a | head
ss -tulpn
systemctl --failed
journalctl --since "30 minutes ago" --no-pager
```

These commands provide context; they do not establish whether a host is compromised.

## 4. Containment and recovery

Containment may involve network isolation, disabling compromised credentials, blocking malicious indicators, or taking a system out of service. These actions can affect business operations and should follow the incident response authority and approved process.

Rebuild or restore from trusted sources when directed. Rotate affected credentials and keys, close the root cause, and validate monitoring before returning a system to service.

## 5. Lessons learned

Document timeline, impact, root cause, controls that failed, recovery actions, and improvements. Share only sanitized information in this public portfolio.
