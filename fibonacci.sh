#!/bin/bash

if [ -z "$1" ]; then
	echo "Script don't have input argument, please provide one"
	exit 1
fi

if [ "$1" -lt 0 ]; then
	echo "Argument must be number greater then or equale to 0"
	exit 1
fi

fibonnaci_function() {
	local n=$1
	if [ $n -le  0 ]; then
		echo 0	
	elif [ $n -eq 1 ]; then
		echo 1	
	else 	
		local n1=$(fibonnaci_function $(( $n - 1 )))
		local n2=$(fibonnaci_function $(( $n - 2 )))
		echo $(( $n1 + $n2  ))

	fi
}

fibonacci() {
    local n=$1
    if [ $n -le 0 ]; then
        echo "0"
    elif [ $n -eq 1 ]; then
        echo "1"
    else
        local a=0
        local b=1
        for ((i=2; i<=n; i++)); do
            temp=$((a + b))
            a=$b
            b=$temp
        done
        echo $b
    fi
}

echo "Fibonacci of $1: $(fibonnaci_function $1)"

