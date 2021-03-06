#!/usr/bin/env sh


###AJUSTAR HORA AUTOMATICAMENTE

timedatectl set-ntp true



###UTILITARIOS BASICOS

pacman -Sy nano wget pacman-contrib reflector sudo grub --noconfirm



###MIRRORS

cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak && curl -s "https://archlinux.org/mirrorlist/?country=BR&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - | tee /etc/pacman.d/mirrorlist && sed -i '/br.mirror.archlinux-br.org/d' /etc/pacman.d/mirrorlist



###PARALLEL DOWNLOADS

cp /etc/pacman.conf /etc/pacman.conf.bak && sudo sed -i '37c\ParallelDownloads = 16' /etc/pacman.conf && pacman -Syyyuuu --noconfirm



###MULTILIB

sed -i '93c\[multilib]' /etc/pacman.conf && sudo sed -i '94c\Include = /etc/pacman.d/mirrorlist' /etc/pacman.conf && pacman -Syyyuu --noconfirm



###FUSO HORARIO

ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && hwclock --systohc



###LOCALE

mv /etc/locale.gen /etc/locale.gen.bak && echo -e 'pt_BR.UTF-8 UTF-8' | tee /etc/locale.gen && locale-gen && echo -e 'LANG=pt_BR.UTF-8' | tee /etc/locale.conf



###HOSTNAME

echo "$HOST" | sudo tee /etc/hostname

echo -e "$(tput sgr0)"



###HOSTS

echo -e "127.0.0.1 localhost.localdomain localhost\n::1 localhost.localdomain localhost\n127.0.1.1 $HOSTNAME.localdomain $HOSTNAME" | sudo tee /etc/hosts



###USERNAME

useradd -m $USERNAME


###SENHA DO USUARIO

passwd $USERNAME



###SENHA ROOT


passwd



###GRUPOS

groupadd -r autologin && groupadd -r sudo

usermod -G autologin,sudo,wheel,lp $USERNAME



###WHEEL

cp /etc/sudoers /etc/sudoers.bak && sed -i '82c\ %wheel ALL=(ALL:ALL) ALL' /etc/sudoers





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
pacman -S xf86-video-amdgpu --noconfirm

;;

"2")

echo "ATI"

sleep 2
echo -e "$(tput sgr0)\n\n"
pacman -S xf86-video-ati --noconfirm

;;


"3")

echo "INTEL"

sleep 2
echo -e "$(tput sgr0)\n\n"
pacman -S xf86-video-intel --noconfirm

;;

"4")

echo "Nouveau"

sleep 2
echo -e "$(tput sgr0)\n\n"
pacman -S xf86-video-nouveau --noconfirm

;;

"5")

echo "Nvidia"

sleep 2
echo -e "$(tput sgr0)\n\n"
pacman -S xf86-video-nvidia --noconfirm

;;

"6")

echo "VMWARE"

sleep 2
echo -e "$(tput sgr0)\n\n"
pacman -S xf86-video-vmware --noconfirm

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
pacman -S xf86-video-amdgpu --noconfirm

;;

"2")

echo "ATI"

sleep 2
echo -e "$(tput sgr0)\n\n"
pacman -S xf86-video-ati --noconfirm

;;


"3")

echo "INTEL"

sleep 2
echo -e "$(tput sgr0)\n\n"
pacman -S xf86-video-intel --noconfirm

;;

"4")

echo "Nouveau"

sleep 2
echo -e "$(tput sgr0)\n\n"
pacman -S xf86-video-nouveau --noconfirm

;;

"5")

echo "Nvidia"

sleep 2
echo -e "$(tput sgr0)\n\n"
pacman -S xf86-video-nvidia --noconfirm

esac

echo -e "$(tput sgr0)\n\n"





###SWAP FILE

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

echo -ne "Escolha uma quantidade de SWAP : "

read -n1 -s SWAP

case $SWAP in

"2")

echo "2GB"
sleep 2
echo -e "$(tput sgr0)"

fs=$(blkid -o value -s TYPE /dev/sda2)

if [ "$fs" = "ext4" ];then

fallocate -l 2G /swapfile && chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile && cp /etc/fstab /etc/fstab.bak && echo -e '/swapfile   none    swap    sw    0   0' | tee -a /etc/fstab

elif [ "$fs" = "btrfs" ];then

truncate -s 0 /swapfile && chattr +C /swapfile && btrfs property set /swapfile compression "" && fallocate -l 2G /swapfile && chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile && echo -e '/swapfile none swap defaults 0 0\n' | tee -a /etc/fstab

