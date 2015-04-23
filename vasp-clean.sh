#! /bin/bash

ESC_SEQ="\x1b["
COL_RED=$ESC_SEQ"31;01m"
COL_RESET=$ESC_SEQ"39;49;00m"

echo -e $COL_RED"*** WARNING - deleting VASP output!"$COL_RESET
for x in 5 4 3 2 1 0; do
    echo -n $x
    echo -n " "
    sleep 0.5
done

echo

rm CHG CHGCAR CONTCAR DOSCAR EIGENVAL IBZKPT OSZICAR OUTCAR PCDAT WAVECAR XDATCAR vasprun.xml

