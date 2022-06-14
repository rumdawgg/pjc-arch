#!/bin/bash

source ./settings.env

ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
timedatectl set-local-rtc 1 --adjust-system-clock

sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
export LANG="en_US.UTF-8"

echo "$INSTALL_HOSTNAME" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $INSTALL_HOSTNAME.$INSTALL_DOMAIN $INSTALL_HOSTNAME" >> /etc/hosts

pacman -S --noconfirm --needed base-devel usbutils e2fsprogs inetutils netctl nano emacs openssh ufw less which man-db man-pages sudo wget curl reflector rsync networkmanager dhclient

# Add sudo rights
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

## CPU Microcode
proc_type=$(lscpu)
if grep -E "GenuineIntel" <<< ${proc_type}; then
  echo "Installing Intel microcode"
  pacman -S --noconfirm --needed intel-ucode
  proc_ucode=intel-ucode.img
elif grep -E "AuthenticAMD" <<< ${proc_type}; then
  echo "Installing AMD microcode"
  pacman -S --noconfirm --needed amd-ucode
  proc_ucode=amd-ucode.img
fi

## Graphics Drivers
gpu_type=$(lspci)
if grep -E "NVIDIA|GeForce" <<< ${gpu_type}; then
  pacman -S --noconfirm --needed nvidia nvidia-utils nvidia-settings xorg-server-devel opencl-nvidia
elif lspci | grep 'VGA' | grep -E "Radeon|AMD"; then
  pacman -S --noconfirm --needed xf86-video-amdgpu
elif grep -E "Integrated Graphics Controller" <<< ${gpu_type}; then
  pacman -S --noconfirm --needed libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils lib32-mesa
elif grep -E "Intel Corporation UHD" <<< ${gpu_type}; then
  pacman -S --needed --noconfirm libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils lib32-mesa
fi

## Setup user
useradd -m -G wheel,audio,video,storage -s /bin/bash $USERNAME 

systemctl enable NetworkManager
systemctl enable ufw
systemctl enable sshd

pacman -S --noconfirm --needed grub os-prober efibootmgr dosfstools mtools gptfdisk fatresize
grub-install --target=x86_64-efi --bootloader-id=ArchLinux --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg
