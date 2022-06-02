#!/bin/bash


###SINCRONIZAR RELOGIO COM A INTERNET

timedatectl set-ntp true



###UTILITARIOS BASICOS

pacman -S dosfstools nano wget --noconfirm



###DETECTAR UEFI OU LEGACY

PASTA_EFI=/sys/firmware/efi

if [ -d "$PASTA_EFI" ];then
echo -e "Sistema EFI"
parted /dev/sda mklabel gpt -s

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo "Sistema de Arquivos"

echo "$(tput sgr0)"

echo "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo "1 - Ext4"

echo "2 - Btrfs"

echo "$(tput sgr0)"

echo "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -ne "Escolha um Sistema de Arquivos : "

read -n1 -s ARQUIVOS

case $ARQUIVOS in

"1")
echo "EXT4"
sleep 2
echo -e "$(tput sgr0)\n\n"
parted /dev/sda mkpart primary fat32 1MiB 301MiB -s
parted /dev/sda set 1 esp on
parted /dev/sda mkpart primary ext4 301MiB 100% -s
mkfs.fat -F32 /dev/sda1
mkfs.ext4 -F /dev/sda2
mount /dev/sda2 /mnt
mkdir /mnt/boot/
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

;;

"2")
echo "BTRFS"
sleep 2
echo -e "$(tput sgr0)\n\n"
pacman -S btrfs-progs --noconfirm
parted /dev/sda mkpart primary fat32 1MiB 301MiB -s
parted /dev/sda set 1 esp on
parted /dev/sda mkpart primary btrfs 301MiB 100% -s
mkfs.fat -F32 /dev/sda1
mkfs.btrfs -f /dev/sda2
mount /dev/sda2 /mnt
mkdir /mnt/boot/
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
esac


else
echo -e "Sistema Legacy"

parted /dev/sda mklabel msdos -s

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e "#### SISTEMA DE ARQUIVOS ####"

echo -e "\n\n" 

echo -e "1 - EXT4"

echo -e "\n"

echo -e "2 - BTRFS"

echo -e "\n\n" 

echo -ne "Escolha um Sistema de Arquivos : "

read -n1 -s ARQUIVOS

case $ARQUIVOS in

"1")
echo "EXT4"
sleep 2
echo -e "$(tput sgr0)\n\n"
parted /dev/sda mkpart primary ext4 1MiB 100% -s
parted /dev/sda set 1 boot on
mkfs.ext4 -F /dev/sda1
mount /dev/sda1 /mnt

;;

"2")
echo "BTRFS"
sleep 2
echo -e "$(tput sgr0)\n\n"
pacman -S btrfs-progs --noconfirm
parted /dev/sda mkpart primary btrfs 1MiB 100% -s
parted /dev/sda set 1 boot on
mkfs.btrfs -f /dev/sda1
mount /dev/sda1 /mnt
esac

fi

echo -e "$(tput sgr0)\n\n"



###PACSTRAP


if [  $( pacman -Q | grep -c 'e2fsprogs' ) = 1 ]; then
pacstrap /mnt base e2fsprogs dosfstools linux-zen linux-firmware
fi


if [  $( pacman -Q | grep -c 'btrfs-progs' ) = 1 ]; then
pacstrap /mnt base btrfs-progs dosfstools linux-zen linux-firmware
fi



###FSTAB

genfstab -U /mnt > /mnt/etc/fstab



###SINCRONIZAR REPOSITORIOS DENTRO DO CHROOT

arch-chroot /mnt pacman -Syy git --noconfirm



###CLONAR O REPOSITORIO DENTRO DO CHROOT

arch-chroot /mnt git clone http://github.com/tdotux/tests



###EXECUTAR O SCRIPT DE POS INSTALAÇÃO DENTRO DO CHROOT

arch-chroot /mnt sh /tests/api-script.sh



###REINICIAR EM 5 SEGUNDOS

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\n\nREINICIANDO EM"
sleep 1
echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\n\n5"
sleep 1
echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\n\n4"
sleep 1
echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\n\n3"
sleep 1
echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\n\n2"
sleep 1
echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\n\n1"


reboot
