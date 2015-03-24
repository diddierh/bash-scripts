#!/bin/bash
function success(){
	echo "recuerde que esta configuración tomará efecto cuando se inicie una nueva shell"
	echo "recuerde que para habilitar los proxies tiene que invocar proxyon y para deshabilitarlos proxyoff"

}

if [ "$(whoami)" != "root" ]
then
	echo "este script debe ser invocado como super usuario";
	exit 126;
fi



if [ -z "$1" ]; then

	if [ -a /etc/bash.bashrc ]; then #{debian,suse} like distro
		cat proxy-unal.src >> /etc/bash.bashrc;
		success;
	elif [ -a /etc/bashrc ]; then #red-hat like distro
		cat proxy-unal.src >> /etc/bashrc;
		success;
	else
		echo "por favor invoque el script pasando como primer parametro el nombre del archivo bashrc del sistema";
	fi
else
	cat proxy-unal.src >> $1
	success;
fi