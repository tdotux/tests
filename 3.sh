#!/usr/bin/env sh



###USERNAME


echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"

echo -e 'Nome de Usuário (Username)'

echo -e '\n'

echo -ne 'Digite o Nome do Usuário : "

read USERNAME

arch-chroot /mnt useradd -m $USERNAME

echo -e '$(tput sgr0)'
