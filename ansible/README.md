# Ansible Security Audits

These playbooks perform **read-only assessment** on RHEL-family managed hosts. They do not change SSH, firewalld, SELinux, users, sudoers, or packages.

## Requirements

- Ansible Core installed on the control node.
- SSH connectivity to managed nodes.
- A remote account with the required sudo privileges.
- Python available on managed hosts.
- An inventory maintained locally and excluded from Git if it contains real host details.

## Inventory

Start from `inventory/hosts.example.ini`. Copy it to a local `hosts.ini`, then replace the example IP addresses and placeholder username with your lab values. Do not commit the real inventory.

The example groups `dev` and `test` are children of `managed`, so the playbooks can target both groups together.

## Run the audits

From the repository root:

```bash
ansible all -i ansible/inventory/hosts.ini -m ansible.builtin.ping
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/security-audit.yml
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/ssh-audit.yml
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/firewall-audit.yml
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/selinux-audit.yml
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/account-audit.yml
```

To target one group, add `-l dev` or `-l test` before the playbook path.

## Safety notes

- Review output; a command's successful execution is not a compliance verdict.
- Some checks may return no data when a package or service is absent.
- Do not place passwords or private keys in inventory. Use Ansible Vault or an approved secrets manager for credentials.
- These playbooks are templates and should be reviewed in a disposable lab before operational use.
