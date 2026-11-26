# SELinux Hardening Guide

**Scope:** RHEL 9 and RHEL 10  
**Status:** Recommended implementation guidance; not yet validated in a live environment.

## Policy

Keep SELinux enabled and in enforcing mode unless a formally approved exception exists. Disabling SELinux is not an appropriate first response to an application access problem.

## 1. Inspect current state

```bash
getenforce
sestatus
grep -E '^(SELINUX|SELINUXTYPE)=' /etc/selinux/config
sudo semanage boolean -l
```

The runtime mode and configured mode can differ. Record both.

## 2. Investigate denials

```bash
sudo ausearch -m AVC,USER_AVC -ts recent
sudo journalctl -t setroubleshoot --since "1 hour ago"
sudo restorecon -nRv /path/to/application
```

Use the actual application path and an appropriate time window. Review the full denial context before taking action.

## 3. Correct common causes

- Restore expected file labels with `restorecon` after confirming the intended policy.
- Use supported SELinux file-context rules for non-standard application paths.
- Change SELinux booleans only when the application requirement is understood and approved.
- Prefer a supported policy module or vendor guidance over broad allow rules.
- Avoid generating and installing policy modules directly from unexplained AVC output.

## 4. Change control

Back up relevant configuration, document the current mode and labels, test in a non-production environment, and define rollback before changing policy. Validate application behavior and review new AVC events after the change.

## 5. Rollback and exceptions

Revert the specific configuration, boolean, or file-context change using the recorded prior values. Any permissive-mode exception should be time-bound, approved, monitored, and tracked to closure.

## References

- RHEL documentation: https://docs.redhat.com/
- SELinux project: https://github.com/SELinuxProject
