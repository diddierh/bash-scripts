#!/bin/bash
if [ "$(whoami)" != "root" ]
then
	echo "este script debe ser invocado como super usuario";
	exit 126;
fi

function success(){
	echo "if update-grub doesn't detect all your OS try doing it in the restored linux instead live cd"
}

if [ "$1" ] && [ "$2" ] && [ "$3" ]; then
	mkdir -p /media/base
	mount $1 /media/base
	mount $2 /media/base/boot/efi
	for x in /dev /dev/pts /sys /proc
	do
		mount $x /media/base$x --bind
	done
	grub-install 
else
	echo "usage:\n ./rescue-grub.sh 'root-filesystem' 'hdd-device' ['efi-partition'] \n for instance: ./rescue-grub /dev/sda2 /dev/sda /dev/sda1"
fi