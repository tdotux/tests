#!/bin/bash

###UTILITARIOS BASICOS

pacman -Sy nano pacman-contrib reflector sudo grub efibootmgr --noconfirm

cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak && curl -s "https://archlinux.org/mirrorlist/?country=BR&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - | tee /etc/pacman.d/mirrorlist && sed -i '/br.mirror.archlinux-br.org/d' /etc/pacman.d/mirrorlist

cp /etc/pacman.conf /etc/pacman.conf.bak && sudo sed -i '37c\ParallelDownloads = 16' /etc/pacman.conf && pacman -Syyyuuu --noconfirm

sed -i '93c\[multilib]' /etc/pacman.conf && sudo sed -i '94c\Include = /etc/pacman.d/mirrorlist' /etc/pacman.conf && pacman -Syyyuu --noconfirm

ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && hwclock --systohc

mv /etc/locale.gen /etc/locale.gen.bak && echo -e 'pt_BR.UTF-8 UTF-8' | tee /etc/locale.gen && locale-gen && echo -e 'LANG=pt_BR.UTF-8' | tee /etc/locale.conf



###HOSTNAME

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\nHostname\n"

read -p "Digite o Hostname : " HOST
echo -e "$(tput sgr0)\n\n"
echo "$HOST" | sudo tee /etc/hostname


###HOSTS

echo -e "127.0.0.1 localhost.localdomain localhost\n::1 localhost.localdomain localhost\n127.0.1.1 $HOST.localdomain $HOST" | sudo tee /etc/hosts



###SENHA ROOT

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\nSenha de Root\n"

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\nDigite a Senha de Root\n"

echo "$(tput sgr0)"

passwd

echo -e "\n\n"



###USERNAME

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\nUsername\n"

read -p "Digite o Nome de Usuário : " USERNAME

echo -e "$(tput sgr0)\n\n"

useradd -m $USERNAME



###SENHA DO USUARIO

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\nSenha do Usuário\n"

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\nDigite a Senha do Usuário\n"

passwd $USERNAME

echo -e "$(tput sgr0)\n\n"



###GRUPOS

groupadd -r autologin && groupadd -r sudo

usermod -G autologin,sudo,wheel,lp $USERNAME



###WHEEL

cp /etc/sudoers /etc/sudoers.bak && sed -i '82c\ %wheel ALL=(ALL:ALL) ALL' /etc/sudoers



###GRUB

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Arch --removable && grub-mkconfig -o /boot/grub/grub.cfg



###DRIVER DE VIDEO

if [  $(lspci | grep -c Radeon) = 1 ]; then
pacman -S xf86-video-amdgpu xf86-video-ati --noconfirm

elif [  $(lspci | grep -c Intel) = 1 ]; then
pacman -S xf86-video-intel --noconfirm

elif [  $(lspci | grep -c GeForce) = 1 ]; then
pacman -S xf86-video-nouveau --noconfirm

elif [  $(lspci | grep -c VMware) = 1 ]; then
pacman -S xf86-video-vmware xf86-input-vmmouse --noconfirm

fi



###PACOTES

pacman -S xorg-server xorg-xinit xterm linux-zen-headers networkmanager network-manager-applet xfce4 xfce4-screenshooter xfce4-pulseaudio-plugin xfce4-whiskermenu-plugin ristretto mousepad galculator xarchiver file-roller tar gzip bzip2 zip unzip unrar p7zip thunar-archive-plugin lightdm lightdm-gtk-greeter pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs --noconfirm



###USER DIRS UPDATE

xdg-user-dirs-update



###SYSTEMCTL

systemctl enable NetworkManager lightdm


exit
