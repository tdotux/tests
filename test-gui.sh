#!/usr/bin/env sh



### UTILITARIOS BASICOS

pacman -S dosfstools nano wget --noconfirm




###HOSTNAME

hostname=$(whiptail --title "Hostname" --inputbox "Digite o Hostname" 8 40 3>&1 1>&2 2>&3)




###USERNAME

username=$(whiptail --title "Nome de Usuário" --inputbox "Digite o Nome de Usuário" 8 40 3>&1 1>&2 2>&3)




###USERPASSWORD

userpassword=$(whiptail --title "Senha de Usuário" --passwordbox "Digite a Senha de Usuário" 8 78 3>&1 1>&2 2>&3)




###ROOTPASSWORD

rootpassword=$(whiptail --title "Senha de Root" --passwordbox "Digite a Senha de Root" 8 78 3>&1 1>&2 2>&3)


echo -e "\n\n\n"


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



### DRIVER DE VIDEO


videodriver=$(whiptail --title "Driver de Vídeo" --checklist \
"Selecione um ou mais Drivers de Vídeo:" 20 100 10 \
"xf86-video-amdgpu" "Placas AMD Recentes " OFF \
"xf86-video-ati" "Placas AMD Antigas " OFF \
"xf86-video-intel" "Placas Intel " OFF \
"xf86-video-nouveau" "Driver Nvidia de Código Aberto " OFF \
"xf86-video-nvidia" "Driver Proprietário Nvidia " OFF \
"xf86-video-vmware" "Driver para Máquinas Virtuais " OFF 3>&1 1>&2 2>&3)





### INTERFACE GRAFICA (DE)


de=$(whiptail --title "Interface Gráfica" --menu "Escolha uma Interface Gráfica:" 25 78 10 \
"Budge" "" \
"Cinnamon" "" \
"Deepin" "" \
"Gnome" "" \
"Plasma-X11" "" \
"Plasma-Wayland" "" \
"LXDE" "" \
"LXQT" "" \
"MATE" "" \
"XFCE" "" 3>&1 1>&2 2>&3)



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

arch-chroot /mnt timedatectl set-ntp true



###SINCRONIZAR REPOSITORIOS

arch-chroot /mnt pacman -Syy git --noconfirm


###UTILITARIOS BASICOS

arch-chroot /mnt pacman -Sy nano wget pacman-contrib sudo grub --noconfirm




###ADD-USER


arch-chroot /mnt useradd -m $username



###SET-USER-PASSWORD


echo -e "$userpassword\n$userpassword" | arch-chroot /mnt passwd $username



### SET-ROOT-PASSWORD

echo -e "$rootpassword\n$rootpassword" | arch-chroot /mnt passwd




