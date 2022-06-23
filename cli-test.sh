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
echo "/dev/$installdisk";
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

parted /dev/$installdisk mklabel gpt -s
parted /dev/$installdisk mkpart primary fat32 1MiB 301MiB -s
parted /dev/$installdisk set 1 esp on
       if [  $(echo $installdisk | grep -c sd) = 1 ]; then
       echo "sda"
       mkfs.fat -F32 /dev/${installdisk,,}1
       elif [  $(echo $installdisk | grep -c nvme) = 1 ]; then
       echo "nvme"
       mkfs.fat -F32 /dev/${installdisk,,}p1
       fi
          
	   ###PARTIÇÃO ROOT
           if [  $(echo $installdisk | grep -c sd) = 1 ]; then
           echo "sda"
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
           elif [  $(echo $installdisk | grep -c nvme) = 1 ]; then
           echo "NVME"
	              if [ "$filesystem" = "ext4" ];then
	              parted /dev/${installdisk,,} mkpart primary ext4 301MiB 100% -s
                      mkfs.ext4 -F /dev/${installdisk,,}p2
                      elif [ "$filesystem" = "btrfs" ];then
                      parted /dev/${installdisk,,} mkpart primary btrfs 301MiB 100% -s
                      mkfs.btrfs -f /dev/${installdisk,,}p2
                      elif [ "$filesystem" = "f2fs" ];then
                      parted /dev/${installdisk,,} mkpart primary f2fs 301MiB 100% -s
                      mkfs.f2fs -f /dev/${installdisk,,}p2
                      elif [ "$filesystem" = "xfs" ];then
                      parted /dev/${installdisk,,} mkpart primary xfs 301MiB 100% -s
                      mkfs.xfs -f /dev/${installdisk,,}p2
                      fi
	   	     	     
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



###FSTAB

genfstab -U /mnt > /mnt/etc/fstab
