#! /bin/bash

find -name WAVECAR -exec du -sh "{}" \;
find -name CHGCAR -exec du -sh "{}" \;
find -name CHG -exec du -sh "{}" \;


ESC_SEQ="\x1b["
COL_RED=$ESC_SEQ"31;01m"
COL_RESET=$ESC_SEQ"39;49;00m"

echo -e $COL_RED"*** WARNING - compression can take a long time"$COL_RESET
for x in 5 4 3 2 1 0; do
    echo -n $x
    echo -n " "
    sleep 0.5
done

# Here we are assuming that there is one WAVECAR per directory, and that 
# the CHGCAR and TMPCAR will be in the same directory.  This is a fair
# assumption unless something weird is happening.
#
find -name WAVECAR -execdir sh -c "time 7za a -t7z -mx=9 -md=32m -mfb=64 \
 -ms=on wavecars.7z WAVECAR CHGCAR ; rm WAVECAR CHGCAR" \;



