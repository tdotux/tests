#!/bin/sh


read -p "Digite o Nome da GPU : " GPUMODEL

if [ "$GPUMODEL" = "intel" ];then
     sudo pacman -S xf86-video-intel                

elif [ "$GPUMODEL" = "amd" ];then
     sudo pacman -S xf86-video-amdgpu xf86-video-ati

elif [ "$GPUMODEL" = "nvidia" ];then
     sudo pacman -S xf86-video-nouveau
fi

