#!/bin/bash

 pacman -S --noconfirm --needed bluez bluez-utils
 systemctl enable bluetooth.service
 