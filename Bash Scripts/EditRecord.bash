#!/bin/bash
#This script handles changes on information already stored in the student record.

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
str[13]="The Student Number Does  Not Exist"

input=1

Banner(){

	clear
	figlet -ctf slant "LINUX UNIVERSITY"
	tput cup 6 $(((STTYWidth-$(echo -n "Edit Record" | wc -m))/2))
	echo -n "Edit Record"
	
	tput cup 8 0
	setterm -foreground red
	echo -ne ${str[x]}
	setterm -foreground cyan
	x=0
}

Loader(){

	sNumLineOld=$(cut -f1 -d: StudentRecord.db | grep -nxi $sNum | cut -f1 -d:)
	sNameOld=$(head -$sNumLineOld StudentRecord.db | tail -1 | cut -f2 -d:)
	gNameOld=$(head -$sNumLineOld StudentRecord.db | tail -1 | cut -f3 -d:)
	mNameOld=$(head -$sNumLineOld StudentRecord.db | tail -1 | cut -f4 -d:)
	hAddOld=$(head -$sNumLineOld StudentRecord.db | tail -1 | cut -f5 -d:)
	bDateOld=$(head -$sNumLineOld StudentRecord.db | tail -1 | cut -f6 -d:)
	sName=$sNameOld
	gName=$gNameOld
	mName=$mNameOld
	hAdd=$hAddOld
	bDate=$bDateOld
}

StudentNumber(){

	tput cup 11 0
	
	if ((input==1)) || ((edit==1))
	then
		if ((input==1))
		then
			echo -n "Enter student number: "
			read sNum
			sNumOld=$sNum
			sNumNew=$sNum
		else
			echo -n "Enter new student number: "
			read sNum
		fi
		
		if ((edit==1)) && ((sNumOld==sNum))
		then
			sNumNew=$sNum
			edit=0
			continue
		fi
		
		if [[ "$sNum" == [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9] ]]
		then
			cut -f1 -d: StudentRecord.db | grep -qxi $sNum
			if (($?==0))
			then
				if ((input==1))
				then
					Loader
					input=8
				else
					sNumLineOther=$(cut -f1 -d: StudentRecord.db | grep -nxi $sNum | cut -f1 -d:)
					sNameOther=$(head -$sNumLineOther StudentRecord.db | tail -1 | cut -f2 -d:)
					gNameOther=$(head -$sNumLineOther StudentRecord.db | tail -1 | cut -f3 -d:)
					x=14
					str[14]="The Student Number $sNum is Already Reserved to $sNameOther, $gNameOther"
				fi
			else
				if ((input==1))
				then
					x=13
				else
					sNumNew=$sNum
					edit=0
				fi
			fi
		else
			x=1
		fi
		continue
	else
		echo -n "1. Student Number: $sNumNew"
	fi
}

Surname(){
	
	tput cup 12 0
	
	if ((edit==2))
	then
		echo -n "Change surname: "
		read -a sName

		if [[ ${sName[*]} == *[^a-zA-Z." "]* ]]
		then
			x=2
		elif [[ ${sName[*]} != *[a-zA-Z]* ]]
		then
			x=3
		else
			edit=0
		fi
		continue
	else
		echo -n "2. Surname: ${sName[*]}"
	fi
}

GivenName(){
	
	tput cup 13 0
	
	if ((edit==3))
	then
		echo -n "Change given name: "
		read -a gName

		if [[ ${gName[*]} == *[^a-zA-Z." "]* ]]
		then
			x=4
		elif [[ ${gName[*]} != *[a-zA-Z]* ]]
		then
			x=5
		else
			edit=0
		fi
		continue
	else
		echo -n "3. Given Name: ${gName[*]}"
	fi
}

