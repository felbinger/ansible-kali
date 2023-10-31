#!/bin/bash

url="https://ftp.halifax.rwth-aachen.de/kali-images/kali-2023.3/kali-linux-2023.3-virtualbox-amd64.7z"

if ! which 7z &> /dev/null; then
  which dnf &> /dev/null && dnf install -y p7zip
  which apt &> /dev/null && apt install -y p7zip-full
fi

wget ${url}
filename=$(basename ${url} | cut -d '.' -f 1)
7z x ${filename}.7z

VBoxManage registervm ${filename}/${filename}.vbox
VBoxManage startvm ${filename}
