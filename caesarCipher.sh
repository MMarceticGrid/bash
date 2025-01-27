#!/bin/bash

SHIFT=""
INPUTFILE=""
OUTPUTFILE=""

SLETTERS="abcdefghijklmnopqrstuvwxyz"
BLETTERS="ABCDEFGHIJKLMNOPQRSTUVWXYZ"

while getopts "s:i:o:" opt;do
	case $opt in
		s)
			SHIFT=$OPTARG
			SHIFT=$(($SHIFT % 26))
			echo "$SHIFT"
			if [ $SHIFT -lt 0 ];then
				echo "Shift value must be positive."
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
			exit 1
			;;	
	esac
done
		
if [ ! -f "$INPUTFILE" ]; then
  echo "Input file that you pass for input argument doesn't exist."
	exit 1
fi
text=$(cat "$INPUTFILE")

if [ $SHIFT -eq 0 ]; then
	echo "$text" > "$OUTPUTFILE"
	exit 0
fi

START=${SLETTERS:$SHIFT:1}
END=${SLETTERS:(SHIFT - 1):1}
START2=${BLETTERS:$SHIFT:1}
END2=${BLETTERS:(SHIFT - 1):1}

echo "$text" | tr "a-z" "$(echo $SLETTERS | cut -c$(($SHIFT+1))-)$(echo $SLETTERS | cut -c1-$SHIFT)" \
             | tr "A-Z" "$(echo $BLETTERS | cut -c$(($SHIFT+1))-)$(echo $BLETTERS | cut -c1-$SHIFT)" \
             > "$OUTPUTFILE"
