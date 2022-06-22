#!/bin/bash

devices_list=($(lsblk -d | awk '{print "/dev/" $1}' | grep 'sd\|hd\|vd\|nvme\|mmcblk'))

printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e 'Escolha um Disco para Instalar o Sistema: '
select device in $devices_list; do
echo "$device"
done
