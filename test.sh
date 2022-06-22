#!/usr/bin/env sh



###SELECIONAR DISCO PARA INSTALAR O SISTEMA


devices_list=($(lsblk -d | awk '{print "/dev/" $1}' | grep 'sd\|hd\|vd\|nvme\|mmcblk'))

printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e 'Escolha um Disco: '
select installdisk in $devices_list; do
echo "$installdisk";
break
done



### SISTEMA DE ARQUIVOS


printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e 'Escolha um Sistema de Arquivos: '
select filesystem in {ext4,btrfs,f2fs,xfs};do
	case $filesystem in
	
	ext4)
	echo "ext4";;
	
	btrfs|f2fs|xfs)
	echo "${filesystem,,}";;
		
	*) echo -e "\e[1;38mErro\e[m\nEscolha uma Opção válida.";continue;;
	esac
break;
done 



###DETECTAR UEFI OU LEGACY

PASTA_EFI=/sys/firmware/efi

if [ -d "$PASTA_EFI" ];then

echo -e "Sistema EFI"

parted ${installdisk,,} mklabel gpt -s
parted ${installdisk,,} mkpart primary fat32 1MiB 301MiB -s
parted ${installdisk,,} set 1 esp on
mkfs.fat -F32 ${installdisk,,}1

if [ "$filesystem" = "ext4" ];then
parted /dev/sda mkpart primary ext4 301MiB 100% -s
mkfs.ext4 -F /dev/sda2
elif [ "$filesystem" = "btrfs" ];then
parted /dev/sda mkpart primary ext4 301MiB 100% -s
mkfs.btrfs -f /dev/sda2
elif [ "$filesystem" = "f2fs" ];then
parted /dev/sda mkpart primary ext4 301MiB 100% -s
mkfs.f2fs -f /dev/sda2
elif [ "$filesystem" = "xfs" ];then
parted /dev/sda mkpart primary ext4 301MiB 100% -s
mkfs.xfs -f /dev/sda2
fi

mount /dev/sda2 /mnt
mkdir /mnt/boot/
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

else

echo -e "Sistema Legacy"


parted /dev/sda mklabel msdos -s
parted /dev/sda mkpart primary ext4 1MiB 100% -s
parted /dev/sda set 1 boot on
if [ "$filesystem" = "ext4" ];then
parted /dev/sda mkpart primary ext4 301MiB 100% -s
mkfs.ext4 -F /dev/sda1
elif [ "$filesystem" = "btrfs" ];then
parted /dev/sda mkpart primary ext4 301MiB 100% -s
mkfs.btrfs -f /dev/sda1
elif [ "$filesystem" = "f2fs" ];then
parted /dev/sda mkpart primary ext4 301MiB 100% -s
mkfs.f2fs -f /dev/sda1
elif [ "$filesystem" = "xfs" ];then
parted /dev/sda mkpart primary ext4 301MiB 100% -s
mkfs.xfs -f /dev/sda1
fi

fi
