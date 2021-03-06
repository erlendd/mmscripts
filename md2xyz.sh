#! /bin/bash

if [ -z $3 ]; then
    echo "Usage: $0 <.md file> <N-atoms> [Atom names]"
    exit 1
fi

IFILE=$1
N=$2
COUNTER=0
argCounter=1
L=`grep "<-- R" "${IFILE}"`

echo $N
echo "${IFILE} (Created with Erlend's md2xyz.sh bash script)."

for x in $L; do
    # if this is a position...
    if [ `echo $x | grep -c "+"` -gt 0 ]; then
        # beginning of line: insert atom symbol
        if [ $COUNTER -eq 0 ]; then
            if [ $argCounter -gt $N ]; then
                argCounter=1
                echo $N
                echo "Frame..."
            fi
            thisArg=$((argCounter+2))
            echo -n "${!thisArg} "
            argCounter=$((argCounter+1))
        fi                            
        COUNTER=$((COUNTER+1))
        echo -n $x
        if [ $COUNTER -eq $N ]; then
            COUNTER=0
            echo " "
        else
            echo -n " "
        fi
    fi
done

