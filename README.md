# Ansible Inventory for Kali VM's
## Installation
```sh
sudo apt update
sudo apt install -y ansible-core git

git clone https://github.com/felbinger/ansible-kali

cd ansible-kali
echo "mY_s3cR3t-K3y" > .vault.key
ansible-playbook playbook.yaml -e ansible_become_pass=kali --vault-password .vault.key
```

## Add OpenVPN configurations
```sh
# add your .ovpn files to files/vpn

find files/vpn/ -name '*.ovpn' -exec \
  ansible-vault encrypt \
    --vault-password-file .vault.key \
    --output {}.vault {} \;
```

### TODO
* OpenVAS
* Docker / Podman
* Install additional software:
  * saleae-logic-2
  * oletools (maybe via docker)
