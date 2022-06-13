#!/bin/bash

## Install Yay for AUR installs
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
