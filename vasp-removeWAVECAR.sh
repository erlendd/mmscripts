#! /bin/bash

find -name WAVECAR -exec du -sh "{}" \;
find -name CHGCAR -exec du -sh "{}" \;
find -name CHG -exec du -sh "{}" \;
find -name TMPCAR -exec du -sh "{}" \;


ESC_SEQ="\x1b["
COL_RED=$ESC_SEQ"31;01m"
COL_RESET=$ESC_SEQ"39;49;00m"

echo -e $COL_RED"*** WARNING - deleting above files in "$COL_RESET
for x in 5 4 3 2 1 0; do
    echo -n $x
    echo -n " "
    sleep 0.5
done

echo

find -name WAVECAR -exec rm "{}" \;
find -name CHGCAR -exec rm "{}" \;
find -name CHG -exec rm "{}" \;
find -name TMPCAR -exec rm "{}" \;

