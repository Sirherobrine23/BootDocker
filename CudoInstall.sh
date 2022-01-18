#!/bin/bash
set -x
echo -n 'deb [arch=amd64] https://download.cudo.org/repo/apt/ experimental main' > /etc/apt/sources.list.d/cudo.list
wget -O - https://download.cudo.org/keys/pgp/apt.asc > /etc/apt/trusted.gpg.d/cudo.asc
apt update
apt install -y cudo-miner-headless
echo "org=$CUDOORG" > /etc/cudo_minerrc
echo "CUDOORG=$CUDOORG" > /etc/StartEnvs