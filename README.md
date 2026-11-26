# Linux Security Hardening

Practical Linux security hardening using **RHEL 10**, **Bash**, and **Ansible**.

This repository documents a hands-on learning project: assess a Linux system, understand its security posture, and introduce hardening changes in a controlled, reversible way.

> **Project status:** Initial starter content. Scripts and playbooks must be reviewed and tested in the author's isolated RHEL 10 lab before being described as validated.

## Goals

- Build a repeatable Linux security baseline.
- Inspect SSH, firewalld, SELinux, account files, and package updates.
- Learn to distinguish security assessment from remediation.
- Automate read-only checks with Ansible.
- Document evidence, findings, and remediation decisions.

## Lab environment

The planned lab uses three RHEL 10.3 virtual machines on VMware Workstation:

| Host | Role |
|---|---|
| cnode | Ansible control node |
| mac1 | Managed node / development |
| mac2 | Managed node / test |

The lab is isolated and uses snapshots before any configuration changes.

## Repository layout

```text
linux-security-hardening/
├── README.md
├── .gitignore
├── docs/
│   └── security-baseline.md
├── scripts/
│   └── audit-baseline.sh
└── ansible/
    ├── inventory/
    │   └── hosts.example.ini
    └── playbooks/
        └── security-audit.yml
```

## First milestone: read-only assessment

1. Review the baseline checklist in `docs/security-baseline.md`.
2. Run `scripts/audit-baseline.sh` on a disposable RHEL 10 VM.
3. Review the output and investigate any findings.
4. Configure Ansible inventory using the example file.
5. Run the audit playbook against the lab nodes.

### Run the Bash audit

```bash
chmod +x scripts/audit-baseline.sh
sudo ./scripts/audit-baseline.sh
```

The script is intended to inspect configuration only. It does not modify SSH, firewall, SELinux, users, or packages.

### Run the Ansible audit

Copy the example inventory and replace the sample addresses and user:

```bash
cp ansible/inventory/hosts.example.ini ansible/inventory/hosts.ini
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/security-audit.yml
```

## Safety principles

- Start with assessment; do not apply blind remediation.
- Take a VM snapshot before changing security settings.
- Keep console access available before modifying SSH or firewall rules.
- Test changes on one lab node before expanding to others.
- Never commit passwords, private keys, tokens, vault passwords, or real inventories.
- Treat audit output as evidence to investigate, not as proof of compliance.

## Roadmap

- [x] Create project structure and initial read-only audit templates
- [ ] Test Bash audit on RHEL 10.3 and record sample findings
- [ ] Test Ansible audit against mac1 and mac2
- [ ] Add SSH hardening guidance and a controlled remediation playbook
- [ ] Add firewalld and SELinux hardening exercises
- [ ] Add account, permissions, and auditd checks
- [ ] Document before/after validation and rollback steps

## Author

**Shaik Aiyaz** — Linux, Windows, and Infrastructure Administration | Automation & Security