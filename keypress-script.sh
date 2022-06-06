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

read -n1 -s ARQUIVOS

case $ARQUIVOS in

"1")
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

;;

"2")
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

;;

"3")
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

;;

"4")
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
esac


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

read -n1 -s ARQUIVOS

case $ARQUIVOS in

"1")
echo "Ext4"
sleep 2
echo -e "$(tput sgr0)"
parted /dev/sda mkpart primary ext4 1MiB 100% -s
parted /dev/sda set 1 boot on
mkfs.ext4 -F /dev/sda1
mount /dev/sda1 /mnt

;;

"2")
echo "Btrfs"
sleep 2
echo -e "$(tput sgr0)"
parted /dev/sda mkpart primary btrfs 1MiB 100% -s
parted /dev/sda set 1 boot on
mkfs.btrfs -f /dev/sda1
mount /dev/sda1 /mnt

;;

"3")
echo "F2FS"
sleep 2
echo -e "$(tput sgr0)"
parted /dev/sda mkpart primary f2fs 1MiB 100% -s
parted /dev/sda set 1 boot on
mkfs.f2fs -f /dev/sda1
mount /dev/sda1 /mnt

;;

"4")
echo "XFS"
sleep 2
echo -e "$(tput sgr0)"
parted /dev/sda mkpart primary xfs 1MiB 100% -s
parted /dev/sda set 1 boot on
mkfs.xfs -f /dev/sda1
mount /dev/sda1 /mnt

esac

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

echo -e "$(tput sgr0)\n\n"





###SENHA DE ROOT

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e "Senha de Root"

echo -e "\n"

read -p "Digite a Senha de Root : " ROOTPASSWORD

echo -e "$(tput sgr0)\n\n"




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

echo -ne "Escolha um Kernel : "

read -n1 -s KERNEL

case $KERNEL in

"1")
echo "Stable"
sleep 2

echo -e "$(tput sgr0)"

pacstrap /mnt base btrfs-progs dosfstools e2fsprogs f2fs-tools dosfstools xfsprogs linux linux-firmware

;;


"2")
echo "Zen"
sleep 2

echo -e "$(tput sgr0)"

pacstrap /mnt base btrfs-progs dosfstools e2fsprogs f2fs-tools dosfstools xfsprogs linux-zen linux-firmware


;;

"3")
echo "LTS"
sleep 2

echo -e "$(tput sgr0)"

pacstrap /mnt base btrfs-progs dosfstools e2fsprogs f2fs-tools dosfstools xfsprogs linux-lts linux-firmware


;;

"4")
echo "Hardened"
sleep 2

echo -e "$(tput sgr0)"

pacstrap /mnt base btrfs-progs dosfstools e2fsprogs f2fs-tools dosfstools xfsprogs linux-hardened linux-firmware


esac





###FSTAB

genfstab -U /mnt > /mnt/etc/fstab


##### CHROOT #####



###AJUSTAR HORA AUTOMATICAMENTE

arch-chroot /mnt timedatectl set-ntp true



###SINCRONIZAR REPOSITORIOS

arch-chroot /mnt pacman -Syy git --noconfirm


###UTILITARIOS BASICOS

#arch-chroot /mnt pacman -Sy nano wget pacman-contrib reflector sudo grub --noconfirm



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





### NOME DE USUARIO


arch-chroot /mnt useradd -m $USERNAME




### SENHA DE USUARIO


echo -e "$USERPASSWORD\n$USERPASSWORD" | arch-chroot /mnt passwd $USERNAME



### SENHA DE ROOT


echo -e "$ROOTPASSWORD\n$ROOTPASSWORD" | arch-chroot /mnt passwd




###GRUPOS

arch-chroot /mnt groupadd -r autologin

arch-chroot /mnt groupadd -r sudo

arch-chroot /mnt usermod -G autologin,sudo,wheel,lp $USERNAME




###WHEEL

cp /mnt/etc/sudoers /mnt/etc/sudoers.bak && sed -i '82c\ %wheel ALL=(ALL:ALL) ALL' /mnt/etc/sudoers





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

echo -ne "Escolha um Driver Primário : "

read -n1 -s PDRIVER

case $PDRIVER in

"1")

echo "AMDGPU"
sleep 2
echo -e "$(tput sgr0)\n\n"
arch-chroot /mnt pacman -S xf86-video-amdgpu --noconfirm

;;

"2")

echo "ATI"

sleep 2
echo -e "$(tput sgr0)\n\n"
arch-chroot /mnt pacman -S xf86-video-ati --noconfirm

;;


"3")

echo "INTEL"

