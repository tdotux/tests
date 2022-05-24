#!/bin/bash

if [ -d /sys/firmware/efi ];
then
echo "Sistema EFI"
else
echo "Sistema Legacy"
fi
