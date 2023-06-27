#!/bin/bash

<<'MULTILINE-COMMENT'
    Requirments: none
    Description: Script for set environment for labs
    Author: Marcos Silvestrini
    Date: 20/02/2023
MULTILINE-COMMENT

# Set language/locale and encoding
export LANG=C

cd /home/vagrant || exit

# Set password account
usermod --password $(echo vagrant | openssl passwd -1 -stdin) vagrant
usermod --password $(echo vagrant | openssl passwd -1 -stdin) root

# Install packages
apt-get update -y
apt-get upgrade -y
apt-get install -y \
jq \
sshpass \
vim \
dos2unix \
tree \
curl \
psmisc \
xserver-xorg \
python3-pip \
python3-venv \
net-tools \
network-manager \
dnsutils \
tcpdump \
sysstat \
htop \
collectd \
samba smbclient \
cifs-utils \
nmap

# Set profile in /etc/profile
cp -f configs/commons/profile-debian /etc/profile
dos2unix /etc/profile

# Set vim profile
cp -f configs/commons/.vimrc .
dos2unix .vimrc
chown vagrant:vagrant .vimrc

# Set bash session
cp -f configs/commons/.bashrc-debian .bashrc
dos2unix .bashrc
chown vagrant:vagrant .bashrc

# Set properties for user root
cp -f .bashrc .vimrc /root

# Set Swap memory
fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

# Enabling IP forwarding on Linux
cp configs/commons/sysctl.conf /etc
dos2unix /etc/sysctl.conf
systemctl daemon-reload

# Set ssh
cp -f configs/commons/01-sshd-custom.conf /etc/ssh/sshd_config.d
dos2unix /etc/ssh/sshd_config.d/01-sshd-custom.conf
systemctl restart sshd
cat security/id_ecdsa.pub >>.ssh/authorized_keys
echo vagrant | $(su -c "ssh-keygen -q -t ecdsa -b 521 -N '' -f .ssh/id_ecdsa <<<y >/dev/null 2>&1" -s /bin/bash vagrant)

# Set GnuGP
echo vagrant | $(su -c "gpg --batch --gen-key configs/commons/gen-key-script" -s /bin/bash vagrant)
echo vagrant | $(su -c "gpg --export --armor vagrant > .gnupg/vagrant.pub.key" -s /bin/bash vagrant)

# Set X11 Server
Xorg -configure
mv /root/xorg.conf.new /etc/X11/xorg.conf

# Enable sadc collected system activity
sed -i 's/false/true/g' /etc/default/sysstat
cp -f configs/commons/cron.d-sysstat /etc/cron.d/sysstat
dos2unix /etc/cron.d/sysstat
systemctl start sysstat
systemctl enable sysstat

# Set Default DNS Server

## Copy host file
cp -f configs/commons/hosts /etc
dos2unix /etc/hosts

## Set Networkmanager
cp -f configs/commons/01-NetworkManager-custom.conf /etc/NetworkManager/conf.d/
dos2unix /etc/NetworkManager/conf.d/01-NetworkManager-custom.conf
systemctl reload NetworkManager

## Set resolv.conf file
rm /etc/resolv.conf
cp configs/commons/resolv.conf.manually-configured /etc
dos2unix /etc/resolv.conf.manually-configured
ln -s /etc/resolv.conf.manually-configured /etc/resolv.conf
