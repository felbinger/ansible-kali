# Ansible Inventory for Kali VM's
## Installation
```sh
sudo apt update
sudo apt install -y ansible-core git

git clone https://github.com/felbinger/ansible-kali

cd ansible-kali
ansible-playbook playbook.yaml -e ansible_become_pass=kali
```

### TODO
* OpenVAS
