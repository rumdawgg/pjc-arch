#!/bin/bash

source ./settings.env

sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
timedatectl --no-ask-password set-timezone America/Eastern
timedatectl --no-ask-password set-ntp 1
localectl --no-ask-password set-locale LANG="en_US.UTF-8" LC_TIME="en_US.UTF-8"

echo "$INSTALL_HOSTNAME" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $INSTALL_HOSTNAME.$INSTALL_DOMAIN $INSTALL_HOSTNAME" >> /etc/hosts

pacman -S --noconfirm --needed amd-ucode base-devel nano sudo wget efibootmgr curl reflector rsync grub networkmanager alsa-utils bluez bluez-utils

pacman -S --noconfirm --needed nvidia nvidia-utils nvidia-settings xorg-server-devel opencl-nvidia

systemctl enable NetworkManager
systemctl enable bluetooth.service
