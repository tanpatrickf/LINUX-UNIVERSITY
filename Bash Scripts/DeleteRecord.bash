#!/bin/bash
#This script deletes information stored in the student record


x=0
str[0]=""
str[1]="Student Number Must Be Exactly 10 Numeric Characters"
str[2]="Choose Between the Given Choiches Only"
str[3]="The Student Number Does  Not Exist"

input=1

Banner(){

	clear
	figlet -ctf slant "LINUX UNIVERSITY"
	tput cup 6 $(((STTYWidth-$(echo -n "Delete Record" | wc -m))/2))
	echo -n "Delete Record"
	
	tput cup 8 0
	setterm -foreground red
	echo -ne ${str[x]}
	setterm -foreground cyan
	x=0
}

Loader(){

	sNumLine=$(cut -f1 -d: StudentRecord.db | grep -nxi $sNum | cut -f1 -d:)
	sName=$(head -$sNumLine StudentRecord.db | tail -1 | cut -f2 -d:)
	gName=$(head -$sNumLine StudentRecord.db | tail -1 | cut -f3 -d:)
	mName=$(head -$sNumLine StudentRecord.db | tail -1 | cut -f4 -d:)
	hAdd=$(head -$sNumLine StudentRecord.db | tail -1 | cut -f5 -d:)
	bDate=$(head -$sNumLine StudentRecord.db | tail -1 | cut -f6 -d:)
}

StudentNumber(){

	tput cup 11 0
	
	if ((input==1))
	then
		echo -n "Enter student number: "
		read sNum
			
		if [[ "$sNum" == [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9] ]]
		then
			cut -f1 -d: StudentRecord.db | grep -qxi $sNum
			if (($?==0))
			then
				Loader
				input=2
			else
				x=3
			fi
		else
			x=1
		fi
		continue
	else
		echo "1. Student Number: $sNum"
		echo "2. Surname: $sName"
		echo "3. Given Name: $gName"
		echo "4. Middle Name: $mName"
		echo "5. Home Address: $hAdd"
		echo "6. Birthdate: $bDate"
	fi
}

Confirm(){

	tput cup 19 0
	
	if ((input==2))
	then
		echo -ne "Do You Want to Delete the Following Information [y/n]?\nEnter \"n\" to Return to Main Menu: "
		
		read edit
		case $edit in
			y|Y)	break		;;
			n|N)	exit		;;
			*)	x=2
				continue 	;;
		esac
	fi
}

DBUpdater(){

	sed -i "$(echo $sNumLine)d" StudentRecord.db
	
	Banner
	
	tput cup 14 $(((STTYWidth-$(echo -n " Was Deleted" | wc -m)-${#sNum})/2))
	setterm -foreground red
	echo -n $sNum
	setterm -foreground cyan
	echo -n " Was Deleted"
	sleep 3
	echo "$(date +"%T %D") - $uName - Deleted $sNum" >> Actions.log
}

while true
do
	Banner
	
	StudentNumber
	Confirm
done

DBUpdater

exit