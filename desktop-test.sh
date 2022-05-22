#!/bin/bash

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\n###INTERFACE GRÁFICA (DE)###"

echo -e "\n1  - Budgie\n2  - Cinnamon\n3  - Deepin\n4  - GNOME\n5  - GNOME Flashback\n6  - KDE Plasma (X11)\n7  - KDE Plasma (Wayland)\n8  - LXDE\n9  - LXQt\n10 - MATE\n11 - XFCE\n"

read -p "Digite o Nº Correspondente à Interface Gráfica : " DE

echo -e "$(tput sgr0)\n\n"

if [ $DE = 11 ]; then

sudo pacman -S xfce4 --noconfirm

fi
