#!/bin/bash

#function definitions
function help(){
echo -e "\t\t\tlittle wifi script config:\n\nOPTIONS\n\t-e\tthe essid \n\
\t-p\tpassphrase\n\t-c\tconfig file\n\t-h\tdisplay this message\n\t-i\tinterface to use\n\nUSAGE\n\
Invoke this script passing the required arguments. If no arguments are \
specified this message is shown. If any of the arguments contain spaces\
escape each space using the \\ character before each space. There is not prefixed argument order\n\n\
EXAMPLES\n\t./wifi.sh -c wpa_supplicant_compatible-file.conf -i interface\n\t./wifi.sh -e essid -p passphrase -i interface\
\n\t./wifi.sh -e essid -p passphrase -c wpa_supplicant_compatible-file.conf -i interface\n"
}

function getIp(){
	sudo dhclient $1
}

#reading arguments

args=$(( $#/2 ))
if [ $# == 0 ] || [ $1 == '-h' ]
then
	help
	exit 0;
fi

for (( i=1;i<=$args;i++ ))
do
	flagptr=$(( i*2-1 ))
	argptr=$(( i*2 ))
	eval flag=\$$flagptr
	eval arg=\$$argptr
	if [ $flag == '-c' ]
	then
		confile=$arg
	elif [ $flag == '-e' ]
	then
		essid=$arg
	elif [ $flag == '-i' ]
	then
		iface=$arg
	elif [ $flag == '-p' ]
	then
		pass=$arg
	fi
done
#checking flags
if [ $iface ]
then
	if [ $essid ] && [ $pass ] || [ $confile ]
	then
		if [ $essid ] && [ $pass ] && [ $confile ]
		then
			sudo ifconfig $iface up
			sudo wpa_passphrase $essid $pass > $confile
			sudo wpa_supplicant -c $confile -i $iface -B
			getIp $iface
			exit 0;
		else
			if [ $essid ] && [ $pass ]
			then
			
				temp_file=/tmp/$RANDOM
				sudo wpa_passphrase $essid $pass > $temp_file
				sudo wpa_supplicant -c $temp_file -i $iface -B
				getIp $iface
				#rm -Rf $temp_file
				exit 0
			else
				sudo wpa_supplicant -c $confile -i $iface -B
				getIp $iface
				exit 0
			fi
		fi
	else
		echo "specify at least -c | -e -p"
	fi
else
	echo "please specify an interface"
	exit -1
fi
