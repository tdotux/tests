#!/usr/bin/env sh

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

echo -e "#### Sistema de Arquivos ####"

echo -e "\n\n"

echo -e "1 - Ext4"

echo -e "\n"

echo -e "2 - Btrfs"

echo -e "\n"

echo -e "3 - F2FS"

echo -e "\n"

echo -e "4 - XFS"

echo -e "\n\n"

echo -ne "Escolha um Sistema de Arquivos : "

read ARQUIVOS


if [ "$ARQUIVOS" = "1" ];then

echo "Ext4"
sleep 2
echo -e "$(tput sgr0)"
parted /dev/sda mkpart primary fat32 1MiB 301MiB -s
parted /dev/sda set 1 esp on
parted /dev/sda mkpart primary ext4 301MiB 100% -s
mkfs.fat -F32 /dev/sda1
mkfs.ext4 -F /dev/sda2
mount /dev/sda2 /mnt
mkdir /mnt/boot/
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi



elif [ "$ARQUIVOS" = "2" ];then

echo "Btrfs"
sleep 2
echo -e "$(tput sgr0)"
parted /dev/sda mkpart primary fat32 1MiB 301MiB -s
parted /dev/sda set 1 esp on
parted /dev/sda mkpart primary btrfs 301MiB 100% -s
mkfs.fat -F32 /dev/sda1
mkfs.btrfs -f /dev/sda2
mount /dev/sda2 /mnt
mkdir /mnt/boot/
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

elif [ "$ARQUIVOS" = "3" ];then

echo "F2FS"
sleep 2
echo -e "$(tput sgr0)"
parted /dev/sda mkpart primary fat32 1MiB 301MiB -s
parted /dev/sda set 1 esp on
parted /dev/sda mkpart primary f2fs 301MiB 100% -s
mkfs.fat -F32 /dev/sda1
mkfs.f2fs -f /dev/sda2
mount /dev/sda2 /mnt
mkdir /mnt/boot/
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

elif [ "$ARQUIVOS" = "4" ];then

echo "XFS"
sleep 2
echo -e "$(tput sgr0)"
parted /dev/sda mkpart primary fat32 1MiB 301MiB -s
parted /dev/sda set 1 esp on
parted /dev/sda mkpart primary btrfs 301MiB 100% -s
mkfs.fat -F32 /dev/sda1
mkfs.xfs -f /dev/sda2
mount /dev/sda2 /mnt
mkdir /mnt/boot/
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
fi

else

echo -e "Sistema Legacy"

parted /dev/sda mklabel msdos -s

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e "#### Sistema de Arquivos ####"

echo -e "\n\n"

echo -e "1 - Ext4"

echo -e "\n"

echo -e "2 - Btrfs"

echo -e "\n"

echo -e "3 - F2FS"

echo -e "\n"

echo -e "4 - XFS"

echo -e "\n\n"

echo -ne "Escolha um Sistema de Arquivos : "


#read -n1 -s ARQUIVOS

read -p ARQUIVOS


if [ "$ARQUIVOS" = "1" ];then

echo "Ext4"
sleep 2
echo -e "$(tput sgr0)"
parted /dev/sda mkpart primary fat32 1MiB 301MiB -s
parted /dev/sda set 1 esp on
parted /dev/sda mkpart primary ext4 301MiB 100% -s
mkfs.fat -F32 /dev/sda1
mkfs.ext4 -F /dev/sda2
mount /dev/sda2 /mnt
mkdir /mnt/boot/
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi



elif [ "$ARQUIVOS" = "2" ];then

echo "Btrfs"
sleep 2
echo -e "$(tput sgr0)"
parted /dev/sda mkpart primary fat32 1MiB 301MiB -s
parted /dev/sda set 1 esp on
parted /dev/sda mkpart primary btrfs 301MiB 100% -s
mkfs.fat -F32 /dev/sda1
mkfs.btrfs -f /dev/sda2
mount /dev/sda2 /mnt
mkdir /mnt/boot/
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

elif [ "$ARQUIVOS" = "3" ];then

echo "F2FS"
sleep 2
echo -e "$(tput sgr0)"
parted /dev/sda mkpart primary fat32 1MiB 301MiB -s
parted /dev/sda set 1 esp on
parted /dev/sda mkpart primary f2fs 301MiB 100% -s
mkfs.fat -F32 /dev/sda1
mkfs.f2fs -f /dev/sda2
mount /dev/sda2 /mnt
mkdir /mnt/boot/
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

