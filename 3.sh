#!/usr/bin/env sh



###USERNAME


arch-chroot /mnt bash -c ' echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

arch-chroot /mnt bash -c ' echo -e "Nome de Usuário (Username)"

arch-chroot /mnt bash -c ' echo -e "\n"

arch-chroot /mnt bash -c ' echo -ne "Digite o Nome do Usuário : "

arch-chroot /mnt bash -c ' read USERNAME

arch-chroot /mnt bash -c ' arch-chroot /mnt useradd -m $USERNAME

arch-chroot /mnt bash -c ' echo -e "$(tput sgr0)"



###USER PASSWORD

#echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

#echo -e "Senha do Usuário"

#echo -e "\n"

#echo -ne "Digite a Senha do Usuário : "

#read USERPASSWORD

#arch-chroot /mnt echo -e '$USERPASSWORD\n$USERPASSWORD' | passwd $USERNAME

#echo -e "$(tput sgr0)"



###ROOT PASSWORD

#echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

#echo -e "Senha de Root (Administrador)"

#echo -e "\n"

#echo -ne "Digite a Senha de Root : "

#read ROOTPASSWORD

#arch-chroot /mnt echo -e '$ROOTPASSWORD\n$ROOTPASSWORD' | passwd

#echo -e "$(tput sgr0)"



