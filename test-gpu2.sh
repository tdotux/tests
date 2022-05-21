#!/bin/sh

GPUMODEL=$(sudo lshw -C video | grep "vendor")


if [ "$GPUMODEL" = "vendor: Intel Corporation" ];then
     sudo pacman -S xf86-video-intel

elif [ "$GPUMODEL" = "amd" ];then
     sudo pacman -S xf86-video-amdgpu xf86-video-ati

elif [ "$GPUMODEL" = "nvidia" ];then
     sudo pacman -S xf86-video-nouveau
fi

