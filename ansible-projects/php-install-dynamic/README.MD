# PHP Installation with Ansible

This project automates the installation of PHP using Ansible.

## Usage

Run the following command to execute the playbook:

```bash
ansible-playbook -i inventory.ini playbook.yml
```

When prompted, enter the PHP version you want to install. For example:

```plaintext
Enter the PHP version you want to install (e.g., 7.4, 8.1, 8.2, 8.3):
```

Provide the desired version, and the playbook will handle the installation process.

## Prerequisites

- Ansible installed on your system.
- A valid `inventory.ini` file with the target hosts configured.

## Notes

Ensure the PHP version you specify is supported by your operating system and package manager.  