elif [ "$ARQUIVOS" = "4" ];then

echo "XFS"
sleep 2
echo -e "$(tput sgr0)"
parted /dev/sda mkpart primary fat32 1MiB 301MiB -s
parted /dev/sda set 1 esp on
parted /dev/sda mkpart primary btrfs 301MiB 100% -s
mkfs.fat -F32 /dev/sda1
mkfs.xfs -f /dev/sda2
mount /dev/sda2 /mnt
mkdir /mnt/boot/
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
fi

fi

echo -e "$(tput sgr0)"




###USERNAME

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e "Nome de Usuário (Username)"

echo -e "\n"

read -p "Digite o Nome de Usuário : " USERNAME

echo -e "$(tput sgr0)"



###SENHA DO USUARIO

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e "Senha do Usuário"

echo -e "\n"

read -p "Digite a Senha de Usuário : " USERPASSWORD

echo -e "$(tput sgr0)"



### SENHA DE ROOT

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e "Senha de Root (Administrador)"

echo -e "\n"

read -p "Digite a Senha de Root : " ROOTPASSWORD

echo -e "$(tput sgr0)"



###DRIVER DE VIDEO

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e "#### DRIVER DE VIDEO PRIMARIO ####"

echo -e "\n"

echo -e "1 - AMDGPU"

echo -e "2 - ATI"

echo -e "3 - Intel"

echo -e "4 - Nouveau (Nvidia Open Source)"

echo -e "5 - Nvidia (Proprietário)"

echo -e "6 - VMWARE"

echo -e "\n"

read -p "Escolha um Driver Primário : " PDRVIER

echo -e "$(tput sgr0)"





### DRIVER DE VIDEO SECUNDARIO ###

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e "#### DRIVER DE VIDEO SECUNDARIO ####"

echo -e "\n"

echo -e "1 - AMDGPU"

echo -e "2 - ATI"

echo -e "3 - Intel"

echo -e "4 - Nouveau (Nvidia Open Source)"

echo -e "5 - Nvidia (Proprietário)"

echo -e "\n\n"

echo -e "Pressione Enter para pular esta etapa"

echo -e "\n"

read -p "Escolha um Driver Secundário : " SDRVIER

echo -e "$(tput sgr0)"




##SWAP FILE

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e "### Swap ###"

echo -e "\n"

echo -e "Escolha o Tamanho do Arquivo de Swap"

echo -e "\n"

echo -e "Para Máquinas Até 8GB de RAM = 4GB DE SWAP"

echo -e "\n"

echo -e "Acima de 8GB de RAM = 2GB DE SWAP"

echo -e "\n"

echo -e "Digite o Número Correspondente a Quantidade de Swap"

echo -e "\n\n"

echo -e "2 - 2GB"

echo -e "\n"

echo -e "4 - 4GB"

echo -e "\n\n"

read -p "Escolha uma Quantidade de SWAP : " SWAP

echo -e "$(tput sgr0)"




###INTERFACE GRÁFICA

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e "#### INTERFACE GRAFICA (DE) ####"

echo -e "\n"

echo -e "1 - Budgie"

echo -e "2 - Cinnamon"

echo -e "3 - Deepin"

echo -e "4 - GNOME"

echo -e "5 - KDE Plasma (X11)"

echo -e "6 - KDE Plasma (Wayland)"

echo -e "7 - LXDE"

echo -e "8 - LXQt"

echo -e "9 - MATE"

echo -e "10 - XFCE"

echo -e "\n"

read -p "Escolha uma Interface Gráfica : " DE

echo -e "$(tput sgr0)"




###PACSTRAP E KERNEL

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e "#### Kernel ####"

echo -e "\n\n"

echo -e "1 - Stable (Padrão)"

echo -e "\n"

echo -e "2 - Zen (Otimizado Para o Dia a Dia)"

echo -e "\n"

echo -e "3 - LTS (Suporte Longo)"

echo -e "\n"

echo -e "4 - Hardened (Focado em Segurança)"

echo -e "\n\n"

read -p "Escolha um Kernel : " KERNEL



if [ "$KERNEL" = "1" ];then

echo "Stable"

sleep 2

echo -e "$(tput sgr0)"

pacstrap /mnt base btrfs-progs dosfstools e2fsprogs f2fs-tools dosfstools xfsprogs linux linux-firmware



elif [ "$KERNEL" = "2" ];then

echo "Zen"

sleep 2

