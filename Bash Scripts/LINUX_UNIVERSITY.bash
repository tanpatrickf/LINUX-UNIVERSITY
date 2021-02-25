#!/bin/bash
#This script is the main program of the LINUX UNIVERSITY student record

setterm -foreground cyan -cursor off -clear all

export uName

STTYWidth=$(tput cols)

export STTYWidth


Banners(){
	row=10
	SubHeader="Student Record"
	SubHeaderLen=${#SubHeader}

	while ((row>=3))
	do
		clear
		tput cup $row 0
		figlet -ctf slant "LINUX UNIVERSITY"
		tput cup $((row+6)) 0
		printf "%*s\n" $(((SubHeaderLen+STTYWidth)/2)) "$SubHeader"
		sleep 0.08

		tput cup 25 0
		if ((pressed!=1))
		then
			echo -n "press any key to continue..."
			stty -echo
			unset PROMPT
			while mask= read -p "$PROMPT" -r -s -n 1 CHAR
			do
				pressed=1
				break
			done
			stty echo
		fi
		((row--))
	done
	clear
	setterm -cursor on
}


Transition(){
	
	x=$row
	while ((x>=0))
	do
		clear
		tput cup $x 0
		figlet -ctf slant "LINUX UNIVERSITY"
		sleep 0.1
		((x--))
	done
}

RevTransition(){

	x=0
	while ((x<3))
	do
		clear
		tput cup $x 0
		figlet -ctf slant "LINUX UNIVERSITY"
		sleep 0.08
		((x++))
	done
}

OptionTransition(){

	optionStrLen=${#optionStr}
	x=$optionRow
	while((x!=6))
	do
		clear
		tput cup 0 0
		figlet -ctf slant "LINUX UNIVERSITY"
		
		tput cup $x 0
		printf "%*s\n" $(((optionStrLen+STTYWidth)/2)) "$optionStr"
		((x--))
		sleep $(echo "0.3/($optionRow-6)" | bc -l)
	done
}

RevOptionTransition(){

	while((x!=optionRow))
	do
		clear
		tput cup 0 0
		figlet -ctf slant "LINUX UNIVERSITY"
		
		tput cup $x 0
		printf "%*s\n" $(((optionStrLen+STTYWidth)/2)) "$optionStr"
		((x++))
		sleep $(echo "0.3/($optionRow-6)" | bc -l)
	done
}

MainMenu(){

	while true
	do
		clear
		tput cup 0 0
		figlet -ctf slant "LINUX UNIVERSITY"
		printf "%*s\n" $(((subHeaderLen+STTYWidth)/2)) "$subHeader"
		
		tput cup 7 $(((STTYWidth-$(echo -n "a. Add Record" | wc -m))/2))
		echo -n "a. Add Record"
		tput cup 9 $(((STTYWidth-$(echo -n "b. Edit Record" | wc -m))/2))
		echo -n "b. Edit Record"
		tput cup 11 $(((STTYWidth-$(echo -n "c. Delete Record" | wc -m))/2))
		echo -n "c. Delete Record"
		tput cup 13 $(((STTYWidth-$(echo -n "d. View Record" | wc -m))/2))
		echo -n "d. View Record"
		tput cup 15 $(((STTYWidth-$(echo -n "e. Load Record" | wc -m))/2))
		echo -n "e. Load Record"
		tput cup 17 $(((STTYWidth-$(echo -n "f. View Logs" | wc -m))/2))
		echo -n "f. View Logs"
		tput cup 19 $(((STTYWidth-$(echo -n "g. Logout" | wc -m))/2))
		echo -n "g. Logout"
		
		if ((error==1))
		then
			setterm -foreground red
			tput cup 21 0
			echo -n "Choose Between the Given Choices Only"
			setterm -foreground cyan
			error=0
		fi
		
		tput cup 22 0
		echo -n "Choose an Option: "
		read cat
		case $cat in
			a|A)	optionRow=7
				optionStr="Add Record"
				OptionTransition
				bash AddRecord.bash		;;
			
			b|B)	optionRow=9
				optionStr="Edit Record"
				OptionTransition
				bash EditRecord.bash		;;
			
			c|C)	optionRow=11
				optionStr="Delete Record"
				OptionTransition
				bash DeleteRecord.bash		;;
			
			d|D)	optionRow=13
				optionStr="View Record"
				OptionTransition
				bash ViewRecord.bash		;;
			
			e|E)	optionRow=15
				optionStr="Load Record"
				OptionTransition
				bash LoadRecord.bash		;;
			
			f|F)	optionRow=17
				optionStr="View Logs"
				OptionTransition
				bash ViewLogs.bash		;;
			
			g|G)	
				echo "$(date +"%T %D") - $uName - Logged out" >> Actions.log
				break			;;
			
			*)  	error=1
				continue		;;
		esac
		RevOptionTransition
	done
}

Banners

while true
do
	STTYWidth=$(tput cols)
	clear
	tput cup $row 0
	figlet -ctf slant "LINUX UNIVERSITY"
	printf "%*s\n" $(((subHeaderLen+STTYWidth)/2)) "$subHeader"

	if ((error==1))
	then
		setterm -foreground red
		tput cup 12 0
		echo -n "Choose Between the Given Choices Only"
		setterm -foreground cyan
		error=0
	fi
	
	tput cup 15 $(((STTYWidth-$(echo -n "[L]Login                               [R]Register" | wc -m))/2))
	echo "[L]Login                               [R]Register"
	tput cup 20 0
	echo -n "Choose an option [0 to exit]: "
	read option
  
	case $option in
		l|L)	Transition
			bash Login.bash
			userLine=$?
			uName=$(head -$userLine UserAccounts.db | tail -1 | cut -f1 -d:)
			if((userLine!=0))
			then
				MainMenu
			fi					;;
		r|R)	Transition
			bash Registration.bash				;;
		0)	setterm -default -cursor on -clear all
			exit					;;
			
		*)	error=1
			continue;;
	esac
	
	RevTransition
done