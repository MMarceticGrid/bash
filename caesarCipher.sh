#!/bin/bash

SHIFT=""
INPUTFILE=""
OUTPUTFILE=""

SLETTERS="abcdefghijklmnopqrstuvwxyz"
BLETTERS="ABCDEFGHIJKLMNOPQRSTUVWXYZ"

while getopts "s:i:o:" opt;do
	case $opt in
		s)
			SHIFT=$(($OPTARG % 26))
			if [ $SHIFT -le 0 ];then
				echo "You can not shift negativ"
				exit 1
			fi
			;;
		i)
			INPUTFILE=$OPTARG
			;;
		o)
			OUTPUTFILE=$OPTARG
			;;
		\?)
			echo "Invalid options"
			exit1
			;;	
	esac
done
		
if [ ! -f "$INPUTFILE" ] || [ ! -f "$OUTPUTFILE" ]; then
  echo "First you have to create a files and then forward it."
	exit 1
fi

while IFS= read -r line; do 
			START=${SLETTERS:$SHIFT:1}
			END=${SLETTERS:$(($SHIFT - 1)):1}
			START2=${BLETTERS:$SHIFT:1}
			END2=${BLETTERS:$SHIFT:1}
     	echo "$line" | tr "[a-z]" "[$START-z-$END]" | tr "[A-Z]" "[$START2-Z-$END2]">>"$OUTPUTFILE"
done < "$INPUTFILE"	
			
