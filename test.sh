#!/bin/bash


devices_list=$(lsblk -nd --output NAME,SIZE | grep 'sd\|hd\|vd\|nvme\|mmcblk')


printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e 'Escolha um Disco: '
select device in $devices_list; do
echo "$device";
break

done
