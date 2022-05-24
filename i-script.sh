#!/bin/bash

timedatectl set-ntp true

pacman -S e2fsprogs dosfstools nano wget --noconfirm

parted /dev/sda mklabel gpt -s

parted /dev/sda mkpart primary fat32 1MiB 301MiB -s

parted /dev/sda set 1 esp on

parted /dev/sda mkpart primary btrfs 301MiB 100% -s

mkfs.fat -F32 /dev/sda1

mkfs.btrfs -f /dev/sda2

mount /dev/sda2 /mnt

mkdir /mnt/boot/

mkdir /mnt/boot/efi

mount /dev/sda1 /mnt/boot/efi

pacstrap /mnt base btrfs-progs linux-zen linux-firmware

genfstab -U /mnt > /mnt/etc/fstab

cd /mnt

git clone http://github.com/tdotux/archscript

arch-chroot /mnt