MiddleName(){
	
	tput cup 14 0
	
	if ((edit==4))
	then
		echo -n "Change middle name: "
		read -a mName

		if [[ ${mName[*]} == *[^a-zA-Z." "]* ]]
		then
			x=6
		elif [[ ${mName[*]} != *[a-zA-Z]* ]]
		then
			x=7
		else
			edit=0
		fi
		continue
	else
		echo -n "4. Middle Name: ${mName[*]}"
	fi
}

HomeAddress(){
	
	tput cup 15 0
	
	if ((edit==5))
	then
		echo -n "Change home address: "
		read hAdd
		hAddLen=${#hAdd}
		
		if ((sAddLen>100))
		then
			x=8
		else
			if [[ $hAdd != *[a-zA-Z]* ]]
			then
				x=9
			else
				edit=0
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
	
	if ((edit==6))
	then
		echo -n "Change Birthdate[mm/dd/yyyy]: "
		read bDate

		if [[ ${bDate} != *[0-9]* ]]
		then
			x=11
			continue
		elif [[ "$bDate" == [0-9][0-9]["/"][0-9][0-9]["/"][0-9][0-9][0-9][0-9] ]]
		then
			if ((${bDate:0:2} > 0 )) && ((${bDate:0:2} < 13))
			then
				if ((${bDate:3:2} > 0 )) && ((${bDate:3:2} < 32))
				then
					if ((${bDate:6:4} > 1900 )) && ((${bDate:6:4} < 2018))
					then
						edit=0
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
		echo -ne "Do You Want to Proceed With the Following Information [y/n]?\nEnter \"n\" to Edit Information, \"0\" to Return to Main Menu: "
		
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

	sed -i "$sNumLineOld s/[^:]*/$sNumNew/1" StudentRecord.db
	sed -i "$sNumLineOld s/[^:]*/$sName/2" StudentRecord.db
	sed -i "$sNumLineOld s/[^:]*/$gName/3" StudentRecord.db
	sed -i "$sNumLineOld s/[^:]*/$mName/4" StudentRecord.db
	sed -i "$sNumLineOld s/[^:]*/$hAdd/5" StudentRecord.db
	sed -i "$sNumLineOld s/[^:]*/$bDate/6" StudentRecord.db
	
	Banner
		
	tput cup 14 $(((STTYWidth-$(echo -n "Changes for ,  () Was Updated" | wc -m)-${#sName}-${#gName}-${#mName})/2))
	echo -n "Changes for "
	setterm -foreground red
	echo -n $sName
	setterm -foreground cyan
	echo -n ", "
	setterm -foreground red
	echo -n $gName
	setterm -foreground cyan
	echo -n " ("
	setterm -foreground red
	echo -n $mName
	setterm -foreground cyan
	echo -n ") Was Updated"
	sleep 3
}

Logger(){

	if [[ "$sNumOld" != "$sNumNew" ]]
	then
		echo "$(date +"%T %D") - $uName - Changed $sNumOld to $sNumNew" >> Actions.log
	fi
	
	if [[ "$sNameOld" != "$sName" ]]
	then
		echo "$(date +"%T %D") - $uName - ($sNumNew) Changed $sNameOld to $sName" >> Actions.log
	fi
	
	if [[ "$gNameOld" != "$gName" ]]
	then
		echo "$(date +"%T %D") - $uName - ($sNumNew) Changed $gNameOld to $gName" >> Actions.log
	fi
	
	if [[ "$mNameOld" != "$mName" ]]
	then
		echo "$(date +"%T %D") - $uName - ($sNumNew) Changed $mNameOld to $mName" >> Actions.log
	fi
	
	if [[ "$hAddOld" != "$hAdd" ]]
	then
		echo "$(date +"%T %D") - $uName - ($sNumNew) Changed $hAddOld to $hAdd" >> Actions.log
	fi
	
	if [[ "$bDateOld" != "$bDate" ]]
	then
		echo "$(date +"%T %D") - $uName - ($sNumNew) Changed $bDateOld to $bDate" >> Actions.log
	fi
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
Logger

exit