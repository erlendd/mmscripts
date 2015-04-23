#! /bin/bash

#echo "Calculating dipole intensities..."
#vasp-calcDipoleIntensity.sh > dipoleIntensities
echo "Calculating frequencies and displacements..."
vasp-extractFreqDisp.py OUTCAR

echo "Calculating movie (xyz) file..."
FREQFILES=`ls *_f`

for x in ${FREQFILES}; do
    echo "Generating xyz file for $x"
    fmovie-erl.pl ${x}
done

echo "You can now run \"vmd n_f.xyz\" to see the vibrations."

