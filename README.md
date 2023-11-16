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

## Cheatsheets
* [packetlife.net](https://packetlife.net/library/cheat-sheets/)
* [sans.org](https://www.sans.org/blog/the-ultimate-list-of-sans-cheat-sheets/)

### TODO
* OpenVAS
* ipmi?
* ApacheDirectoryStudio
* Docker / Podman
* Install additional software:
  * saleae-logic-2
  * oletools (maybe via docker)

## Old
Before this ansible inventory has been created, I used this bash script to configure my system:
```sh
# configure german keyboard layout
sudo sed -i 's|XKBLAYOUT="us"|XKBLAYOUT="de"|g' /etc/default/keyboard

# use bash instead of zsh shell and use old backtrack ps1
sudo usermod --shell /bin/bash kali
sed -i 's|PROMPT_ALTERNATIVE=.*|PROMPT_ALTERNATIVE=backtrack|g' /home/kali/.bashrc
sed -i 's|NEWLINE_BEFORE_PROMPT=.*|NEWLINE_BEFORE_PROMPT=no|g' /home/kali/.bashrc
sudo usermod --shell /bin/bash root
sudo sed -i 's|PROMPT_ALTERNATIVE=.*|PROMPT_ALTERNATIVE=backtrack|g' /root/.bashrc
sudo sed -i 's|NEWLINE_BEFORE_PROMPT=.*|NEWLINE_BEFORE_PROMPT=no|g' /root/.bashrc

# allow sudo without password & skip gui password promts
sudo sed -i 's|%sudo\tALL=(ALL:ALL).*|%sudo\tALL=(ALL:ALL) NOPASSWD: ALL|g' /etc/sudoers
sudo sed -i '1 aauth sufficient pam_succeed_if.so user ingroup sudo\n' /etc/pam.d/common-auth

# install additional software
sudo apt install -y terminator seclists gobuster

# set terminator as default terminal app
sed -i "s/^TerminalEmulator=.*/TerminalEmulator=terminator/g" /home/kali/.config/xfce4/helpers.rc
```