elif [ "$fs" = "f2fs" ];then

fallocate -l 2G /swapfile && chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile && cp /etc/fstab /etc/fstab.bak && echo -e '/swapfile   none    swap    sw    0   0' | tee -a /etc/fstab

elif [ "$fs" = "xfs" ];then

fallocate -l 2G /swapfile && chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile && cp /etc/fstab /etc/fstab.bak && echo -e '/swapfile   none    swap    sw    0   0' | tee -a /etc/fstab

fi


;;

"4")

echo "4GB"
sleep 2
echo -e "$(tput sgr0)"

fs=$(blkid -o value -s TYPE /dev/sda2)

if [ "$fs" = "ext4" ];then

fallocate -l 4G /swapfile && chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile && cp /etc/fstab /etc/fstab.bak && echo -e '/swapfile   none    swap    sw    0   0' | tee -a /etc/fstab

elif [ "$fs" = "btrfs" ];then

truncate -s 0 /swapfile && chattr +C /swapfile && btrfs property set /swapfile compression "" && fallocate -l 4G /swapfile && chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile && echo -e '/swapfile none swap defaults 0 0\n' | tee -a /etc/fstab

elif [ "$fs" = "f2fs" ];then

fallocate -l 4G /swapfile && chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile && cp /etc/fstab /etc/fstab.bak && echo -e '/swapfile   none    swap    sw    0   0' | tee -a /etc/fstab

elif [ "$fs" = "xfs" ];then

fallocate -l 4G /swapfile && chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile && cp /etc/fstab /etc/fstab.bak && echo -e '/swapfile   none    swap    sw    0   0' | tee -a /etc/fstab

fi

esac



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

pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

pacman -S budgie-desktop gnome-terminal gedit gnome-calculator gnome-calendar gnome-system-monitor nautilus network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
systemctl enable lightdm NetworkManager

;;

"2")

echo "Cinnamon"

sleep 2
echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

pacman -S cinnamon network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
systemctl enable lightdm NetworkManager

;;

"3")

echo "Deepin"

sleep 2
echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

pacman -S deepin network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
systemctl enable lightdm NetworkManager

;;

"4")

echo "Gnome"

sleep 2
echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

pacman -S gnome gnome-tweaks network-manager-applet gdm --noconfirm
systemctl enable gdm NetworkManager

;;

"5")

echo "KDE Plasma (X11)"

sleep 2
echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

pacman -S plasma konsole sddm dolphin spectacle kcalc kwrite gwenview plasma-nm plasma-pa --noconfirm
systemctl enable sddm NetworkManager

;;

"6")

echo "KDE Plasma (Wayland)"

sleep 2
echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

pacman -S plasma konsole sddm dolphin spectacle kcalc kwrite gwenview plasma-nm plasma-pa plasma-wayland-session --noconfirm
systemctl enable sddm NetworkManager

;;

"7")

echo "LXDE"

sleep 2
echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

pacman -S lxde-gtk3 lxtask network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
systemctl enable lightdm NetworkManager

;;

"8")

echo "LXQT"

sleep 2
echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

pacman -S lxqt lxtask network-manager-applet sddm --noconfirm
systemctl enable sddm NetworkManager

;;

"9")

echo "MATE"

sleep 2
echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

pacman -S mate mate-extra network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
systemctl enable lightdm NetworkManager

;;

"0")

echo "XFCE"

sleep 2
echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

pacman -S xfce4 xfce4-screenshooter xfce4-pulseaudio-plugin xfce4-whiskermenu-plugin xarchiver lxtask ristretto mousepad galculator thunar-archive-plugin network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
systemctl enable lightdm NetworkManager

esac


echo -e "$(tput sgr0)\n\n"





###USER DIRS UPDATE

xdg-user-dirs-update





###GRUB

PASTA_EFI=/sys/firmware/efi
if [ ! -d "$PASTA_EFI" ];then
echo -e "Sistema Legacy"
grub-install --target=i386-pc /dev/sda --force && grub-mkconfig -o /boot/grub/grub.cfg

else
echo -e "Sistema EFI"
pacman -S efibootmgr --noconfirm
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Arch --removable && grub-mkconfig -o /boot/grub/grub.cfg

fi





echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e "INSTALAÇÃO CONCLUÍDA!!!!!!"
