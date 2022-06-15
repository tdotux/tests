#!/usr/bin/env sh



### UTILITARIOS BASICOS

pacman -S dosfstools nano wget --noconfirm




parted /dev/sda mklabel gpt -s
parted /dev/sda mkpart primary fat32 1MiB 301MiB -s
parted /dev/sda set 1 esp on
mkfs.fat -F32 /dev/sda1




###HOSTNAME

printf '\x1bc';

read -p "Digite o Hostname : " HOSTNAME




###USERNAME

printf '\x1bc';

read -p "Digite o Nome de Usuário : " USERNAME



echo -e "\n\n\n"



###SENHA DO USUARIO

printf '\x1bc';

stty -echo

printf "Digite a Senha de Usuário: "

read USERPASSWORD

stty echo



### SENHA DE ROOT

printf '\x1bc';

stty -echo

printf "Digite a Senha de Root: "

read ROOTPASSWORD

stty echo



###PARTIÇÃO EFI

parted /dev/sda mkpart primary ${filesystem,,} 301MiB 100% -s



### SISTEMA DE ARQUIVOS


printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e 'Escolha um Sistema de Arquivos: '
select filesystem in {ext4,btrfs,F2fs,xfs};do
	case $filesystem in
	
	ext4)
	mkfs.${filesystem,,} -F /dev/sda2;;
	
	btrfs|f2fs|xfs)
	mkfs.${filesystem,,} -f /dev/sda2;;
	
	*) echo -e "\e[1;38mErro\e[m\nEscolha uma Opção válida.";continue;;
	esac
break;
done 



mount /dev/sda2 /mnt
mkdir /mnt/boot/
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi


### DRIVER DE VIDEO


printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e 'Escolha um Driver de Vídeo: '
select drive in {AMDGPU,ATI,INTEL,Nouveau,Nvidia,VMWARE};do
	case $drive in
	AMDGPU|ATI|INTEL|Nouveau|Nvidia|VMWARE)
	echo -e "${drive,,}\nOK";;
	*) echo -e "\e[1;38mErro\e[m\nEscolha uma Opção válida.";continue;;
	esac
break;
done





### INTERFACE GRAFICA (DE)


printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e 'Escolha uma Interface Grafica: '
select DE in {Budgie,Cinnamon,Deepin,Gnome,Plasma-X11,Plasma-Wayland,LXDE,LXQT,MATE,XFCE};do
	case $DE in
	Budgie|Cinnamon|Deepin|Gnome|Plasma-X11|Plasma-Wayland|LXDE|LXQT|MATE|XFCE)
	echo -e "${de,,}\nOK";;
	*) echo -e "\e[1;38mErro\e[m\nEscolha uma Opção válida.";continue;;
	esac
break;
done





### KERNEL


printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e 'Escolha um Kernel: '
select kernel in {linux,linux-zen,linux-lts,linux-harneded};do
	case $kernel in
	linux|linux-zen|linux-lts|linux-harneded)
	pacstrap /mnt base btrfs-progs dosfstools e2fsprogs f2fs-tools dosfstools xfsprogs linux-firmware ${kernel,,};;
	*) echo -e "\e[1;38mErro\e[m\nEscolha uma Opção válida.";continue;;
	esac
break;
done



###FSTAB

genfstab -U /mnt > /mnt/etc/fstab



###### INSIDE CHROOT



###AJUSTAR HORA AUTOMATICAMENTE

arch-chroot /mnt timedatectl set-ntp true



###SINCRONIZAR REPOSITORIOS

arch-chroot /mnt pacman -Syy git --noconfirm


###UTILITARIOS BASICOS

arch-chroot /mnt pacman -Sy nano wget pacman-contrib reflector sudo grub --noconfirm




###ADD-USER


arch-chroot /mnt useradd -m $USERNAME

echo -e "$(tput sgr0)"


###SET-USER-PASSWORD


echo -e "$USERPASSWORD\n$USERPASSWORD" | arch-chroot /mnt passwd $USERNAME



### SET-ROOT-PASSWORD

echo -e "$ROOTPASSWORD\n$ROOTPASSWORD" | arch-chroot /mnt passwd



### SET-HOSTNAME-AND-CONFIGURE-HOSTS

echo -e "$HOSTNAME" > /mnt/etc/hostname

echo -e "127.0.0.1 localhost.localdomain localhost\n::1 localhost.localdomain localhost\n127.0.1.1 $HOSTNAME.localdomain $HOSTNAME" | arch-chroot /mnt tee /etc/hosts




##### INSIDE CHROOT #####



###AJUSTAR HORA AUTOMATICAMENTE

arch-chroot /mnt timedatectl set-ntp true


###FUSO HORÁRIO

arch_chroot "ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime"
arch_chroot "sed -i '/#NTP=/d' /etc/systemd/timesyncd.conf"

arch_chroot "sed -i 's/#Fallback//' /etc/systemd/timesyncd.conf"
arch_chroot "echo \"FallbackNTP=0.pool.ntp.org 1.pool.ntp.org 0.fr.pool.ntp.org\" >> /etc/systemd/timesyncd.conf"
arch_chroot "systemctl enable systemd-timesyncd.service"
arch-chroot ""



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

arch-chroot /mnt pacman -S xf86-video-${drive,,} --noconfirm



###SET-DESKTOP-ENVIRONMENT



if [ "$DE" = "Budgie" ];then

echo "Budge"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S budgie-desktop gnome-terminal gedit gnome-calculator gnome-calendar gnome-system-monitor nautilus network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
arch-chroot /mnt systemctl enable lightdm NetworkManager



elif [ "$DE" = "Cinnamon" ];then

echo "Cinnamon"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S cinnamon network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
arch-chroot /mnt systemctl enable lightdm NetworkManager



elif [ "$DE" = "Deepin" ];then

echo "Deepin"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S deepin network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
arch-chroot /mnt systemctl enable lightdm NetworkManager



elif [ "$DE" = "Gnome" ];then

echo "Gnome"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S gnome gnome-tweaks network-manager-applet gdm --noconfirm
arch-chroot /mnt systemctl enable gdm NetworkManager

elif [ "$DE" = "Plasma-X11" ];then

echo "Plasma-X11"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S plasma konsole sddm dolphin spectacle kcalc kwrite gwenview plasma-nm plasma-pa --noconfirm
arch-chroot /mnt systemctl enable sddm NetworkManager


elif [ "$DE" = "Plasma-Wayland" ];then

echo "Plasma-Wayland"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S plasma konsole sddm dolphin spectacle kcalc kwrite gwenview plasma-nm plasma-pa plasma-wayland-session --noconfirm
arch-chroot /mnt systemctl enable sddm NetworkManager

elif [ "$DE" = "LXDE" ];then

echo "LXDE"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S lxde-gtk3 lxtask network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
arch-chroot /mnt systemctl enable lightdm NetworkManager

elif [ "$DE" = "LXQT" ];then

echo "LXQT"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S lxqt lxtask network-manager-applet sddm --noconfirm
arch-chroot /mnt systemctl enable sddm NetworkManager

elif [ "$DE" = "MATE" ];then

echo "MATE"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S mate mate-extra network-manager-applet lightdm lightdm-gtk-greeter --noconfirm

arch-chroot /mnt systemctl enable lightdm NetworkManager



elif [ "$DE" = "XFCE" ];then

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
