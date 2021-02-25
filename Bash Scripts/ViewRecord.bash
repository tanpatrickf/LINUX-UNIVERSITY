#!/bin/bash
#This script displays information stored in the student record

x=0
str[0]=""
str[1]="Choose Between the Given Choiches Only"
str[2]="Entry Must Be Less Than 10 Characters in Length"
str[3]="Entry Must Not Contain Alphabetic Characters"
str[4]="No Record Matched Your Input"

input=1

Banner(){

	clear
	figlet -ctf slant "LINUX UNIVERSITY"
	tput cup 6 $(((STTYWidth-$(echo -n "View Record" | wc -m))/2))
	echo -n "View Record"
	
	tput cup 8 0
	setterm -foreground red
	echo -ne ${str[x]}
	setterm -foreground cyan
	x=0
}

#Accepts parameters
#First parameter: determines if second parameter is an index or a student information
#Second parameter: index or student information to display
#Third parameter: what field should be matched
# Loader(){
# 
# 	if (($1==0))
# 	then
# 		sInforLine=$2
# 	else
# 		sInfoLine=$(cut -f$1 -d: StudentRecord.db | grep -ni $2 | cut -f1 -d:)
# 	fi
# 	sName=$(head -$sInfoLine StudentRecord.db | tail -1 | cut -f2 -d:)
# 	gName=$(head -$sInfoLine StudentRecord.db | tail -1 | cut -f3 -d:)
# 	mName=$(head -$sInfoLine StudentRecord.db | tail -1 | cut -f4 -d:)
# 	hAdd=$(head -$sInfoLine StudentRecord.db | tail -1 | cut -f5 -d:)
# 	bDate=$(head -$sInfoLine StudentRecord.db | tail -1 | cut -f6 -d:)
# 	
# 	tput 11 0
# 	echo "1. Student Number: $sNum"
# 	echo "2. Surname: $sName"
# 	echo "3. Given Name: $gName"
# 	echo "4. Middle Name: $mName"
# 	echo "5. Home Address: $hAdd"
# 	echo "6. Birthdate: $bDate"
# }

ChooseFunction(){
	
	if ((input==1))
	then
		tput cup 10 $(((STTYWidth-$(echo -n "a. Sort Record                          b. Search Record" | wc -m))/2))
		echo -n "a. Sort Record                          b. Search Record"
		
		tput cup 21 0
		echo -ne "Choose an Action\n[0] to Return to Main Menu: "
		read action
		case $action in
			a|A)	input=2	;;
			b|B)	input=3	;;
			0)	exit	;;
			*)	x=1	;;
		esac
		continue
	fi
}

Sort(){

	if ((input==2))
	then
		tput cup 10 $(((STTYWidth-$(echo -n "a. Sort By Student Number                    b. Sort By Name" | wc -m))/2))
		echo -n "a. Sort By Student Number                    b. Sort By Name"
		
		tput cup 21 0
		echo -ne "Choose an Action\n[0] to Return to Previous Option: "
		read action
		case $action in
			a|A)	input=4	;;
			b|B)	input=5	;;
			0)	input=1	;;
			*)	x=1	;;
		esac
		continue
		
	elif ((input==4))
	then
		SortByNum
	elif ((input==5))
	then
		SortByName	
	fi
		
}

