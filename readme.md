# Windows Lab Ansible Playbook
This is a cheeky litle ansible playbook i threw together to spin up a windows lab environment. I started out trying to document the process and write some PowerShell scripts to setup the servers before remembering ansible existed.

This is my first ansible playbook so I'm sure it sucks but I'm proud of it :)
![It aint much but it's Honest Work](https://i.imgur.com/MtmQM0W.jpeg)

Lots of this was borrowed from https://github.com/clayshek/ans-pve-win-templ so check that out too

## Servers (so far)
- DC01 (Primary Domain Controller) [prox1]
- DC02 (Secondary Domain Controller) [prox2]
- MGMT1 (Management Host - Desktop Experience) [prox1]
- PKI01 (Primary Certificate Authority - Should be offline) [prox1]
- PKI02 (Intermediate CA) [prox2]

## AD Structure (Default)
- jordanfromit.fun
    - Users
        - Administrator (Enabled)
        - sa_ansible (Enabled)
        - jordang (Enabled)
        - ea.jordang (Enabled)
    - Domain Controllers
        - DC01
        - DC02
    - Servers
        - Management
            - MGMT1
        - PKI
            - PKI01
            - PKI02

## Getting started
1. Clone this repository to a linux box with ansible installed
2. create a file to be used as a vault (I used 'secrets_file.enc' for this)
4. Fill out the below template in the file and save it (I would recommmend keeping a copy of this in your password manager)
```yml
# Proxmox Server Passwords
prox1_password: 'your first proxmox server'
prox2_password: 'your second proxmox server'

# AD Domain/Forrest Passwords
domain_controller_password: 'the password you want for your domain controllers'
safe_mode_password: 'the safe mode password for your domain controllers'

# service account passwords
ansible_service_account_password: 'the password for the sa_ansible service domain account'

# user account passwords
standard_account_password: 'the password for your non admin account'
admin_account_password: 'the password for your admin account'

# Management Host Passwords
management_host_1_password: 'the password for your management host'
```
5. Encrypt the ansible file with 'ansible-vault encrypt secrets_file.enc'
6. modify the roles/create_windows_server/defaults/main.yml to fit your proxmox setup
7. edit the hosts.ini file and make sure you have the right IPs for your proxmox servers
8. edit group_vars/all.yml to change the domain and account details
9. run 'ansible-playbook lab.yml -i hosts.ini -e @secrets_file.enc --ask-vault-pass' to spin up the lab (this might take a few hours)

## Todo:
- DHCP? failover maybe?
- Configure CAs
- Azure Connector
- Intune Connector
- Intune Certificate Connector

## Todo Long Term
- Workstation VMs (Can I license these without going bankrupt or to jail)
- SCCM maybe
- Network Segmentation
- WPA Enterprise on Unifi APs? (need to investigate)
