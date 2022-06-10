#!/bin/bash




###UTILITARIOS BASICOS

pacman -S dosfstools nano wget --noconfirm





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
	
	*) echo -e "\e[1;38mErro\e[m\nEscolha uma Opção válida.";continue;;
	esac
break;
done 



mount /dev/sda2 /mnt
mkdir /mnt/boot/
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi



#printf '\x1bc';
#PS3=$'\nSelecione uma opção: ';
#echo -e 'Escolha um Driver de Vídeo: '
#select drive in {AMDGPU,ATI,INTEL,Nouveau,Nvidia,VMWARE};do
#	case $drive in
#	AMDGPU|ATI|INTEL|Nouveau|Nvidia|VMWARE)
#	pacman -S xf86-video-${drive,,};;
#	*) echo -e "\e[1;38mErro\e[m\nEscolha uma Opção válida.";continue;;
#	esac
#break;
#done 






printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e 'Escolha um Kernel: '
select kernel in {linux,linux-zen,linux-lts,linux-harneded};do
	case $kernel in
	linux|linux-zen|linux-lts|linux-harneded)
	pacstrap /mnt base btrfs-progs dosfstools e2fsprogs f2fs-tools dosfstools xfsprogs linux-firmware ${kernel,,};;
	*) echo -e "\e[1;38mErro\e[m\nEscolha uma Opção válida.";continue;;
	esac
break;
done




