#!/bin/bash

pacman -S --noconfirm xorg sddm plasma kde-applications firefox

systemctl enable sddm.service
echo "[Theme]" >>  /etc/sddm.conf
echo "Current=Nordic" >> /etc/sddm.conf
