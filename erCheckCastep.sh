#! /bin/bash

CFILE=$1 
ERRORS=0
WARNINGS=0

# 1. check the run didn't error out...
echo "Checking ${CFILE} for errors/warnings..."

# 1.1. look for warnings...
WARNS=`grep -c -i warning "${CFILE}"`

if [ $WARNS -gt 0 ]; then
    echo "FILE CONTAINS WARNINGS"
    WARNS=$((WARNS))
fi

# 1.2. look for the end...
ENDED=`grep -c -i "Writing analysis data" "${CFILE}"`

if [ $ENDED -lt 1 ]; then
    echo "CASTEP FILE INCOMPLETE - RUN DID NOT FINISH"
    ERRORS=$((ERRORS+1))
fi
  

# print a summary
echo "=========== SUMMARY ==========="
if [ $ERRORS -gt 0 ]; then
    echo "*** FILE CONTAINS ERRORS ***"
    exit 1
else
    echo "No errors :-)"
fi

if [ $WARNINGS -gt 0 ]; then
    echo "*** FILE CONTAINS WARNINGS ***"
    exit 1
else
    echo "No warnings :-)"
fi


exit 0



