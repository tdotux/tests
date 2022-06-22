#!/bin/bash


devices_list=$(lsblk -nd --output NAME,SIZE)

devices_select=$(lsblk -d | grep 'sd\|hd\|vd\|nvme\|mmcblk')

printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e "$devices_list"
echo -e 'Escolha um Disco: '
select device in $devices_select; do
echo "$device";
break

done

