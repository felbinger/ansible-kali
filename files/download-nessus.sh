#!/bin/bash

# abort execution on error
set -e

echo "[${0}] Installing dependencies"
if ! which jq &> /dev/null; then
  apt install -y jq
fi
if ! which xmllint &> /dev/null; then
  apt install -y libxml2-utils
fi

base=$(dirname ${0})

### download latest version of nessus ###
# download downloads page
# parse html using xmllint, to extract json
# extract latest version json object using jq, by filtering for 'debian and amd64'
echo "[${0}] Fetching download URL" 
obj=$(curl --silent https://www.tenable.com/downloads/nessus?loginAttempted=true \
  | xmllint --html --xpath "string(//script[@type='application/json'])" - 2> /dev/null \
  | jq '[.props.pageProps.page.products | to_entries[] | select(.key | contains("nessus"))] | .[0].value.downloads[] | select(.name | contains("debian")) | select(.name | contains("amd64"))')
filename=$(jq -r .file <<< ${obj})
productId=$(jq -r .id <<< ${obj})
echo "[${0}] Latest nessus version has product id ${productId}"
if [ ! -f ${base}/${filename} ]; then
  echo "[${0}] Downloading to ${filename}"  
  wget -q --show-progress -O ${base}/${filename} https://www.tenable.com/downloads/api/v1/public/pages/nessus/downloads/${productId}/download?i_agree_to_tenable_license_agreement=true
  # https://forums.kali.org/showthread.php?31148-Adding-custom-packages-(-deb)-to-the-Kali-2-0-live-build-process
  # https://gist.github.com/kafkaesqu3/81f320ebfc8583603c679222edc464ac
  mkdir ${base}/tmp
  echo "[${0}] Fixing package name" 
  dpkg-deb -R ${base}/${filename} ${base}/tmp
  sed -i -e "s/\(Package: \)\(Nessus\)/\1\L\2/" ${base}/tmp/DEBIAN/control
  dpkg-deb -b ${base}/tmp ${base}/${filename}
  rm -r ${base}/tmp
fi
