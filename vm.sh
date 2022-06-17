VBoxManage createvm --name "ArchCLI" --ostype ArchLinux_64 --register

VBoxManage modifyvm "ArchCLI" --cpus 2 --memory 2048 --vram 128 --acpi on --paravirtprovider default --firmware efi --nested-hw-virt on --graphicscontroller vmsvga --accelerate3d on --mouse usb --keyboard usb --audio pulse --audioout on --audiocontroller hda --usbxhci on

VBoxManage storagectl ArchCLI --name "SATA Controller" --add sata --controller intelahci --hostiocache on --bootable on

VBoxManage createhd --filename `pwd`/ArchCLI/ArchCLI.vdi --size 32000 --format VDI

VBoxManage storageattach ArchCLI --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium  `pwd`/ArchCLI/ArchCLI.vdi

VBoxManage storageattach ArchCLI --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium /home/bn/Downloads/archlinux-2022.06.01-x86_64.iso

VBoxManage modifyvm ArchCLI --boot1 dvd --boot2 disk --boot3 none --boot4 none

VBoxManage modifyvm ArchCLI --boot1 disk --boot2 none --boot3 none --boot4 none