echo -e "$(tput sgr0)"

pacstrap /mnt base btrfs-progs dosfstools e2fsprogs f2fs-tools dosfstools xfsprogs linux-zen linux-firmware



elif [ "$KERNEL" = "3" ];then

echo "LTS"

sleep 2

echo -e "$(tput sgr0)"

pacstrap /mnt base btrfs-progs dosfstools e2fsprogs f2fs-tools dosfstools xfsprogs linux-lts linux-firmware



elif [ "$KERNEL" = "4" ];then

echo "Hardened"

sleep 2

echo -e "$(tput sgr0)"

pacstrap /mnt base btrfs-progs dosfstools e2fsprogs f2fs-tools dosfstools xfsprogs linux-hardened linux-firmware

fi



###FSTAB

genfstab -U /mnt > /mnt/etc/fstab


###ADD-USER


arch-chroot /mnt useradd -m $USERNAME

echo -e "$(tput sgr0)"


###SET-USER-PASSWORD


echo -e "$USERPASSWORD\n$USERPASSWORD" | arch-chroot /mnt passwd $USERNAME



### SET-ROOT-PASSWORD

echo -e "$ROOTPASSWORD\n$ROOTPASSWORD" | arch-chroot /mnt passwd




##### CHROOT #####



###AJUSTAR HORA AUTOMATICAMENTE

arch-chroot /mnt timedatectl set-ntp true



###SINCRONIZAR REPOSITORIOS

arch-chroot /mnt pacman -Syy git --noconfirm


###UTILITARIOS BASICOS

arch-chroot /mnt pacman -Sy nano wget pacman-contrib reflector sudo grub --noconfirm



###MIRRORS

#cp /mnt/etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist.bak && curl -s "https://archlinux.org/mirrorlist/?country=BR&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - | tee /mnt/etc/pacman.d/mirrorlist && sed -i '/br.mirror.archlinux-br.org/d' /mnt/etc/pacman.d/mirrorlist




###PARALLEL DOWNLOADS

cp /mnt/etc/pacman.conf /mnt/etc/pacman.conf.bak && sed -i '37c\ParallelDownloads = 16' /mnt/etc/pacman.conf && arch-chroot /mnt pacman -Syyyuuu --noconfirm




###MULTILIB

sed -i '93c\[multilib]' /mnt/etc/pacman.conf && sed -i '94c\Include = /etc/pacman.d/mirrorlist' /mnt/etc/pacman.conf && arch-chroot /mnt pacman -Syyyuu --noconfirm




###FUSO HORARIO

ln -sf /mnt/usr/share/zoneinfo/America/Sao_Paulo /mnt/etc/localtime && arch-chroot /mnt hwclock --systohc




###LOCALE

mv /mnt/etc/locale.gen /mnt/etc/locale.gen.bak && echo -e 'pt_BR.UTF-8 UTF-8' | tee /mnt/etc/locale.gen && arch-chroot /mnt locale-gen && echo -e 'LANG=pt_BR.UTF-8' | tee /mnt/etc/locale.conf




###GRUPOS

arch-chroot /mnt groupadd -r autologin

arch-chroot /mnt groupadd -r sudo

arch-chroot /mnt usermod -G autologin,sudo,wheel,lp $USERNAME




###WHEEL

cp /mnt/etc/sudoers /mnt/etc/sudoers.bak && sed -i '82c\ %wheel ALL=(ALL:ALL) ALL' /mnt/etc/sudoers


###SET-VIDEO-DRIVER



if [ "$PDRIVER" = "1" ];then

echo "AMDGPU"

sleep 2

echo -e "$(tput sgr0)"

arch-chroot /mnt pacman -S xf86-video-amdgpu --noconfirm


elif [ "$PDRIVER" = "2" ];then

echo "ATI"

sleep 2

echo -e "$(tput sgr0)\n\n"

arch-chroot /mnt pacman -S xf86-video-ati --noconfirm


elif [ "$PDRIVER" = "3" ];then

echo "Intel"

sleep 2

echo -e "$(tput sgr0)\n\n"

arch-chroot /mnt pacman -S xf86-video-intel --noconfirm



elif [ "$PDRIVER" = "4" ];then

echo "Nvidia (Open Source)"

sleep 2

echo -e "$(tput sgr0)\n\n"

arch-chroot /mnt pacman -S xf86-video-nouveau --noconfirm

elif [ "$PDRIVER" = "5" ];then

echo "Nvidia (Proprietário)"

