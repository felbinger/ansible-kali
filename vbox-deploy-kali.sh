#!/bin/bash

set -ex

url="https://ftp.halifax.rwth-aachen.de/kali-images/kali-2023.3/kali-linux-2023.3-virtualbox-amd64.7z"

# ensure package to unarchive 7z files is installed
if ! which 7z &> /dev/null; then
  which dnf &> /dev/null && dnf install -y p7zip
  which apt &> /dev/null && apt install -y p7zip-full
fi

filename=$(basename ${url} .7z)

# abort script successful if directory already exists
! [ -d ~/.VirtualBox/${filename} ] || exit 0
wget ${url} -O /tmp/${filename}.7z
7z x -o~/.VirtualBox /tmp/${filename}.7z
rm /tmp/${filename}.7z

VBoxManage registervm ~/.VirtualBox/${filename}/${filename}.vbox
VBoxManage startvm ${filename}
