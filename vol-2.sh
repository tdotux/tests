#!/bin/bash
printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e 'Escolha um Driver de Vídeo: '
select drive in {AMDGPU,ATI,INTEL,Nouveau,Nvidia,VMWARE};do
	case $drive in
	AMDGPU|ATI|INTEL|Nouveau|Nvidia|VMWARE)
	echo -e "Opção: ${drive,,}\nexecute:\npacman -S xf86-video-${drive,,}";;
	*) echo -e "\e[1;38mErro\e[m\nEscolha uma Opção válida.";continue;;
	esac
break;
done 
