#!/bin/bash

timedatectl set-ntp true

pacman -S e2fsprogs dosfstools nano wget --noconfirm

parted /dev/sda mklabel gpt

parted /dev/sda mkpart primary fat32 1MiB 301MiB

parted /dev/sda set 1 esp on

parted /dev/sda mkpart primary ext4 301MiB 100%

mkfs.fat -F32 /dev/sda1

mkfs.ext4 /dev/sda2

mount /dev/sda2 /mnt

mkdir /mnt/boot/

mkdir /mnt/boot/efi

mount /dev/sda1 /mnt/boot/efi

pacstrap /mnt base linux-zen linux-firmware

genfstab -U /mnt > /mnt/etc/fstab

cd /mnt

git clone http://github.com/tdotux/arch

arch-chroot /mnt


