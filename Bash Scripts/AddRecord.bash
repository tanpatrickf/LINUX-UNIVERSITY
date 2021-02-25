#!/bin/bash
#This script handles new information to be added to student record.

x=0
str[0]=""
str[1]="Student Number Must Be Exactly 10 Numeric Characters"
str[2]="Surname Must Not Contain Numbers\nand Special Characters"
str[3]="Surname Must Be Entered"
str[4]="Given Name Must Not Contain Numbers\nand Special Characters"
str[5]="Given Name Must Be Entered"
str[6]="Middle Name Must Not Contain Numbers\nand Special Characters"
str[7]="Middle Name Must Be Entered"
str[8]="Shipping Address Must Be 100 or Less Characters in Length"
str[9]="Shipping Address Must Be Entered"
str[10]="One or More Entry Exceeded\nWith the Acceptable Range"
str[11]="Birthdate Must Be Entered"
str[12]="Choose Between the Given Choiches Only"

input=1

Banner(){

	clear
	figlet -ctf slant "LINUX UNIVERSITY"
	tput cup 6 $(((STTYWidth-$(echo -n "Add Record" | wc -m))/2))
	echo -n "Add Record"
	
	tput cup 8 0
	setterm -foreground red
	echo -ne ${str[x]}
	setterm -foreground cyan
	x=0
}

StudentNumber(){

	tput cup 11 0
	
	if ((input==1)) || ((edit==1))
	then
		echo -n "Enter Student number: "
		read sNum

		if [[ "$sNum" == [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9] ]]
		then
			cut -f1 -d: StudentRecord.db | grep -qxi $sNum
			if (($?==0))
			then 
				sNumLine=$(cut -f1 -d: StudentRecord.db | grep -nxi $sNum | cut -f1 -d:)
				sNameDB=$(head -$sNumLine StudentRecord.db | tail -1 | cut -f2 -d:)
				gNameDB=$(head -$sNumLine StudentRecord.db | tail -1 | cut -f3 -d:)
				mNameDB=$(head -$sNumLine StudentRecord.db | tail -1 | cut -f4 -d:)
				
				x=13
				
				str[13]="The student number $sNum is already reserved to $sNameDB, $gNameDB ($mNameDB)"
			else
				if ((edit==1))
				then
					edit=0
				else
					input=2
				fi
			fi
		else
			x=1
		fi
		continue
	else
		echo -n "1. Student Number: $sNum"
	fi
}

Surname(){
	
	tput cup 12 0
	
	if ((input==2)) || ((edit==2))
	then
		echo -n "Enter surname: "
		read -a sName

		if [[ ${sName[*]} == *[^a-zA-Z." "]* ]]
		then
			x=2
		elif [[ ${sName[*]} != *[a-zA-Z]* ]]
		then
			x=3
		else
			if ((edit==2))
			then
				edit=0
			else
				input=3
			fi
		fi
		continue
	else
		echo -n "2. Surname: ${sName[*]}"
	fi
}

GivenName(){
	
	tput cup 13 0
	
	if ((input==3)) || ((edit==3))
	then
		echo -n "Enter given name: "
		read -a gName

		if [[ ${gName[*]} == *[^a-zA-Z." "]* ]]
		then
			x=4
		elif [[ ${gName[*]} != *[a-zA-Z]* ]]
		then
			x=5
		else
			if ((edit==3))
			then
				edit=0
			else
				input=4
			fi
		fi
		continue
	else
		echo -n "3. Given Name: ${gName[*]}"
	fi
}

MiddleName(){
	
	tput cup 14 0
	
	if ((input==4)) || ((edit==4))
	then
		echo -n "Enter middle name: "
		read -a mName

		if [[ ${mName[*]} == *[^a-zA-Z." "]* ]]
		then
			x=6
		elif [[ ${mName[*]} != *[a-zA-Z]* ]]
		then
			x=7
		else
			if ((edit==4))
			then
				edit=0
			else
				input=5
			fi
		fi
		continue
	else
		echo -n "4. Middle Name: ${mName[*]}"
	fi
}

HomeAddress(){
	
	tput cup 15 0
	
	if ((input==5)) || ((edit==5))
	then
		echo -n "Enter home address: "
		read hAdd
		hAddLen=${#hAdd[*]}
		
		if ((hAddLen>100))
		then
			x=8
		else
			if [[ $hAdd != *[a-zA-Z]* ]]
			then
				x=9
			else
				if ((edit==5))
				then
					edit=0
				else
					input=6
				fi
				hAddDB=${hAdd//:/+}
			fi
		fi
		continue
	else
		echo -n "5. Address: $hAdd"
	fi
}

Birthdate(){

	tput cup 16 0
	
	if ((input==6)) || ((edit==6))
	then
		echo -n "Enter Birthdate[mm/dd/yyyy]: "
		read bDate

		if [[ ${bDate} != *[0-9]* ]]
		then
			x=11
			continue
		elif [[ "$bDate" == [0-9][0-9]["/"][0-9][0-9]["/"][0-9][0-9][0-9][0-9] ]]
		then
			if ((10#${bDate:0:2} > 0 )) && ((10#${bDate:0:2} < 13))
			then
				if ((10#${bDate:3:2} > 0 )) && ((10#${bDate:3:2} < 32))
				then
					if ((${bDate:6:4} > 1900 )) && ((${bDate:6:4} < 2018))
					then
						if ((edit==6))
						then
							edit=0
						else
							input=7
						fi
						continue
					fi
				fi
			fi
		fi
		x=10
		continue
	else
		echo -n "6. Birthdate: $bDate"
	fi
}

Confirm(){

	tput cup 19 0
	
	if ((input==7))
	then
		echo -ne "Do You Want to Proceed With the Following Information [y/n]?\nEnter \"n\" to Edit Information, \"0\" to Cancel Registration: "
		
		read edit
		case $edit in
			y|Y)	break		;;
			n|N)	input=8
				continue	;;
			0)	exit		;;
			*)	x=12
				continue 	;;
		esac
	fi
}

Edit(){

	tput cup 19 0
	
	if ((input==8))
	then
		echo -ne "Enter the Number of Field You Want to Edit [1-6]\nEnter [0] to Stop Editing: "
		read field
		
		case $field in
			0)	input=7		;;
			1)	edit=1		;;
			2)	edit=2		;;
			3)	edit=3		;;
			4)	edit=4		;;
			5)	edit=5		;;
			6)	edit=6		;;
			*)	x=12
				continue	;;
		esac
		continue
	fi
}

DBUpdater(){

	echo -ne "$sNum:${sName[*]}:${gName[*]}:${mName[*]}:$hAddDB:$bDate\n" >> StudentRecord.db
	
	Banner
	
	tput cup 14 $(((STTYWidth-$(echo -n "Entry for ,  () Was Recorded"${sName[*]}${gName[*]}${mName[*]} | wc -m))/2))
	echo -n "Entry for "
	setterm -foreground red
	echo -n ${sName[*]}
	setterm -foreground cyan
	echo -n ", "
	setterm -foreground red
	echo -n ${gName[*]}
	setterm -foreground cyan
	echo -n " ("
	setterm -foreground red
	echo -n ${mName[*]}
	setterm -foreground cyan
	echo -n ") Was Recorded"
	sleep 3
	
	
	echo "$(date +"%T %D") - $uName - Added $sNum" >> Actions.log
}

while true
do
	Banner
	
	StudentNumber
	Surname
	GivenName
	MiddleName
	HomeAddress
	Birthdate
	Confirm
	Edit
done

DBUpdater

exit

