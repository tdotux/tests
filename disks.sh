####SELECIONAR DISCO PARA INSTALAÇÃO


devices_list=$(lsblk -dlnp -I 2,3,8,9,22,34,56,57,58,65,66,67,68,69,70,71,72,91,128,129,130,131,132,133,134,135,259 | awk '{print $1,$4,$6,$7}' | column -t)

devices_select=$(lsblk -nd --output NAME | grep 'sd\|hd\|vd\|nvme\|mmcblk')

printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e "Lista de Dispositivos:"
echo -e "\n"
echo -e "Nome - Tam. - Tipo"
echo -e "$devices_list"
echo -e "\n"
echo -e 'Escolha um Disco para Instalar o Sistema: '
select installdisk in $devices_select; do
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

parted $installdisk mklabel gpt -s
parted $installdisk mkpart primary fat32 1MiB 301MiB -s
parted $installdisk set 1 esp on
mkfs.fat -F32 $installdisk1

if [ "$filesystem" = "ext4" ];then
parted $installdisk mkpart primary ext4 301MiB 100% -s
mkfs.ext4 -F $installdisk2
elif [ "$filesystem" = "btrfs" ];then
parted $installdisk mkpart primary ext4 301MiB 100% -s
mkfs.btrfs -f $installdisk2
elif [ "$filesystem" = "f2fs" ];then
parted $installdisk mkpart primary ext4 301MiB 100% -s
mkfs.f2fs -f $installdisk2
elif [ "$filesystem" = "xfs" ];then
parted $installdisk mkpart primary ext4 301MiB 100% -s
mkfs.xfs -f $installdisk2
fi

mount $installdisk2 /mnt
mkdir /mnt/boot/
mkdir /mnt/boot/efi
mount $installdisk1 /mnt/boot/efi

else

echo -e "Sistema Legacy"


parted $installdisk mklabel msdos -s
parted $installdisk mkpart primary ext4 1MiB 100% -s
parted $installdisk set 1 boot on
if [ "$filesystem" = "ext4" ];then
parted $installdisk mkpart primary ext4 301MiB 100% -s
mkfs.ext4 -F $installdisk1
elif [ "$filesystem" = "btrfs" ];then
parted $installdisk mkpart primary ext4 301MiB 100% -s
mkfs.btrfs -f $installdisk1
elif [ "$filesystem" = "f2fs" ];then
parted $installdisk mkpart primary ext4 301MiB 100% -s
mkfs.f2fs -f $installdisk1
elif [ "$filesystem" = "xfs" ];then
parted $installdisk mkpart primary ext4 301MiB 100% -s
mkfs.xfs -f $installdisk1
fi

fi
