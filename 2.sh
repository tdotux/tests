#!/usr/bin/env sh

###USERNAME

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e "Nome de Usuário (Username)"

echo -e "\n"

echo -ne "Digite o Nome do Usuário : "

read -n1 -s USERNAME

echo -e "$(tput sgr0)"



###USER PASSWORD

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e "Senha do Usuário (Username)"

echo -e "\n"

echo -ne "Digite a Senha do Usuário : "

read -n1 -s USERPASSWORD

echo -e "$(tput sgr0)"



###ROOT PASSWORD

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e "Senha de Root (Administrador)"

echo -e "\n"

echo -ne "Digite a Senha de Root : "

read -n1 -s ROOTPASSWORD

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

read -n1 -s KERNEL



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


echo -e "$USERPASSWORD\n$USERPASSWORD" | passwd $USERNAME



### SENHA DE ROOT


echo -e "$ROOTPASSWORD\n$ROOTPASSWORD" | passwd




###GRUPOS

arch-chroot /mnt groupadd -r autologin

arch-chroot /mnt groupadd -r sudo

arch-chroot /mnt usermod -G autologin,sudo,wheel,lp $USERNAME




###WHEEL

cp /mnt/etc/sudoers /mnt/etc/sudoers.bak && sed -i '82c\ %wheel ALL=(ALL:ALL) ALL' /mnt/etc/sudoers

