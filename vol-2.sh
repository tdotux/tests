#!/bin/bash





printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e 'Escolha um Sistema de Arquivos: '
select filesystem in {EXT4|BTRFS|F2FS|XFS};do
	case $filesystem in
	BTRFS|F2FS|XFS)
	mkfs.${filesystem,,} -f /dev/sda2;;
	*) echo -e "\e[1;38mErro\e[m\nEscolha uma Opção válida.";continue;;
	esac
break;
done 




printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e 'Escolha um Driver de Vídeo: '
select drive in {AMDGPU,ATI,INTEL,Nouveau,Nvidia,VMWARE};do
	case $drive in
	AMDGPU|ATI|INTEL|Nouveau|Nvidia|VMWARE)
	pacman -S xf86-video-${drive,,};;
	*) echo -e "\e[1;38mErro\e[m\nEscolha uma Opção válida.";continue;;
	esac
break;
done 






printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e 'Escolha um Kernel: '
select kernel in {STABLE,ZEN,LTS,HARDENED};do
	case $kernel in
	STABLE|ZEN|LTS|HARDENED)
	pacstrap /mnt base btrfs-progs dosfstools e2fsprogs f2fs-tools dosfstools xfsprogs linux-firmware ${kernel,,};;
	*) echo -e "\e[1;38mErro\e[m\nEscolha uma Opção válida.";continue;;
	esac
break;
done




