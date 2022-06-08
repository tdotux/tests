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

echo -ne "Escolha um Sistema de Arquivos : " ; read ARQUIVOS



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

read KERNEL



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


###USERNAME

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e "Nome de Usuário (Username)"

echo -e "\n"

read -p "Digite o Nome de Usuário : " USERNAME

arch-chroot /mnt useradd -m $USERNAME

echo -e "$(tput sgr0)"


###SENHA DO USUARIO

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e "Senha do Usuário"

echo -e "\n"

read -sp "Digite a Senha de Usuário : " USERPASSWORD

echo -e "$USERPASSWORD\n$USERPASSWORD" | arch-chroot /mnt passwd $USERNAME



### SENHA DE ROOT



echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e "Senha de Root (Administrador)"

echo -e "\n"

read -sp "Digite a Senha de Root : " ROOTPASSWORD

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
