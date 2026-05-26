#/usr/bin/env bash

> registro.txt
#Name process and id
NAME=$( cat /proc/self/status > registro.txt | cat /proc/self/maps >> registro.txt  | grep 'Name' ./registro.txt | awk '{print $2}' )
PROCESSID=$( grep -w  "Pid"  ./registro.txt | awk '{print $2}'  )
echo "Name process : $NAME"
echo "Id process:  $PROCESSID"


#Information about program and VMA
MAPS=$( grep "/$NAME"$  ./registro.txt )

echo "----------------------------"
while IFS= read -r linea ;do

	

        if [[ $linea == *"r--p"*   ]];then
		echo -e "\e[35mReadable data: \e[0m  $linea"
	fi
	
	if [[ $linea == *"rw-p"* ]];then
		echo -e  "\e[32mModifiable data:\e[0m $linea"
	fi
	if [[ $linea == *"r-xp"* ]];then
		echo -e "\e[33mExecutable:\e[0m $linea"
	fi


done <<< $MAPS

#Libraries dynamics
echo "----------------------------"
echo -e  "Libraries dynamics \n"
LIBRARIES=$( grep -F '.so.' ./registro.txt)

while IFS= read -r linea;do
	echo $linea
done <<< $LIBRARIES


echo -e  "---------------------------- \n"

#Information about partitions

PARTITIONS=$(grep 's[a-z]'   /proc/partitions)
SIZE_SDA=$(grep 'sda$' /proc/partitions | awk '{print $3}' )
SIZE_SDB=$(grep 'sdb$' /proc/partitions | awk '{print $3}')
SIZE_SDA=$(awk "BEGIN {printf \"%.2f\",$SIZE_SDA/2^20 }")
SIZE_SDB=$(awk "BEGIN {printf \"%.2f\",$SIZE_SDB/2^20}")

echo "My partitions and  your size"
echo "$SIZE_SDA GB"
echo "$SIZE_SDB GB"






