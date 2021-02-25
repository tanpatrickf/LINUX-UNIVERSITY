#!/bin/bash
#This script displays the activity logs

Banner(){

	clear
	figlet -ctf slant "LINUX UNIVERSITY"
	tput cup 6 $(((STTYWidth-$(echo -n "Activity Logs" | wc -m))/2))
	echo -n "Activity Logs"
}

readarray aLogArray < <(cat Actions.log)
numOfIndices=$(echo ${#aLogArray[*]})
for ((x=0; x<numOfIndices; x++))
do
	indexTracker[$x]=$((x+1))
done

pager=0

while true
do
	Banner
	tput cup 8 0
	for ((x=0; x<10; x++))
	do
		echo -ne "${aLogArray[$x+$pager]}"
	done
	
	tput cup 20 0
	echo -ne "Choose an Action [0] to Return \n[j/k] up/down by one line\n[h/l] up/down by one page"
	
	setterm -cursor off
	stty -echo
	unset PROMPT
	unset action
	unset char
	while mask= read -p "$PROMPT" -r -s -n 1 CHAR
	do
		if [[ $CHAR == [jJ] ]]
		then
			if ((pager<(numOfIndices-10)))
			then
				((pager++))
			fi
			continue 2			
		elif [[ $CHAR == [kK] ]]
		then
			if ((pager>0))
			then
				((pager--))
			fi
			continue 2
		elif [[ $CHAR == [hH] ]]
		then
			if ((pager<(numOfIndices-10)))
			then
				if (((pager+10)>(numOfIndices-10)))
				then
					pager=$((numOfIndices-10))
				else
					pager=$((pager+10))
				fi
			fi
			continue 2			
		elif [[ $CHAR == [lL] ]]
		then
			if ((pager>0))
			then
				if (((pager-10)<0))
				then
					pager=0
				else
					pager=$((pager-10))
				fi
			fi
			continue 2
		elif [[ $CHAR == '0' ]]
		then
			unset aLogArray
			unset indexTracker
			setterm -cursor on
			stty echo
			break 2
		fi
	done
done
