#!/bin/bash

OPERATOR=""
NUMBERS=""
RESULT=0

#Example call: operate -o + -n "2 3 5" => 10 

while getopts "o:n:d" opt;do
	case $opt in
		o) 
			OPERATOR=$OPTARG
			;;
		n)
			NUMBERS=($OPTARG)
			;;
		d)
			echo "User: `whoami`"
			echo "Script: operate.sh"
			echo "Operation: $OPERATOR"
			echo "Numbers: ${NUMBERS[@]}"
			echo "------------------------"
			;;
		\?)
			echo "Invalid options"
			;;
	esac
done


if [[ ! "$OPERATOR" =~ ^[+\-\*/%]+$ ]]; then
  echo "Invalid operator. Please use one or more of the following: +, \\-, \\*, %"
  exit 1
fi

if [ ${#NUMBERS[@]} -le 1 ];then
	echo "Invalid number of parameters for numbers, the minimum is 2"
	exit 1
fi

for NUMBER in ${NUMBERS[@]};do
	if [ $NUMBER -eq ${NUMBERS[0]} ];then
					RESULT=$NUMBER
					continue
	fi
	RESULT=$(($RESULT $OPERATOR $NUMBER))
done

echo "Result of operation is: $RESULT"
