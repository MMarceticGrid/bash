#!/bin/bash

FIRST=0
INPUTFILE=""
OUTPUTFILE=""
WORD_A=""
WORD_B=""
while getopts "i:o:vs:rlu" opt; do	
	case $opt in
		i)
			INPUTFILE=$OPTARG
			if [ ! -f $INPUTFILE ]; then
					echo "Input file doesn't exist"
					exit 1
			fi
			;;
		o)
			OUTPUTFILE=$OPTARG
			;;
		v)
			if [ $FIRST -ne 0 ];then
				INPUTFILE=$OUTPUTFILE
			fi
			cat "$INPUTFILE" | tr '[a-zA-Z]' '[A-Za-z]' > "$OUTPUTFILE"
			FIRST=1
			;;
		s)
  		if [ $FIRST -ne 0 ]; then
    		INPUTFILE=$OUTPUTFILE
  		fi
  		if [ -z "$OPTARG" ] || [ $(echo "$OPTARG" | awk '{print NF}') -ne 2 ]; then
    		echo "Error: -s option requires two words to replace (e.g., -s 'word1 word2')"
    		exit 1
  		fi
  		WORDS=($OPTARG)
  		WORD_A=${WORDS[0]}
  		WORD_B=${WORDS[1]}
  		sed "s/$WORD_A/$WORD_B/g" "$INPUTFILE" > "$OUTPUTFILE"
  		FIRST=1
  		;;

		l)
			if [ $FIRST -ne 0 ];then
				INPUTFILE=$OUTPUTFILE
			fi
			cat "$INPUTFILE" | tr '[A-Z]' '[a-z]' > "$OUTPUTFILE"
			FIRST=1
			;;
		u)
			if [ $FIRST -ne 0 ];then
				INPUTFILE=$OUTPUTFILE
			fi
			cat "$INPUTFILE" | tr '[a-z]' '[A-Z]' > "$OUTPUTFILE"
			FIRST=1
			;;
		r)
			if [ $FIRST -ne 0 ];then
				INPUTFILE=$OUTPUTFILE
			fi
			tac "$INPUTFILE" > "$OUTPUTFILE"
			;;
	esac
done

