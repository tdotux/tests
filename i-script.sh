#!/bin/bash

timedatectl set-ntp true

pacman -S e2fsprogs dosfstools nano wget --noconfirm



PASTA_EFI=/sys/firmware/efi
if [ ! -d "$PASTA_EFI" ];then
echo -e "Sistema Legacy"
parted /dev/sda mklabel msdos -s
parted /dev/sda mkpart primary ext4 1MiB 100% -s
parted /dev/sda set 1 boot on
mkfs.ext4 /dev/sda1
mount /dev/sda1 /mnt


else
echo -e "Sistema EFI"
parted /dev/sda mklabel gpt -s
parted /dev/sda mkpart primary fat32 1MiB 301MiB -s
parted /dev/sda set 1 esp on
parted /dev/sda mkpart primary ext4 301MiB 100% -s
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt
mkdir /mnt/boot/
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
fi



pacstrap /mnt base e2fsprogs linux-zen linux-firmware

genfstab -U /mnt > /mnt/etc/fstab

arch-chroot /mnt git clone http://github.com/tdotux/tests

arch-chroot /mnt sh /tests/pi-script.sh
