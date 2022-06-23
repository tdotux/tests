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

parted /dev/${installdisk,,} mklabel gpt -s
parted /dev/${installdisk,,} mkpart primary fat32 1MiB 301MiB -s
parted /dev/${installdisk,,} set 1 esp on
       if [  $(echo $installdisk | grep -c sd) = 1 ]; then
       echo "sda"
       mkfs.fat -F32 /dev/${installdisk,,}1
       elif [  $(echo $installdisk | grep -c nvme) = 1 ]; then
       echo "nvme"
       mkfs.fat -F32 /dev/${installdisk,,}1
       fi
          
	   ###PARTIÇÃO ROOT
           if [  $(echo $installdisk | grep -c sd) = 1 ]; then
           echo "sda"
                      if [ "$filesystem" = "ext4" ];then
	              parted /dev/${installdisk,,} mkpart primary ext4 301MiB 100% -s
                      mkfs.ext4 -F /dev/${installdisk,,}2
		      mount /dev/${installdisk,,}2 /mnt
                      mkdir /mnt/boot/
                      mkdir /mnt/boot/efi
                      mount /dev/${installdisk,,}1 /mnt/boot/efi
		      
                      elif [ "$filesystem" = "btrfs" ];then
                      parted /dev/${installdisk,,} mkpart primary ext4 301MiB 100% -s
                      mkfs.btrfs -f /dev/${installdisk,,}
		      mount /dev/${installdisk,,}2 /mnt
                      mkdir /mnt/boot/
                      mkdir /mnt/boot/efi
                      mount /dev/${installdisk,,}1 /mnt/boot/efi
		      
                      elif [ "$filesystem" = "f2fs" ];then
                      parted /dev/${installdisk,,} mkpart primary ext4 301MiB 100% -s
                      mkfs.f2fs -f /dev/${installdisk,,}
		      mount /dev/${installdisk,,}2 /mnt
                      mkdir /mnt/boot/
                      mkdir /mnt/boot/efi
                      mount /dev/${installdisk,,}1 /mnt/boot/efi
		      
                      elif [ "$filesystem" = "xfs" ];then
                      parted /dev/${installdisk,,} mkpart primary ext4 301MiB 100% -s
                      mkfs.xfs -f /dev/${installdisk,,}
		      mount /dev/${installdisk,,}2 /mnt
                      mkdir /mnt/boot/
                      mkdir /mnt/boot/efi
                      mount /dev/${installdisk,,}1 /mnt/boot/efi
		      
                      fi
		      
           elif [  $(echo $installdisk | grep -c nvme) = 1 ]; then
           echo "NVME"
	              if [ "$filesystem" = "ext4" ];then
	              parted /dev/${installdisk,,} mkpart primary ext4 301MiB 100% -s
                      mkfs.ext4 -F /dev/${installdisk,,}p2
		      mount /dev/${installdisk,,}p2 /mnt
                      mkdir /mnt/boot/
                      mkdir /mnt/boot/efi
                      mount /dev/${installdisk,,}p1 /mnt/boot/efi
		      
                      elif [ "$filesystem" = "btrfs" ];then
                      parted /dev/${installdisk,,} mkpart primary btrfs 301MiB 100% -s
                      mkfs.btrfs -f /dev/${installdisk,,}p2
		      mount /dev/${installdisk,,}p2 /mnt
                      mkdir /mnt/boot/
                      mkdir /mnt/boot/efi
                      mount /dev/${installdisk,,}p1 /mnt/boot/efi
		      
                      elif [ "$filesystem" = "f2fs" ];then
                      parted /dev/${installdisk,,} mkpart primary f2fs 301MiB 100% -s
                      mkfs.f2fs -f /dev/${installdisk,,}p2
		      mount /dev/${installdisk,,}p2 /mnt
                      mkdir /mnt/boot/
                      mkdir /mnt/boot/efi
                      mount /dev/${installdisk,,}p1 /mnt/boot/efi
		      
                      elif [ "$filesystem" = "xfs" ];then
                      parted /dev/${installdisk,,} mkpart primary xfs 301MiB 100% -s
                      mkfs.xfs -f /dev/${installdisk,,}p2
		      mount /dev/${installdisk,,}p2 /mnt
                      mkdir /mnt/boot/
                      mkdir /mnt/boot/efi
                      mount /dev/${installdisk,,}p1 /mnt/boot/efi
		      
                      fi
	   	     	     
	   fi

fi	  

