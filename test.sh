#!/usr/bin/env sh



### UTILITARIOS BASICOS

pacman -S dosfstools nano wget --noconfirm




###HOSTNAME

printf '\x1bc';

read -p "Digite o Hostname : " HOSTNAME




###USERNAME

printf '\x1bc';

read -p "Digite o Nome de Usuário : " USERNAME



echo -e "\n\n\n"







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

parted /dev/sda mklabel gpt -s
parted /dev/sda mkpart primary fat32 1MiB 301MiB -s
parted /dev/sda set 1 esp on
mkfs.fat -F32 /dev/sda1
if [ "$filesystem" = "ext4" ];then
mkfs.ext4 -F /dev/sda2
elif [ "$filesystem" = "btrfs|f2fs|xfs" ];then
mkfs.${filesystem,,} -f /dev/sda2
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
mkfs.ext4 -F /dev/sda1
elif [ "$filesystem" = "btrfs|f2fs|xfs" ];then
mkfs.${filesystem,,} -f /dev/sda1
fi

fi



### DRIVER DE VIDEO


printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e 'Escolha um Driver de Vídeo: '
select driver in {AMDGPU,ATI,INTEL,Nouveau,Nvidia,VMWARE};do
	case $driver in
	AMDGPU|ATI|INTEL|Nouveau|Nvidia|VMWARE)
	echo -e "${driver,,}\nOK";;
	*) echo -e "\e[1;38mErro\e[m\nEscolha uma Opção válida.";continue;;
	esac
break;
done





### INTERFACE GRAFICA (DE)


printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e 'Escolha uma Interface Grafica: '
select DE in {Budgie,Cinnamon,Deepin,Gnome,Plasma-X11,Plasma-Wayland,LXDE,LXQT,MATE,XFCE};do
	case $DE in
	Budgie|Cinnamon|Deepin|Gnome|Plasma-X11|Plasma-Wayland|LXDE|LXQT|MATE|XFCE)
	echo -e "${de,,}\nOK";;
	*) echo -e "\e[1;38mErro\e[m\nEscolha uma Opção válida.";continue;;
	esac
break;
done





### KERNEL


printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e 'Escolha um Kernel: '
select kernel in {linux,linux-zen,linux-lts,linux-harneded};do
	case $kernel in
	linux|linux-zen|linux-lts|linux-harneded)
	pacstrap /mnt base btrfs-progs dosfstools e2fsprogs f2fs-tools dosfstools xfsprogs linux-firmware ${kernel,,};;
	*) echo -e "\e[1;38mErro\e[m\nEscolha uma Opção válida.";continue;;
	esac
break;
done
