#!/bin/bash
#This script will load backup record from the batch file

x=0
str[0]=""
str[1]="Batch File Does Not Exist"
str[2]="Batch File Does Not Follow The Format of Student Record"

input=1

Banner(){

	clear
	figlet -ctf slant "LINUX UNIVERSITY"
	tput cup 6 $(((STTYWidth-$(echo -n "Load Record" | wc -m))/2))
	echo -n "Load Record"
	
	tput cup 8 0
	setterm -foreground red
	echo -ne ${str[x]}
	setterm -foreground cyan
	x=0
}

Input(){

	if ((input==1))
	then
		tput cup 12 0
		echo -ne  "Enter the Absolute Path of the Batch File to be Loaded:\n"
		read bFile
	fi
	
	FileChecker
	BFileLoader
}

FileChecker(){

	cat $bFile &>/dev/null
	x=$?
	
	if ((x==1))
	then
		continue
		
	elif ((x==0))
	then
		if (($(head -1 $bFile | grep -o ':' | wc -l) != 5))
		then
			x=2
			continue
		fi
	fi
	input=0
}

BFileLoader(){

	readarray sNumArray < <(cut -f1 -d: $bFile)
	numOfIndices=$(echo ${#sNumArray[*]})
	for ((x=0; x<numOfIndices; x++))
	do
		cut -f1 -d: StudentRecord.db | grep -qi ${sNumArray[x]}
		if (($?==0))
		then
			print[x]="Line$((x+1)): Data Not Loaded (\"$(head -$((x+1)) $bFile | tail -1 | cut -f1 -d:)\" Already Exists in the Student Record)"
			indexFlag[x]=1
		else
			print[x]="Line$((x+1)): Data Succesfully Loaded (\"$(head -$((x+1)) $bFile | tail -1 | cut -f1 -d:)\")"
			head -$((x+1)) $bFile | tail -1 >> StudentRecord.db
			indexFlag[x]=0
		fi
	done
}

Printer(){
	Banner
	
	for ((y=0; y<numOfIndices; y++))
	do
		
		if ((y<15))
		then
			if ((indexFlag[y]==1))
			then
				setterm -foreground red
			fi
			echo -e "   ${print[y]}"
			setterm -foreground cyan
		else
			Banner
			
			for ((z=0; z<15; z++))
			do
				if ((${indexFlag[((y+z-14))]}==1))
				then
					setterm -foreground red
				fi
				echo -e "   ${print[y+z-14]}"
				setterm -foreground cyan
			done
		fi
		sleep 0.2
	done
	
	echo "$(date +"%T %D") - $uName - Loaded $bFile" >> Actions.log
}

while true
do
	Banner

	Input
	Printer
	setterm -cursor off
	sleep 5
	setterm -cursor on
	exit
done