#!/usr/bin/env sh



### UTILITARIOS BASICOS

pacman -S dosfstools nano wget --noconfirm





###FORMATAÇÃO E PARTIÇÃO EFI

parted /dev/sda mklabel gpt -s
parted /dev/sda mkpart primary fat32 1MiB 301MiB -s
parted /dev/sda set 1 esp on
mkfs.fat -F32 /dev/sda1



###PARTIÇÃO ROOT

parted /dev/sda mkpart primary $filesystem 301MiB 100% -s



### SISTEMA DE ARQUIVOS


filesystem=$(whiptail --title "Sistema de Arquivos" --menu "Escolha um Sistema de Arquivos" 25 78 5 \
"ext4" " -  Padrão" \
"btrfs" " -  Novo" \
"f2fs" " -  Otimizado para NAND" \
"xfs" " -  Sei Lá Vey kkkk" 3>&1 1>&2 2>&3)

if [ "$filesystem" = "ext4" ];then	
	mkfs.ext4 -F /dev/sda2
	
elif [ "$filesystem" = "btrfs" ];then	
	mkfs.btrfs -f /dev/sda2

elif [ "$filesystem" = "f2fs" ];then	
	mkfs.f2fs -f /dev/sda2
	
elif [ "$filesystem" = "xfs" ];then	
	mkfs.xfs -f /dev/sda2
	
fi	



mount /dev/sda2 /mnt
mkdir /mnt/boot/
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi




### KERNEL


kernel=$(whiptail --title "Kernel" --menu "Escolha um Kernel:" 25 78 5 \
"linux" " -  Padrão" \
"linux-zen" " -  Otimizado Para o Dia a Dia" \
"linux-lts" " -  Suporte Longo" \
"linux-hardened" " -  Focado em Segurança" 3>&1 1>&2 2>&3)
echo "Kernel: $kernel"


### PACSTRAP

pacstrap /mnt base btrfs-progs dosfstools e2fsprogs f2fs-tools dosfstools xfsprogs linux-firmware $kernel


###FSTAB

genfstab -U /mnt > /mnt/etc/fstab



###### INSIDE CHROOT




###AJUSTAR HORA AUTOMATICAMENTE

arch-chroot /mnt "timedatectl set-ntp true"



###SINCRONIZAR REPOSITORIOS

arch-chroot /mnt "pacman -Syy git --noconfirm"
