#!/usr/bin/bash

###USERNAME

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e "Nome de Usuário (Username)"

echo -e "\n"

read -p "Digite o Nome de Usuário : " USERNAME

arch-chroot /mnt useradd -m $USERNAME

echo -e "$(tput sgr0)"