sleep 2

echo -e "$(tput sgr0)\n\n"

arch-chroot /mnt pacman -S xf86-video-nvidia --noconfirm


elif [ "$PDRIVER" = "6" ];then

echo "VMWARE"

sleep 2

echo -e "$(tput sgr0)\n\n"

arch-chroot /mnt pacman -S xf86-video-vmware --noconfirm

echo -e "$(tput sgr0)\n\n"

fi



###SET-SECONDARY-VIDEO-DRIVER



if [ "SPDRIVER" = "1" ];then

echo "AMDGPU"

sleep 2

echo -e "$(tput sgr0)"

arch-chroot /mnt pacman -S xf86-video-amdgpu --noconfirm


elif [ "$SPDRIVER" = "2" ];then

echo "ATI"

sleep 2

echo -e "$(tput sgr0)\n\n"

arch-chroot /mnt pacman -S xf86-video-ati --noconfirm


elif [ "$SPDRIVER" = "3" ];then

echo "Intel"

sleep 2

echo -e "$(tput sgr0)\n\n"

arch-chroot /mnt pacman -S xf86-video-intel --noconfirm



elif [ "$SPDRIVER" = "4" ];then

echo "Nvidia (Open Source)"

sleep 2

echo -e "$(tput sgr0)\n\n"

arch-chroot /mnt pacman -S xf86-video-nouveau --noconfirm

elif [ "$SPDRIVER" = "5" ];then

echo "Nvidia (Proprietário)"

sleep 2

echo -e "$(tput sgr0)\n\n"

arch-chroot /mnt pacman -S xf86-video-nvidia --noconfirm

fi




###SET-SWAP

if [ "$SWAP" = "2" ];then

echo "2GB"

sleep 2

echo -e "$(tput sgr0)"

fs=$(blkid -o value -s TYPE /dev/sda2)

if [ "$fs" = "ext4" ];then

arch-chroot /mnt fallocate -l 2G /swapfile && arch-chroot /mnt chmod 600 /swapfile && arch-chroot /mnt mkswap /swapfile && arch-chroot /mnt swapon /swapfile && cp /mnt/etc/fstab /mnt/etc/fstab.bak && echo -e '/swapfile   none    swap    sw    0   0' | tee -a /mnt/etc/fstab

elif [ "$fs" = "btrfs" ];then

truncate -s 0 /mnt/swapfile && chattr +C /mnt/swapfile && btrfs property set /mnt/swapfile compression "" && arch-chroot /mnt fallocate -l 2G /swapfile && arch-chroot /mnt chmod 600 /swapfile && arch-chroot /mnt mkswap /swapfile && arch-chroot /mnt swapon /swapfile && cp /mnt/etc/fstab /mnt/etc/fstab.bak && echo -e '/swapfile   none    swap    sw    0   0' | tee -a /mnt/etc/fstab

elif [ "$fs" = "f2fs" ];then

arch-chroot /mnt fallocate -l 2G /swapfile && arch-chroot /mnt chmod 600 /swapfile && arch-chroot /mnt mkswap /swapfile && arch-chroot /mnt swapon /swapfile && cp /mnt/etc/fstab /mnt/etc/fstab.bak && echo -e '/swapfile   none    swap    sw    0   0' | tee -a /mnt/etc/fstab

elif [ "$fs" = "xfs" ];then

arch-chroot /mnt fallocate -l 2G /swapfile && arch-chroot /mnt chmod 600 /swapfile && arch-chroot /mnt mkswap /swapfile && arch-chroot /mnt swapon /swapfile && cp /mnt/etc/fstab /mnt/etc/fstab.bak && echo -e '/swapfile   none    swap    sw    0   0' | tee -a /mnt/etc/fstab

fi

fi



if [ "$SWAP" = "4" ];then

echo "4GB"

sleep 2

echo -e "$(tput sgr0)"

fs=$(blkid -o value -s TYPE /dev/sda2)

if [ "$fs" = "ext4" ];then

arch-chroot /mnt fallocate -l 4G /swapfile && arch-chroot /mnt chmod 600 /swapfile && arch-chroot /mnt mkswap /swapfile && arch-chroot /mnt swapon /swapfile && cp /mnt/etc/fstab /mnt/etc/fstab.bak && echo -e '/swapfile   none    swap    sw    0   0' | tee -a /mnt/etc/fstab

elif [ "$fs" = "btrfs" ];then

