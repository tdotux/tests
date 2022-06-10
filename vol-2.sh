#!/bin/bash


###UTILITARIOS BASICOS

pacman -S dosfstools nano wget --noconfirm



###DETECTAR UEFI OU LEGACY

PASTA_EFI=/sys/firmware/efi

if [ -d "$PASTA_EFI" ];then

echo -e "Sistema EFI"

parted /dev/sda mklabel gpt -s

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"




printf '\x1bc';
PS3=$'\nSelecione um Sistema de Arquivos: ';
echo -e '### Sistema de Arquivos ### '
select filesystem in {EXT4,BTRFS,F2FS,XFS};do
case $filesystem in
EXT4|BTRFS|F2FS|XFS)
parted /dev/sda mkpart primary fat32 1MiB 301MiB -s
parted /dev/sda set 1 esp on
parted /dev/sda mkpart primary ${filesystem,,} 301MiB 100% -s
*) echo -e "\e[1;38mErro\e[m\nEscolha uma Opção válida.";continue;;
esac
break;
done

mkfs.fat -F32 /dev/sda1

##

fs=(sudo blkid -o value -s TYPE /dev/sda2)

if "$fs" = "ext4"
mkfs.ext4 -F /dev/sda2

elif
mkfs.$fs -f /dev/sda2
fi

mount /dev/sda2 /mnt
mkdir /mnt/boot/
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi




