#!/bin/bash

echo -ne "Escolha uma DE : "
read -n1 -s DE

case $DE in

"1")

echo "Budge"
sleep 2
pacman -S budgie-desktop gnome-terminal gedit gnome-calculator gnome-calendar gnome-system-monitor nautilus network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
systemctl enable lightdm NetworkManager

;;

"2")

echo "Cinnamon"

sleep 2

pacman -S cinnamon network-manager-applet lightdm lightdm-gtk-greeter --noconfirm

systemctl enable lightdm NetworkManager

;;

"3")

echo "Deepin"

sleep 2

pacman -S deepin network-manager-applet lightdm lightdm-gtk-greeter --noconfirm

systemctl enable lightdm NetworkManager

"4")

echo "Gnome"

sleep 2

pacman -S gnome gnome-tweaks network-manager-applet gdm --noconfirm

systemctl enable gdm NetworkManager


"5")

echo "KDE Plasma (X11)"

sleep 2

pacman -S plasma konsole sddm dolphin spectacle kcalc kwrite gwenview plasma-nm plasma-pa --noconfirm

systemctl enable sddm NetworkManager

"6")

echo "KDE Plasma (Wayland)"

sleep 2

pacman -S plasma konsole sddm dolphin spectacle kcalc kwrite gwenview plasma-nm plasma-pa plasma-wayland-session --noconfirm

systemctl enable sddm NetworkManager

"7")

echo "LXDE"

sleep 2

pacman -S lxde-gtk3 lxtask network-manager-applet lightdm lightdm-gtk-greeter --noconfirm

systemctl enable lightdm NetworkManager

"8")

echo "LXQT"

sleep 2

pacman -S lxqt lxtask network-manager-applet sddm --noconfirm

systemctl enable sddm NetworkManager

"9")

echo "MATE"

sleep 2

pacman -S mate mate-extra network-manager-applet lightdm lightdm-gtk-greeter --noconfirm

systemctl enable lightdm NetworkManager

"0")

echo "XFCE"

sleep 2

pacman -S xfce4 xfce4-screenshooter xfce4-pulseaudio-plugin xfce4-whiskermenu-plugin lxtask ristretto mousepad galculator thunar-archive-plugin network-manager-applet lightdm lightdm-gtk-greeter --noconfirm

systemctl enable lightdm NetworkManager



*)
		echo "Opção Inválida"
	;;
esac

