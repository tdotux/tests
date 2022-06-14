#!/usr/bin/env sh


### UTILITARIOS BASICOS

pacman -S dosfstools nano wget --noconfirm




### SISTEMA DE ARQUIVOS


printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e 'Escolha um Sistema de Arquivos: '
select filesystem in {ext4,btrfs,F2fs,xfs};do
	case $filesystem in
	btrfs|f2fs|xfs)
	
	parted /dev/sda mklabel gpt -s
	parted /dev/sda mkpart primary fat32 1MiB 301MiB -s
	parted /dev/sda set 1 esp on
	parted /dev/sda mkpart primary ${filesystem,,} 301MiB 100% -s
	mkfs.${filesystem,,} -f /dev/sda2;;
	mkfs.fat -F32 /dev/sda1
	
	*) echo -e "\e[1;38mErro\e[m\nEscolha uma Opção válida.";continue;;
	esac
break;
done 



mount /dev/sda2 /mnt
mkdir /mnt/boot/
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
