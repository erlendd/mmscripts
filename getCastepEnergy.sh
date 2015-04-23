#! /bin/bash

CFILE=$1

# as always, check the output file for errors
erCheckCastep.sh "${CFILE}"

if [ $? -ne '0' ]; then
    exit 1
fi


EnLINE=`grep "Final energy" "${CFILE}" | tail -1`

#ENERGY=`echo ${EnLINE} | cut -f18- -d ' ' | cut -b-15`
ENERGY=`echo ${EnLINE} | cut -f5- -d ' ' | cut -b-15`

ENERGY=`grep "Final energy" "${CFILE}" | tail -1 | cut -f5- -d ' ' | cut -b-15`

echo $ENERGY

exit 0


