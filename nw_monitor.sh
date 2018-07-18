#!/bin/bash

if [ -z "$1" ]; then
        echo -e "\n\tusage: $0 <Network-Interface>"
        echo -e "\tExample: $0 eth0 \n"
        exit
fi
IF=$1

while true
do
        R1=`cat /sys/class/net/$IF/statistics/rx_bytes`
        T1=`cat /sys/class/net/$IF/statistics/tx_bytes`
        sleep 1
        R2=`cat /sys/class/net/$IF/statistics/rx_bytes`
        T2=`cat /sys/class/net/$IF/statistics/tx_bytes`
        TBPS=`expr $T2 - $T1`
        RBPS=`expr $R2 - $R1`

	# convert to bits
	TBPS=$(($TBPS * 8))
	RBPS=$(($RBPS * 8))

	if [ $TBPS -gt 1023 ] && [ $TBPS -lt 1048576 ]
	then
		Tx=`expr $TBPS / 1024`" K"

	elif [ $TBPS -gt 1048575 ] && [ $TBPS -lt 1073741824 ]
	then
		Tx=`expr $TBPS / 1048576`" M"

	elif [ $TBPS -gt 1073741823 ]
	then
        	Tx=`expr $TBPS / 1073741824`" G"
	fi

	if [ $RBPS -gt 1023 ] && [ $RBPS -lt 1048576 ]
        then
                Rx=`expr $RBPS / 1024`" K"

        elif [ $RBPS -gt 1048575 ] && [ $RBPS -lt 1073741824 ]
	then
                Rx=`expr $RBPS / 1048576`" M"

        elif [ $RBPS -gt 1073741823 ]
	then
                Rx=`expr $RBPS / 1073741824`" G"
        fi

        echo -e "tx $IF: $Tx""b/s \t rx $1: $Rx""b/s"
done