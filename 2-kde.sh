#!/bin/bash

pacman -S --noconfirm --needed xorg plasma kde-applications sddm
systemctl enable sddm.service
echo "[Theme]" >>  /etc/sddm.conf
echo "Current=Nordic" >> /etc/sddm.conf