sleep 2
echo -e "$(tput sgr0)\n\n"
arch-chroot /mnt pacman -S xf86-video-intel --noconfirm

;;

"4")

echo "Nouveau"

sleep 2
echo -e "$(tput sgr0)\n\n"
arch-chroot /mnt pacman -S xf86-video-nouveau --noconfirm

;;

"5")

echo "Nvidia"

sleep 2
echo -e "$(tput sgr0)\n\n"
arch-chroot /mnt pacman -S xf86-video-nvidia --noconfirm

;;

"6")

echo "VMWARE"

sleep 2
echo -e "$(tput sgr0)\n\n"
arch-chroot /mnt pacman -S xf86-video-vmware --noconfirm

esac

echo -e "$(tput sgr0)\n\n"



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

echo -ne "Escolha um Driver Secundário : "

read -n1 -s SDRIVER

case $SDRIVER in

"1")

echo "AMDGPU"
sleep 2
echo -e "$(tput sgr0)\n\n"
arch-chroot /mnt pacman -S xf86-video-amdgpu --noconfirm

;;

"2")

echo "ATI"

sleep 2
echo -e "$(tput sgr0)\n\n"
arch-chroot /mnt pacman -S xf86-video-ati --noconfirm

;;


"3")

echo "INTEL"

sleep 2
echo -e "$(tput sgr0)\n\n"
arch-chroot /mnt pacman -S xf86-video-intel --noconfirm

;;

"4")

echo "Nouveau"

sleep 2
echo -e "$(tput sgr0)\n\n"
arch-chroot /mnt pacman -S xf86-video-nouveau --noconfirm

;;

"5")

echo "Nvidia"

sleep 2
echo -e "$(tput sgr0)\n\n"
arch-chroot /mnt pacman -S xf86-video-nvidia --noconfirm

esac

echo -e "$(tput sgr0)\n\n"





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

echo -e "0 - XFCE"

echo -e "\n"

echo -ne "Escolha uma DE : "
read -n1 -s DE

case $DE in

"1")

echo "Budge"
sleep 2
echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S budgie-desktop gnome-terminal gedit gnome-calculator gnome-calendar gnome-system-monitor nautilus network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
systemctl enable lightdm NetworkManager

;;

"2")

echo "Cinnamon"

sleep 2
echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S cinnamon network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
systemctl enable lightdm NetworkManager

;;

"3")

echo "Deepin"

sleep 2
echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S deepin network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
systemctl enable lightdm NetworkManager

;;

"4")

echo "Gnome"

sleep 2
echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S gnome gnome-tweaks network-manager-applet gdm --noconfirm
systemctl enable gdm NetworkManager

;;

"5")

echo "KDE Plasma (X11)"

sleep 2
echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S plasma konsole sddm dolphin spectacle kcalc kwrite gwenview plasma-nm plasma-pa --noconfirm
systemctl enable sddm NetworkManager

;;

"6")

echo "KDE Plasma (Wayland)"

sleep 2
echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S plasma konsole sddm dolphin spectacle kcalc kwrite gwenview plasma-nm plasma-pa plasma-wayland-session --noconfirm
systemctl enable sddm NetworkManager

;;

"7")

echo "LXDE"

sleep 2
echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S lxde-gtk3 lxtask network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
systemctl enable lightdm NetworkManager

;;

"8")

echo "LXQT"

sleep 2
echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S lxqt lxtask network-manager-applet sddm --noconfirm
systemctl enable sddm NetworkManager

;;

"9")

echo "MATE"

sleep 2
echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S mate mate-extra network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
systemctl enable lightdm NetworkManager

;;

"0")

echo "XFCE"

sleep 2
echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S xfce4 xfce4-screenshooter xfce4-pulseaudio-plugin xfce4-whiskermenu-plugin xarchiver lxtask ristretto mousepad galculator thunar-archive-plugin network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
systemctl enable lightdm NetworkManager

esac


echo -e "$(tput sgr0)\n\n"





###USER DIRS UPDATE

arch-chroot /mnt xdg-user-dirs-update





###GRUB

PASTA_EFI=/sys/firmware/efi
if [ ! -d "$PASTA_EFI" ];then
echo -e "Sistema Legacy"
arch-chroot /mnt grub-install --target=i386-pc /dev/sda --force && grub-mkconfig -o /boot/grub/grub.cfg

else
echo -e "Sistema EFI"
pacman -S efibootmgr --noconfirm
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Arch --removable && grub-mkconfig -o /boot/grub/grub.cfg

fi








###CLONAR O REPOSITORIO DENTRO DO CHROOT

arch-chroot /mnt git clone http://github.com/tdotux/tests





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
