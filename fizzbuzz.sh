#!/bin/bash

COUNT=1

while [ $COUNT -le 100 ]
do
	if [ $(($COUNT % 3)) -eq 0 ] && [ $(($COUNT % 5)) -eq 0 ]; then
		echo "FizzBuzz"
	elif  [ $(($COUNT % 3)) -eq 0 ]; then
		echo "Fizz"
	elif [ $(($COUNT % 5)) -eq 0 ]; then 
		echo "Buzz"
	else
		echo "$COUNT"
	fi
	
	COUNT=$(( $COUNT + 1 ))
done	
