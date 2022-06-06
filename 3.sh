#!/usr/bin/env sh

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

read -p "Digite a Senha de Usuário : " USERPASSWORD

echo -e "$USERPASSWORD\n$USERPASSWORD" | arch-chroot /mnt passwd $USERNAME



### SENHA DE ROOT



echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e "Senha de Root (Administrador)"

echo -e "\n"

read -p "Digite a Senha de Root : " ROOTPASSWORD

echo -e "$ROOTPASSWORD\n$ROOTPASSWORD" | arch-chroot /mnt passwd