SortByNum(){

	if ((input==4))
	then
		readarray sNumArray < <(cut -f1 -d: StudentRecord.db)
		numOfIndices=$(echo ${#sNumArray[*]})
		for ((x=0; x<numOfIndices; x++))
		do
			indexTracker[$x]=$((x+1))
		done
	elif ((input==6))
	then
		readarray sNumArray < <(cut -f1 -d: StudentRecord.db | grep $sNum)
		readarray indexTracker < <(cut -f1 -d: StudentRecord.db | grep -n $sNum | cut -f1 -d:)
		numOfIndices=$(echo ${#sNumArray[*]})
	fi
	
	pager=0
	
	for ((x=0; x<numOfIndices; x++))
	do
		for ((y=0; y<numOfIndices-x-1; y++))
		do
			if ((sNumArray[y]>sNumArray[y+1]))
			then
				tmp=${sNumArray[y]}
				sNumArray[y]=${sNumArray[y+1]}
				sNumArray[y+1]=$tmp
				
				tmp=${indexTracker[y]}
				indexTracker[y]=${indexTracker[y+1]}
				indexTracker[y+1]=$tmp
			fi
		done
	done
	
	for ((x=0; x<numOfIndices; x++))
	do
		sNumSort[x]=$(head -${indexTracker[$x]} StudentRecord.db | tail -1 | cut -f1 -d:)
		sNameSort[x]=$(head -${indexTracker[$x]} StudentRecord.db | tail -1 | cut -f2 -d:)
		gNameSort[x]=$(head -${indexTracker[$x]} StudentRecord.db | tail -1 | cut -f3 -d:)
		mNameSort[x]=$(head -${indexTracker[$x]} StudentRecord.db | tail -1 | cut -f4 -d:)
		
		sortedRecord[x]="\t$((x+1)).\t${sNumSort[x]} - ${sNameSort[x]}, ${gNameSort[x]} (${mNameSort[x]})"
	done
	
	
	while true
	do
		clear
		tput cup 1 $(((STTYWidth-$(echo -n "LINUX UNIVERSITY" | wc -m))/2))
		echo -n "LINUX UNIVERSITY"
		if ((input==4))
		then
			tput cup 4 $(((STTYWidth-$(echo -n "SORT BY STUDENT NUMBER" | wc -m))/2))
			echo -n "SORT BY STUDENT NUMBER"
		elif ((input==6))
		then
			tput cup 4 $(((STTYWidth-$(echo -n "SEARCH RECORD THAT CONTAINS   " | wc -m)-${#sNum})/2))
			echo -n "SEARCH RECORD THAT CONTAINS '"
			setterm -foreground red
			echo -n $sNum
			setterm -foreground cyan
			echo -n "'"
		fi
		
		tput cup 8 0
		for ((x=0; x<10; x++))
		do
			echo -ne "${sortedRecord[$x+$pager]}\n"
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
				unset sNumArray
				unset indexTracker
				unset sortedRecord
				if ((input==4))
				then
					echo "$(date +"%T %D") - $uName - Viewed Student Record (Sorted by Student Number)" >> Actions.log
					input=2
				elif ((input==6))
				then
					echo "$(date +"%T %D") - $uName - Searched Student Record Containing \"$sNum\"" >> Actions.log
					input=3
				fi
				setterm -cursor on
				stty echo
				break 2
			fi
		done
	done
}

SortByName(){

	if ((input==5))
	then
		readarray sNameArray < <(cut -f2-4 -d: StudentRecord.db | tr ":" "-" | tr " " "+")
		numOfIndices=$(echo ${#sNameArray[*]})
		for ((x=0; x<numOfIndices; x++))
		do
			indexTracker[$x]=$((x+1))
		done
		
	elif ((input==7))
	then
		readarray sNameArray < <(cut -f2-4 -d: StudentRecord.db | grep -i $sName | tr ":" "-" | tr " " "+")
		readarray indexTracker < <(cut -f2-4 -d: StudentRecord.db | grep -ni $sName | cut -f1 -d:)
		numOfIndices=$(echo ${#sNameArray[*]})
	fi
	
	pager=0
	
	for ((x=0; x<numOfIndices; x++))
	do
		for ((y=0; y<numOfIndices-x-1; y++))
		do
			z=0
			while [[ ${sNameArray[y]:z:1} == ${sNameArray[y+1]:z:1} ]]
			do
				((z++))
				if ((z+1==${#sNameArray[y]})) || ((z+1==${#sNameArray[y+1]}))
				then
					break
				fi
			done
			
			if [[ ${sNameArray[y]:z:1} > ${sNameArray[y+1]:z:1} ]]
			then
				tmp=${sNameArray[y]}
				sNameArray[y]=${sNameArray[y+1]}
				sNameArray[y+1]=$tmp
				
				tmp=${indexTracker[y]}
				indexTracker[y]=${indexTracker[y+1]}
				indexTracker[y+1]=$tmp
			fi
		done
	done
	
	for ((x=0; x<numOfIndices; x++))
	do
		sNumSort[x]=$(head -${indexTracker[$x]} StudentRecord.db | tail -1 | cut -f1 -d:)
		sNameSort[x]=$(head -${indexTracker[$x]} StudentRecord.db | tail -1 | cut -f2 -d:)
		gNameSort[x]=$(head -${indexTracker[$x]} StudentRecord.db | tail -1 | cut -f3 -d:)
		mNameSort[x]=$(head -${indexTracker[$x]} StudentRecord.db | tail -1 | cut -f4 -d:)
		
		sortedRecord[x]="\t$((x+1)).\t${sNumSort[x]} - ${sNameSort[x]}, ${gNameSort[x]} (${mNameSort[x]})"
	done
	
	
	while true
	do
		clear
		tput cup 1 $(((STTYWidth-$(echo -n "LINUX UNIVERSITY" | wc -m))/2))
		echo -n "LINUX UNIVERSITY"
		
		if ((input==5))
		then
			tput cup 4 $(((STTYWidth-$(echo -n "SORT BY STUDENT NAME" | wc -m))/2))
			echo -n "SORT BY STUDENT NAME"
		elif ((input==7))
		then
			tput cup 4 $(((STTYWidth-$(echo -n "SEARCH RECORD THAT CONTAINS   " | wc -m)-${#sName})/2))
			echo -n "SEARCH RECORD THAT CONTAINS '"
			setterm -foreground red
			echo -n $sName
			setterm -foreground cyan
			echo -n "'"
		fi
		
		tput cup 8 0
		for ((x=0; x<10; x++))
		do
			echo -ne "${sortedRecord[$x+$pager]}\n"
		done
		
		tput cup 20 0
		echo -ne "Choose an Action [0] to exit \n[j/k] up/down by one line\n[h/l] up/down by one page"
		
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
				unset sNameArray
				unset indexTracker
				unset sortedRecord
				if ((input==5))
				then
					echo "$(date +"%T %D") - $uName - Viewed Student Record (Sorted by Student Name)" >> Actions.log
					input=2
				elif ((input==7))
				then
					echo "$(date +"%T %D") - $uName - Searched Student Record Containing \"$sName\")" >> Actions.log
					input=3
				fi
				setterm -cursor on
				stty echo
				break 2
			fi
		done
	done
}

Search(){

	if ((input==3))
	then
		tput cup 10 $(((STTYWidth-$(echo -n "a. Search By Student Number                  b. Search By Name" | wc -m))/2))
		echo -n "a. Search By Student Number                  b. Search By Name"
		
		tput cup 21 0
		echo -ne "Choose an Action\n[0] to Return to Previous Option: "
		read action
		case $action in
			a|A)	input=6	;;
			b|B)	input=7	;;
			0)	input=1	;;
			*)	x=1	;;
		esac
		continue
	
	elif ((input==6))
	then
		SearchByNum
	elif ((input==7))
	then
		SearchByName
	fi
}

SearchByNum(){

	tput cup 12 0
	echo -n "Enter Student Number: "
	read sNum
	
	if ((${#sNum}>10))
	then
		x=2
		continue
	elif [[ $sNum == *[^0-9]* ]]
	then
		x=3
		continue
	fi
	
	cut -f1 -d: StudentRecord.db | grep -qi $sNum
	if (($?!=0))
	then
		x=4
		continue
	fi
	
	hit=$(cut -f1 -d: StudentRecord.db | grep -c $sNum)
	
# 	if((hit==1))
# 	then
# 		Loader 1 $sNum
# 	fi
	
	SortByNum
}

SearchByName(){

	tput cup 12 0
	echo -n "Enter Student Name: "
	read sName
	
	if [[ ${sName[*]} == *[^a-zA-Z." "]* ]]
	then
		x=3
	fi
	
	cut -f2-4 -d: StudentRecord.db | grep -qi $sName
	if (($?!=0))
	then
		x=4
		continue
	fi
	
	hit=$(cut -f2-4 -d: StudentRecord.db | grep -c $sName)
	
# 	if((hit==1))
# 	then
# 		Loader 2 $sN
# 	fi
	
	SortByName

	
}

while true
do
	Banner
	
	ChooseFunction
	Sort
	Search
	
	

done