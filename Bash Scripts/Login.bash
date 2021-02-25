#!/bin/bash
#This script handles the login request of the user

subHeader="Login"
subHeaderLen=${#subHeader}

x=0
str[0]="Type \"exit\" to Return to Homepage"
str[1]="A Username Must Be Entered\nType \"exit\" to Return to Homepage"
str[2]="Username Does Not Exist"
str[3]="Type \"return\" to Re-enter Username\nor \"exit\" to Return to Homepage"
str[4]="A Password Must Be Entered\nType \"exit\" to Return to Homepage"
str[5]="Password Does Not Match\nType \"return\" to Re-enter Username"

input=1

Username(){

	tput cup 15 0
	if ((input>1))
	then
		echo -n "Username: $uName"
	else
		echo -n "Enter your Username: "
		read uName
		
		if [[ $uName == 'exit' ]]
		then
			exit 0
		elif [[ $uName == '' ]]
		then
			x=1
			continue
		fi
		
		cut -f1 -d: UserAccounts.db | grep -qxi $uName
		if (($?==0))
		then
			x=3
		else
			x=2
			continue
		fi
		userLine=$(cut -f1 -d: UserAccounts.db | grep -nxi $uName | cut -f1 -d:)
		passDB=$(head -$userLine UserAccounts.db | tail -1 | cut -f5 -d:)
		input=2
		continue
	fi
}
Password(){

	tput cup 16 0
	echo -n "Enter your Password: "
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
	if [[ $pass == 'return' ]]
	then
		input=1
		x=0
		continue
	fi
	
	if [[ $pass == 'exit' ]]
	then
		exit 0
	fi
	
	cryptPass=$(echo $pass | crypt PT 2>/dev/null)
	checkPass=${cryptPass//:/+}
	checkPass=${checkPass//$'\12'/?}
				
	if [[ $passDB == $checkPass ]]
	then
		echo "$(date +"%T %D") - $uName - Logged in" >> Actions.log
		exit $userLine
	else
		x=5
	fi
}

while true
do
	clear
	figlet -ctf slant "LINUX UNIVERSITY"
	printf "%*s\n" $(((subHeaderLen+STTYWidth)/2)) "$subHeader"
	
	tput cup 12 0
	setterm -foreground red
	echo -ne ${str[x]}
	setterm -foreground cyan
	
	Username
	Password
done
