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


### SWAP

printf '\x1bc';

echo -e "SWAP"
echo -e "Para Máquinas até 8GB de RAM - 4GB de SWAP"
echo -e "\n"
echo -e "Acima de 8GB de RAM - 2GB de SWAP"
echo -e "Digite o NÚMERO correspondente a quantidade de SWAP em GB"
echo -e "Exemplo: Para 4GB de SWAP - Digite 4"

read -p "SWAP em GB : " SWAP



###SET-SWAP

if [ "$filesystem" = "btrfs" ];then

arch-chroot /mnt truncate -s 0 /swapfile && arch-chroot /mnt chattr +C /swapfile && arch-chroot /mnt btrfs property set /swapfile compression "" && arch-chroot /mnt fallocate -l ${SWAP,,}G /swapfile && arch-chroot /mnt chmod 600 /swapfile && arch-chroot /mnt mkswap /swapfile && arch-chroot /mnt swapon /swapfile && echo -e '/swapfile none swap defaults 0 0\n' | arch-chroot /mnt tee -a /etc/fstab

else

arch-chroot /mnt fallocate -l ${SWAP,,}G /swapfile && arch-chroot /mnt chmod 600 /swapfile && arch-chroot /mnt mkswap /swapfile && arch-chroot /mnt swapon /swapfile && echo -e '/swapfile none swap defaults 0 0\n' | arch-chroot /mnt tee -a /etc/fstab

fi