truncate -s 0 /mnt/swapfile && chattr +C /mnt/swapfile && btrfs property set /mnt/swapfile compression "" && arch-chroot /mnt fallocate -l 4G /swapfile && arch-chroot /mnt chmod 600 /swapfile && arch-chroot /mnt mkswap /swapfile && arch-chroot /mnt swapon /swapfile && cp /mnt/etc/fstab /mnt/etc/fstab.bak && echo -e '/swapfile   none    swap    sw    0   0' | tee -a /mnt/etc/fstab

elif [ "$fs" = "f2fs" ];then

arch-chroot /mnt fallocate -l 4G /swapfile && arch-chroot /mnt chmod 600 /swapfile && arch-chroot /mnt mkswap /swapfile && arch-chroot /mnt swapon /swapfile && cp /mnt/etc/fstab /mnt/etc/fstab.bak && echo -e '/swapfile   none    swap    sw    0   0' | tee -a /mnt/etc/fstab

elif [ "$fs" = "xfs" ];then

arch-chroot /mnt fallocate -l 4G /swapfile && arch-chroot /mnt chmod 600 /swapfile && arch-chroot /mnt mkswap /swapfile && arch-chroot /mnt swapon /swapfile && cp /mnt/etc/fstab /mnt/etc/fstab.bak && echo -e '/swapfile   none    swap    sw    0   0' | tee -a /mnt/etc/fstab

fi

fi





###SET-DESKTOP-ENVIRONMENT



if [ "$DE" = "1" ];then

echo "Budge"

sleep 2

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S budgie-desktop gnome-terminal gedit gnome-calculator gnome-calendar gnome-system-monitor nautilus network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
arch-chroot /mnt systemctl enable lightdm NetworkManager



elif [ "$DE" = "2" ];then

echo "Cinnamon"

sleep 2
echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S cinnamon network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
arch-chroot /mnt systemctl enable lightdm NetworkManager



elif [ "$DE" = "3" ];then

echo "Deepin"

sleep 2
echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S deepin network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
arch-chroot /mnt systemctl enable lightdm NetworkManager



elif [ "$DE" = "4" ];then

echo "Gnome"

sleep 2
echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S gnome gnome-tweaks network-manager-applet gdm --noconfirm
arch-chroot /mnt systemctl enable gdm NetworkManager

elif [ "$DE" = "5" ];then

echo "KDE Plasma (X11)"

sleep 2

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S plasma konsole sddm dolphin spectacle kcalc kwrite gwenview plasma-nm plasma-pa --noconfirm
arch-chroot /mnt systemctl enable sddm NetworkManager


elif [ "$DE" = "6" ];then

echo "KDE Plasma (Wayland)"

sleep 2

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S plasma konsole sddm dolphin spectacle kcalc kwrite gwenview plasma-nm plasma-pa plasma-wayland-session --noconfirm
arch-chroot /mnt systemctl enable sddm NetworkManager

elif [ "$DE" = "7" ];then

echo "LXDE"

sleep 2

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S lxde-gtk3 lxtask network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
arch-chroot /mnt systemctl enable lightdm NetworkManager

elif [ "$DE" = "8" ];then

echo "LXQT"

sleep 2
echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S lxqt lxtask network-manager-applet sddm --noconfirm
arch-chroot /mnt systemctl enable sddm NetworkManager

elif [ "$DE" = "9" ];then

echo "MATE"

sleep 2

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S mate mate-extra network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
arch-chroot /mnt systemctl enable lightdm NetworkManager



elif [ "$DE" = "10" ];then

echo "XFCE"

sleep 2

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S xfce4 xfce4-screenshooter xfce4-pulseaudio-plugin xfce4-whiskermenu-plugin xarchiver lxtask ristretto mousepad galculator thunar-archive-plugin network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
arch-chroot /mnt systemctl enable lightdm NetworkManager

fi


echo -e "$(tput sgr0)\n\n"





###USER DIRS UPDATE

arch-chroot /mnt xdg-user-dirs-update





###GRUB

PASTA_EFI=/sys/firmware/efi
if [ ! -d "$PASTA_EFI" ];then
echo -e "Sistema Legacy"
arch-chroot /mnt grub-install --target=i386-pc /dev/sda --force && arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

else
echo -e "Sistema EFI"
pacman -S efibootmgr --noconfirm
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Arch --removable && arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

fi



echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"


echo -e "Instalação Concluída!!!!!"


echo -e "$(tput sgr0)"
