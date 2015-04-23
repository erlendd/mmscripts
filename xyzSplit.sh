#! /bin/bash

COUNTER=0
while read line
do
    COUNTER=$(($COUNTER+1))
    if [ $COUNTER -eq 1 ]; then
        echo $line >> split.1
    fi
    if [ $COUNTER -eq 2 ]; then
        echo $line >> split.2
        COUNTER=0
    fi
done

