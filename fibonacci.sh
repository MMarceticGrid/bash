#!/bin/bash

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

