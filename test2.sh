#!/bin/bash

read -p "Digite o Hostname : " HOST
echo
echo "$HOST" | sudo tee /etc/hostname

echo -e "127.0.0.1 localhost.localdomain localhost\n::1 localhost.localdomain localhost\n127.0.1.1 $HOST.localdomain $HOST" | sudo tee /etc/hosts
