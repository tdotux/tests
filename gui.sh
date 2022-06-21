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



### DRIVER DE VIDEO PRIMÁRIO


primaryvideodriver=$(whiptail --title "Driver de Vídeo Primário" --menu "Escolha um Driver de Vídeo Primário" 25 78 10 \
"AMDGPU" " -  AMD Recentes - A Partir das RX" \
"ATI" " -  AMD Antigas - Até as R9" \
"INTEL" " -  Intel a partir das HD Graphics" \
"NOUVEAU" " -  Nvidia Open Source" \
"NVIDIA" " -  Nvidia Proprietário" \
"VMWARE" " -  VMWARE e VIRTUALBOX" \
"OUTROS" " -  PARA OUTROS DISPOSITIVOS" 3>&1 1>&2 2>&3)



### DRIVER DE VIDEO SECUNDÁRIO


secundaryvideodriver=$(whiptail --title "Driver de Vídeo Secundário" --menu "Escolha um Driver de Vídeo Secundário" 25 78 10 \
"NENHUM" " -  Não instalar nenhum driver secundário" \
"AMDGPU" " -  AMD Recentes - A Partir das RX" \
"ATI" " -  AMD Antigas - Até as R9" \
"INTEL" " -  Intel a partir das HD Graphics" \
"NOUVEAU" " -  Nvidia Open Source" \
"NVIDIA" " -  Nvidia Proprietário" \
"VMWARE" " -  VMWARE e VIRTUALBOX" \
"OUTROS" " -  PARA OUTROS DISPOSITIVOS" 3>&1 1>&2 2>&3)





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




### SET-HOSTNAME-AND-CONFIGURE-HOSTS

echo -e "$hostname" > /mnt/etc/hostname

echo -e "127.0.0.1 localhost.localdomain localhost\n::1 localhost.localdomain localhost\n127.0.1.1 $hostname.localdomain $hostname" | arch-chroot /mnt tee /etc/hosts




##### INSIDE CHROOT #####



###AJUSTAR HORA AUTOMATICAMENTE

arch-chroot /mnt timedatectl set-ntp true


###FUSO HORÁRIO

arch-chroot /mnt "ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime"
arch-chroot /mnt "sed -i '/#NTP=/d' /etc/systemd/timesyncd.conf"

arch-chroot /mnt "sed -i 's/#Fallback//' /etc/systemd/timesyncd.conf"
arch-chroot /mnt "echo \"FallbackNTP=0.pool.ntp.org 1.pool.ntp.org 0.fr.pool.ntp.org\" >> /etc/systemd/timesyncd.conf"
arch-chroot /mnt "systemctl enable systemd-timesyncd.service"



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

arch-chroot /mnt ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && arch-chroot /mnt hwclock --systohc


arch-chroot /mnt timedatectl set-timezone America/Sao_Paulo



###LOCALE

mv /mnt/etc/locale.gen /mnt/etc/locale.gen.bak && echo -e 'pt_BR.UTF-8 UTF-8' | tee /mnt/etc/locale.gen && arch-chroot /mnt locale-gen && echo -e 'LANG=pt_BR.UTF-8' | tee /mnt/etc/locale.conf




###GRUPOS

arch-chroot /mnt groupadd -r autologin

arch-chroot /mnt groupadd -r sudo

arch-chroot /mnt usermod -G autologin,sudo,wheel,lp $USERNAME




###WHEEL

cp /mnt/etc/sudoers /mnt/etc/sudoers.bak && sed -i '82c\ %wheel ALL=(ALL:ALL) ALL' /mnt/etc/sudoers




###SET-PRIMARY-VIDEO-DRIVER

if [ "$primaryvideodriver" = "AMDGPU" ];then
arch-chroot /mnt pacman -S xf86-video-amdgpu --noconfirm

elif [ "$primaryvideodriver" = "ATI" ];then
arch-chroot /mnt pacman -S xf86-video-ati --noconfirm

elif [ "$primaryvideodriver" = "INTEL" ];then
arch-chroot /mnt pacman -S xf86-video-intel --noconfirm

