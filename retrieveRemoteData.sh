#! /bin/bash

## 'ls' is problematic: the error returned on no matching files is a line! 
#mithras=`ls mithras*`
#legion=`ls legion*`
## Use 'find' instead, with -maxdepth 1 to prevent recursion,
mithras=`find -maxdepth 1 -name "mithras*"`
legion=`find -maxdepth 1 -name "legion*"`
hectorv=`find -maxdepth 1 -name "hectorv*"`

nMITHRAS=`echo ${MITHRAS} | wc -l`
nLEGION=`echo ${LEGION} | wc -l`
nHECTORV=`echo ${HECTORV} | wc -l`
if [ $((nMITHRAS+nLEGION+nHECTORV)) -gt 2 ]; then
    echo "Error: there are multiple jobs associated with ${PWD}!"
    exit 1
fi

machineList="mithras legion"

echo "Processing..."
for machine in $machineList; do
    for m in ${!machine}; do
        mpath=/mnt/${machine}/jobs/`cat ${m}*`
        if [ -z ${mpath}/OSZICAR ]; then
            echo "${mpath}/OSIZCAR does not exist."
            echo "Has this run already been moved to local?"
            exit 1
        fi
        mv -v ${mpath}/* .
    done
done

