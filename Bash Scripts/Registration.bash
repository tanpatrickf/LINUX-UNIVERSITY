#!/bin/bash
#This script handles registration of a new user

subHeader="Registration"
subHeaderLen=${#subHeader}


x=0
str[0]=""
str[1]="Given Name Must Not Contain Numbers\nand Special Characters"
str[2]="Given Name Must Be Entered"
str[3]="Middle Name Must Not Contain Numbers\nand Special Characters"
str[4]="Middle Name Must Be Entered"
str[5]="Surname Must Not Contain Numbers\nand Special Characters"
str[6]="Surname Must Be Entered"

str[7]="Password Must Be at Least 8 Characters in Length And Contain\nAtleast 1 Lowercase, Uppercase, and Number"
str[8]="Password Must Be at Least 8 Characters in Length"
str[9]="Password Must Contain Atleast 1 Lowercase, Uppercase, and Number"
str[10]="Password Does Not Match\nType [^] to Return the Previous Field"
str[11]="Choose Between the Given Choiches Only"

input=1

GivenName(){
	
	tput cup 10 0
	
	if ((input==1)) || ((edit==1))
	then
		echo -n "Enter your given name: "
		read -a gName

		if [[ ${gName[*]} == *[^a-zA-Z." "]* ]]
		then
			x=1
			continue
		elif [[ ${gName[*]} != *[a-zA-Z]* ]]
		then
			x=2
			continue
		else
			x=0
			if ((edit==1))
			then
				edit=0
			else
				input=2
			fi
			continue
		fi
	else
		echo -n "1. Given Name: ${gName[*]}"
	fi
}
MiddleName(){
	
	tput cup 11 0
	
	if ((input==2)) || ((edit==2))
	then
		echo -n "Enter your middle name: "
		read -a mName

		if [[ ${mName[*]} == *[^a-zA-Z." "]* ]]
		then
			x=3
			continue
		elif [[ ${mName[*]} != *[a-zA-Z]* ]]
		then
			x=4
			continue
		else
			x=0
			if ((edit==2))
			then
				edit=0
			else
				input=3
			fi
			continue
		fi
	else
		echo -n "2. Middle Name: ${mName[*]}"
	fi
}
Surname(){
	
	tput cup 12 0
	
	if ((input==3)) || ((edit==3))
	then
		echo -n "Enter your surname: "
		read -a sName

		if [[ ${sName[*]} == *[^a-zA-Z." "]* ]]
		then
			x=5
			continue
		elif [[ ${sName[*]} != *[a-zA-Z]* ]]
		then
			x=6
			continue
		else
			x=0
			if ((edit==3))
			then
				edit=0
			else
				input=4
			fi
			continue
		fi
	else
		echo -n "3. Surname: ${sName[*]}"
	fi
}
Password(){

	tput cup 13 0
		
	if ((input==4)) || ((edit==4))
	then
		echo -n "Enter Desired Password: "
		stty -echo
		unset PROMPT
		unset pass
		char=0
		while mask= read -p "$PROMPT" -r -s -n 1 CHAR
		do
			if [[ $CHAR == $'\0' ]]
			then
				break
			fi
			
			if [[ $CHAR == $'\177' ]]
			then
				if [ $char -gt 0 ]
				then
					((char--))
					PROMPT=$'\b \b'
					pass="${pass%?}"
				else
					PROMPT=''
				fi
			else
				((char++))
				PROMPT='*'
				pass+="$CHAR"
			fi
		done
		stty echo

		if [[ $pass =~ [[:digit:]] ]] && [[ $pass =~ [[:upper:]] ]] && [[ $pass =~ [[:lower:]] ]]
		then
			if ((${#pass}<8))
			then
				x=8
				continue
			else
				cryptPass=$(echo $pass | crypt PT 2>/dev/null)
				passDB=${cryptPass//:/+}
				passDB=${passDB//$'\12'/?}
				if ((edit==4))
				then
					edit=0
				else
					input=5
				fi
				x=0
				continue
			fi
		elif ((${#pass}<8))
		then
			x=7
			continue
		else
			x=9
			continue
		fi
	else
		echo -n "4. Password: "
		for ((z=0; z<${#pass}; z++))
		do
			echo -n "*"
		done
		echo -ne "\n"	
	fi
}
RePassword(){

	tput cup 14 0
	
	if ((input==5)) || ((edit==5))
	then
		echo -n "Re-enter Password: "
		stty -echo
		unset PROMPT
		unset cPass
		char=0
		while mask= read -p "$PROMPT" -r -s -n 1 CHAR
		do
			if [[ $CHAR == '^' ]]
			then
				stty echo
				input=4
				edit=0
				x=0
				continue 2
			fi
			
			if [[ $CHAR == $'\0' ]]
			then
				break
			fi
			
			if [[ $CHAR == $'\177' ]]
			then
				if [ $char -gt 0 ]
				then
					((char--))
					PROMPT=$'\b \b'
					cPass="${cPass%?}"
				else
					PROMPT=''
				fi
			else
				((char++))
				PROMPT='*'
				cPass+="$CHAR"
			fi
		done
		stty echo
		
		if [[ $pass == $cPass ]]
		then
			if ((edit==5))
			then
				edit=0
			else
				input=6
			fi
			x=0
			continue
		else
			x=10
			continue
		fi
	fi
}
Confirm(){

	tput cup 17 0
	
	if ((input==6))
	then
		echo -ne "Do You Want to Proceed With the Following Information [y/n]?\nEnter \"n\" to Edit Information, \"0\" to Cancel Registration: "
		
		read edit
		case $edit in
			y|Y)	break		;;
			n|N)	input=7
				x=0
				continue	;;
			0)	exit		;;
			*)	x=11
				continue 	;;
		esac
	fi
}
Edit(){

	tput cup 17 0
	
	if ((input==7))
	then
		echo -ne "Enter the Number of Field You Want to Edit [1-4]\nEnter [0] to Stop Editing: "
		read field
		
		case $field in
			0)	input=6		;;
			1)	edit=1		;;
			2)	edit=2		;;
			3)	edit=3		;;
			4)	input=4		;;
			*)	x=11
				continue	;;
		esac
		
		x=0
		continue
	fi
}

Username(){

	for ((x=0; x<${#gName[*]}; x++))
	do
		ug="$ug${gName[$x]:0:1}"
	done
	
	for ((x=0; x<${#mName[*]}; x++))
	do
		um="$um${mName[$x]:0:1}"
	done
	
	for ((x=0; x<${#sName[*]}; x++))
	do
		us="$us${sName[$x]}"
	done
	
	uName="$ug$um$us"
	
	while true
	do
		cut -f1 -d: UserAccounts.db | grep -qxi $uName
		if (($?==0))
		then
			for ((y=2;; y++))
			do
				unset um
				for ((x=0; x<${#mName[*]}; x++))
				do
					um="$um${mName[$x]:0:$y}"
				done
				
				uName="$ug$um$us"
				
				cut -f1 -d: UserAccounts.db | grep -qxi $uName
				if (($?==0))
				then
					continue
				else
					break
				fi
			done
		else
			break
		fi
	done
}

while true
do
	clear
	figlet -ctf slant "LINUX UNIVERSITY"
	printf "%*s\n" $(((subHeaderLen+STTYWidth)/2)) "$subHeader"
	
	tput cup 7 0
	setterm -foreground red
	echo -ne ${str[x]}
	setterm -foreground cyan
	
	GivenName
	MiddleName
	Surname
	Password
	RePassword
	Confirm
	Edit
done

Username

clear
figlet -ctf slant "LINUX UNIVERSITY"

tput cup 12 $(((STTYWidth-$(echo -n "Registration successful" | wc -m))/2))
echo -n "Registration successful!"
tput cup 15 $(((STTYWidth-$(echo -n "your username is , use this to login your account" | wc -m)-${#uName})/2))
echo -n "your username is "
setterm -foreground red
echo -n $uName
setterm -foreground cyan
echo -n ", use this to login your account"

echo "$uName:${sName[*]}:${gName[*]}:${mName[*]}:$passDB" >> UserAccounts.db

echo "$(date +"%T %D") - $uName - Account Registered" >> Actions.log

tput cup 25 0

sleep 2

echo -n "press any key to continue..."
stty -echo
unset PROMPT
while mask= read -p "$PROMPT" -r -s -n 1 CHAR
do
	break
done
stty echo
	
exit