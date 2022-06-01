#!/bin/sh


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

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e "### Hostname ###"

echo -e "\n\n"

read -p "Digite o Hostname : " HOST
echo "$HOST" | sudo tee /etc/hostname

echo -e "$(tput sgr0)\n\n"



###HOSTS

echo -e "127.0.0.1 localhost.localdomain localhost\n::1 localhost.localdomain localhost\n127.0.1.1 $HOST.localdomain $HOST" | sudo tee /etc/hosts



###USERNAME

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e "Nome de Usuário (Username)"

echo -e "\n\n"

read -p "Digite o Nome de Usuário : " USERNAME

useradd -m $USERNAME

echo -e "$(tput sgr0)\n\n"



###SENHA DO USUARIO

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e "Senha do Usuário"

echo -e "\n"

echo -e "Digite a Senha do Usuário"

passwd $USERNAME

echo -e "$(tput sgr0)\n\n"



###SENHA ROOT

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e "### Senha de Root ###"

echo -e "\n"

echo -e "Digite a Senha de Root"

passwd

echo -e "$(tput sgr0)\n\n"



###GRUPOS

groupadd -r autologin && groupadd -r sudo

usermod -G autologin,sudo,wheel,lp $USERNAME



###WHEEL

cp /etc/sudoers /etc/sudoers.bak && sed -i '82c\ %wheel ALL=(ALL:ALL) ALL' /etc/sudoers



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



###DRIVER DE VIDEO

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e "#### DRIVER DE VIDEO PRIMARIO ####"

echo -e "\n\n" 

echo -e "1 - AMDGPU"

echo -e "\n" 

echo -e "2 - ATI"

echo -e "\n" 

echo -e "3 - Intel"

echo -e "\n" 

echo -e "4 - Nouveau (Nvidia Open Source)"

echo -e "\n"

echo -e "5 - Nvidia (Proprietário)"

echo -e "\n" 

echo -e "6 - VMWARE"

echo -e "\n\n" 

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

echo -e "\n\n" 

echo -e "1 - AMDGPU"

echo -e "\n" 

echo -e "2 - ATI"

echo -e "\n" 

echo -e "3 - Intel"

echo -e "\n" 

echo -e "4 - Nouveau (Nvidia Open Source)"

echo -e "\n"

echo -e "5 - Nvidia (Proprietário)"

echo -e "\n\n" 

echo -e "Pressione Enter para pular esta etapa"

echo -e "ou"

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



###PACOTES PADRÃO

pacman -S xorg-server xorg-xinit xterm linux-zen-headers networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm



###INTERFACE GRÁFICA

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e "#### INTERFACE GRAFICA (DE) ####"

echo -e "1 ==>> Budgie\n2 ==>> Cinnamon\n3 ==>> Deepin\n4 ==>> GNOME\n5 ==>> KDE Plasma (X11)\n6 ==>> KDE Plasma (Wayland)\n7 ==>> LXDE\n8 ==>> LXQt\n9 ==>> MATE\n0 ==>> XFCE"

echo -e "\n\n"

echo -ne "Escolha uma DE : "
read -n1 -s DE

case $DE in

"1")

echo "Budge"
sleep 2
echo -e "$(tput sgr0)\n\n"
pacman -S budgie-desktop gnome-terminal gedit gnome-calculator gnome-calendar gnome-system-monitor nautilus network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
systemctl enable lightdm NetworkManager

;;

"2")

echo "Cinnamon"

sleep 2
echo -e "$(tput sgr0)\n\n"
pacman -S cinnamon network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
systemctl enable lightdm NetworkManager

;;

"3")

echo "Deepin"

sleep 2
echo -e "$(tput sgr0)\n\n"
pacman -S deepin network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
systemctl enable lightdm NetworkManager

;;

"4")

echo "Gnome"

sleep 2
echo -e "$(tput sgr0)\n\n"
pacman -S gnome gnome-tweaks network-manager-applet gdm --noconfirm
systemctl enable gdm NetworkManager

;;

"5")

echo "KDE Plasma (X11)"

sleep 2
echo -e "$(tput sgr0)\n\n"
pacman -S plasma konsole sddm dolphin spectacle kcalc kwrite gwenview plasma-nm plasma-pa --noconfirm
systemctl enable sddm NetworkManager

;;

"6")

echo "KDE Plasma (Wayland)"

sleep 2
echo -e "$(tput sgr0)\n\n"
pacman -S plasma konsole sddm dolphin spectacle kcalc kwrite gwenview plasma-nm plasma-pa plasma-wayland-session --noconfirm
systemctl enable sddm NetworkManager

;;

"7")

echo "LXDE"

sleep 2
echo -e "$(tput sgr0)\n\n"
pacman -S lxde-gtk3 lxtask network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
systemctl enable lightdm NetworkManager

;;

"8")

echo "LXQT"

sleep 2
echo -e "$(tput sgr0)\n\n"
pacman -S lxqt lxtask network-manager-applet sddm --noconfirm
systemctl enable sddm NetworkManager

;;

"9")

echo "MATE"

sleep 2
echo -e "$(tput sgr0)\n\n"
pacman -S mate mate-extra network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
systemctl enable lightdm NetworkManager

;;

"0")

echo "XFCE"

sleep 2
echo -e "$(tput sgr0)\n\n"
pacman -S xfce4 xfce4-screenshooter xfce4-pulseaudio-plugin xfce4-whiskermenu-plugin xarchiver lxtask ristretto mousepad galculator thunar-archive-plugin network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
systemctl enable lightdm NetworkManager

esac


echo -e "$(tput sgr0)\n\n"



###USER DIRS UPDATE

xdg-user-dirs-update



###SWAP FILE

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e "Swap"

echo -e "Escolha o Tamanho do Arquivo de Swap"

echo -e "PARA MAQUINAS COM POUCA RAM (ATE 8GB) RECOMENDO 4GB DE SWAP

echo -e "ACIMA DE 8GB DE RAM, ESCOLHA 2GB DE SWAP"

echo -e "DIGITE O NUMERO CORRESPONDENTE A QUANTIDADE DE SWAP"

echo -e "2 - 2GB"

echo -e "4 - 4GB"

echo -ne "Escolha uma quantidade de SWAP : "
read -n1 -s SWAP

case $SWAP in

"2")

echo "2GB"
sleep 2
echo -e "$(tput sgr0)\n\n"
fallocate -l 2G /swapfile && chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile && cp /etc/fstab /etc/fstab.bak && echo -e '/swapfile   none    swap    sw    0   0' | tee -a /etc/fstab


;;

"4")

echo "4GB"
sleep 2
echo -e "$(tput sgr0)\n\n"
fallocate -l 4G /swapfile && chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile && cp /etc/fstab /etc/fstab.bak && echo -e '/swapfile   none    swap    sw    0   0' | tee -a /etc/fstab


esac


echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\n####INSTALAÇÃO CONCLUÍDA!!!\n"
