#!/bin/bash

## Display Server
pacman -S --noconfirm --needed xorg-server xorg-xinit xorg-xrandr xorg-xfontsel xorg-xlsfonts xorg-xkill xorg-xinput xorg-xwininfo

pacman -S --noconfirm --needed xorg sddm plasma kde-applications firefox

systemctl enable sddm.service
echo "[Theme]" >>  /etc/sddm.conf
echo "Current=Nordic" >> /etc/sddm.conf
