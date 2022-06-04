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

arch-chroot /mnt pacman -Sy nano wget pacman-contrib reflector sudo grub --noconfirm



###MIRRORS

cp /mnt/etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist.bak && curl -s "https://archlinux.org/mirrorlist/?country=BR&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - | tee /mnt/etc/pacman.d/mirrorlist && sed -i '/br.mirror.archlinux-br.org/d' /mnt/etc/pacman.d/mirrorlist




###PARALLEL DOWNLOADS

cp /mnt/etc/pacman.conf /mnt/etc/pacman.conf.bak && sed -i '37c\ParallelDownloads = 16' /mnt/etc/pacman.conf && arch-chroot /mnt pacman -Syyyuuu --noconfirm




###MULTILIB

sed -i '93c\[multilib]' /mnt/etc/pacman.conf && sed -i '94c\Include = /etc/pacman.d/mirrorlist' /mnt/etc/pacman.conf && arch-chroot /mnt pacman -Syyyuu --noconfirm




###FUSO HORARIO

ln -sf /mnt/usr/share/zoneinfo/America/Sao_Paulo /mnt/etc/localtime && arch-chroot /mnt hwclock --systohc




###LOCALE

mv /mnt/etc/locale.gen /mnt/etc/locale.gen.bak && echo -e 'pt_BR.UTF-8 UTF-8' | tee /mnt/etc/locale.gen && arch-chroot locale-gen && echo -e 'LANG=pt_BR.UTF-8' | tee /mnt/etc/locale.conf





### NOME DE USUARIO


arch-chroot /mnt useradd -m $USERNAME




### SENHA DE USUARIO


echo -e "$USERPASSWORD\n$USERPASSWORD" | passwd $USERNAME



### SENHA DE ROOT


echo -e "$ROOTPASSWORD\n$ROOTPASSWORD" | passwd




###GRUPOS

arch-chroot /mnt groupadd -r autologin

arch-chroot /mnt archgroupadd -r sudo

arch-chroot /mnt usermod -G autologin,sudo,wheel,lp $USERNAME

















###CLONAR O REPOSITORIO DENTRO DO CHROOT

arch-chroot /mnt git clone http://github.com/tdotux/tests



###EXECUTAR O SCRIPT DE POS INSTALAÇÃO DENTRO DO CHROOT

arch-chroot /mnt sh /tests/epi-script.sh



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