elif [ "$primaryvideodriver" = "NOUVEAU" ];then
arch-chroot /mnt pacman -S xf86-video-nouveau --noconfirm

elif [ "$primaryvideodriver" = "NVIDIA" ];then
arch-chroot /mnt pacman -S xf86-video-nvidia --noconfirm

elif [ "$primaryvideodriver" = "VMWARE" ];then
arch-chroot /mnt pacman -S xf86-video-vmware --noconfirm

elif [ "$primaryvideodriver" = "OUTROS" ];then
arch-chroot /mnt pacman -S xf86-video-dummy xf86-video-fbdev xf86-video-qxl xf86-video-vesa xf86-video-voodoo --noconfirm

fi


###SET-SECUNDARY-VIDEO-DRIVER



if [ "$secundaryvideodriver" = "NENHUM" ];then
echo "NENHUM"

elif [ "$secundaryvideodriver" = "AMDGPU" ];then
arch-chroot /mnt pacman -S xf86-video-amdgpu --noconfirm

elif [ "$secundaryvideodriver" = "ATI" ];then
arch-chroot /mnt pacman -S xf86-video-ati --noconfirm

elif [ "$secundaryvideodriver" = "INTEL" ];then
arch-chroot /mnt pacman -S xf86-video-intel --noconfirm

elif [ "$secundaryvideodriver" = "NOUVEAU" ];then
arch-chroot /mnt pacman -S xf86-video-nouveau --noconfirm

elif [ "$secundaryvideodriver" = "NVIDIA" ];then
arch-chroot /mnt pacman -S xf86-video-nvidia --noconfirm

elif [ "$secundaryvideodriver" = "VMWARE" ];then
arch-chroot /mnt pacman -S xf86-video-vmware --noconfirm

elif [ "$secundaryvideodriver" = "OUTROS" ];then
arch-chroot /mnt pacman -S xf86-video-dummy xf86-video-fbdev xf86-video-qxl xf86-video-vesa xf86-video-voodoo --noconfirm

fi




###SET-DESKTOP-ENVIRONMENT



if [ "$de" = "Budgie" ];then

echo "Budge"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S budgie-desktop gnome-terminal gedit gnome-calculator gnome-calendar gnome-system-monitor nautilus network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
arch-chroot /mnt systemctl enable lightdm NetworkManager



elif [ "$de" = "Cinnamon" ];then

echo "Cinnamon"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S cinnamon network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
arch-chroot /mnt systemctl enable lightdm NetworkManager



elif [ "$de" = "Deepin" ];then

echo "Deepin"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S deepin network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
arch-chroot /mnt systemctl enable lightdm NetworkManager



elif [ "$de" = "Gnome" ];then

echo "Gnome"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S gnome gnome-tweaks network-manager-applet gdm --noconfirm
arch-chroot /mnt systemctl enable gdm NetworkManager

elif [ "$de" = "Plasma-X11" ];then

echo "Plasma-X11"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S plasma konsole sddm dolphin spectacle kcalc kwrite gwenview plasma-nm plasma-pa --noconfirm
arch-chroot /mnt systemctl enable sddm NetworkManager


elif [ "$de" = "Plasma-Wayland" ];then

echo "Plasma-Wayland"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S plasma konsole sddm dolphin spectacle kcalc kwrite gwenview plasma-nm plasma-pa plasma-wayland-session --noconfirm
arch-chroot /mnt systemctl enable sddm NetworkManager

elif [ "$de" = "LXDE" ];then

echo "LXDE"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S lxde-gtk3 lxtask network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
arch-chroot /mnt systemctl enable lightdm NetworkManager

elif [ "$de" = "LXQT" ];then

echo "LXQT"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S lxqt lxtask network-manager-applet sddm --noconfirm
arch-chroot /mnt systemctl enable sddm NetworkManager

elif [ "$de" = "MATE" ];then

echo "MATE"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S mate mate-extra network-manager-applet lightdm lightdm-gtk-greeter --noconfirm

arch-chroot /mnt systemctl enable lightdm NetworkManager



elif [ "$de" = "XFCE" ];then

echo "XFCE"

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
