#!/bin/env sh

printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e 'Escolha um Sistema de Arquivos: '
select filesystem in {ext4,btrfs,F2fs,xfs};do
	case $filesystem in

	ext4)
	echo -e "${filesystem,,}";;

	btrfs|f2fs|xfs)
	echo -e "${filesystem,,}";;

	*) echo -e "\e[1;38mErro\e[m\nEscolha uma Opção válida.";continue;;
	esac
break;
done


printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e 'Deseja criar uma partição /home separada? '

select separatehome in {Sim,Não};do
    case $separatehome in

    Não)
    echo -e "${separatehome,,}";;


    Sim)
    echo -e "${separatehome,,}";;

    *) echo -e "\e[1;38mErro\e[m\nEscolha uma Opção válida.";continue;;
    esac
break;
done


if [ "$separatehome" = "sim" ];then

printf '\x1bc';
PS3=$'\nSelecione uma dispositivo para a /home';
select homedevice in "$devices"; do
    echo -e "${homedevice,,}"
    done
