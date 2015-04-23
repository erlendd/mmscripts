#! /bin/bash

###
# Extracts the final energy of the system
###

if [ -z $1 ]; then
    echo "Extracts the final energy of the system."
    echo "Usage: $0 [OSZICAR]"
    exit 1
fi

OSZ=$1

ELINE=`tail -n-1 ${OSZ}`
Energy=`echo $ELINE | cut -d' ' -f5-5`
echo $Energy

