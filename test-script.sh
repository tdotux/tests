#!/bin/bash

pacman -Sy nano pacman-contrib reflector sudo grub efibootmgr --noconfirm

cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak && curl -s "https://archlinux.org/mirrorlist/?country=BR&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - | tee /etc/pacman.d/mirrorlist && sed -i '/br.mirror.archlinux-br.org/d' /etc/pacman.d/mirrorlist

cp /etc/pacman.conf /etc/pacman.conf.bak && sudo sed -i '37c\ParallelDownloads = 16' /etc/pacman.conf && pacman -Syyyuuu --noconfirm

sed -i '93c\[multilib]' /etc/pacman.conf && sudo sed -i '94c\Include = /etc/pacman.d/mirrorlist' /etc/pacman.conf && pacman -Syyyuu --noconfirm

ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && hwclock --systohc

mv /etc/locale.gen /etc/locale.gen.bak && echo -e 'pt_BR.UTF-8 UTF-8' | tee /etc/locale.gen && locale-gen && echo -e 'LANG=pt_BR.UTF-8' | tee /etc/locale.conf



###HOSTNAME

read -p "Digite o Hostname : " HOST
echo
echo "$HOST" | sudo tee /etc/hostname


###SENHA ROOT

passwd


###USERNAME

read -p "Digite o Nome de Usuário : " USERNAME
echo
useradd -m $USERNAME


###SENHA DO USUARIO

passwd $USUARIO


###GRUPOS

groupadd -r autologin && groupadd -r sudo

usermod -G autologin,sudo,wheel,lp $USUARIO


###WHEEL

cp /etc/sudoers /etc/sudoers.bak && sed -i '82c\ %wheel ALL=(ALL:ALL) ALL' /etc/sudoers


###GRUB

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Arch --removable && grub-mkconfig -o /boot/grub/grub.cfg


###PACOTES

pacman -S xorg-server xorg-xinit xterm xf86-video-vesa xf86-video-vmware xf86-input-vmmouse networkmanager network-manager-applet xfce4 xfce4-screenshooter xfce4-pulseaudio-plugin xfce4-whiskermenu-plugin ristretto mousepad galculator xarchiver file-roller tar gzip bzip2 zip unzip unrar p7zip thunar-archive-plugin lightdm lightdm-gtk-greeter pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs --noconfirm

###USER DIRS UPDATE

xdg-user-dirs-update


###SYSTEMCTL

systemctl enable NetworkManager lightdm


exit
