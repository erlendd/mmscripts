#! /bin/bash

if [ $# -lt 3 ]; then
  echo "Needs three arguments, the first and last runs to include, and the number of PIMD images"
  exit
fi


start=$1
end=$2
nimages=$3

for x in $(seq $start $end); do
  cd ${x}
    echo "Getting H-atom heights from PIMD run #${x}..."
    mkdir -p joined
    # First, a separate file with the forces for each image.
    # Each line in this file is another timestep.
    for im in `seq 1 $nimages`; do
      if [ $im -lt 10 ]; then
        im="0$im"
      fi
      echo "Extracting heights from image #${im}..."
      if [ -f ${im}/OUTCAR ]; then
        outcarfn="OUTCAR"
      else
        outcarfn="OUTCAR.gz"
      fi
      zgrep -A2 "TOTAL-FORCE" ${im}/${outcarfn} | 
           awk '{if(NF==6) print $3}' |
           tail -n +2 > ${im}/H_z.dat
      #vasp-getZforces.py ${im}/OUTCAR 1 > ${im}/forcesZ.dat
    done
    # Now (consider) to join this .dat file with previous ones.
    for im in `seq 1 $nimages`; do
      if [ $im -lt 10 ]; then
        im="0$im"
      fi
      if [ ${x} -eq 2 ]; then
        echo "Joining $((x-1))/${im} with ${x}/${im}..."
        cat ../1/${im}/H_z.dat ${im}/H_z.dat > joined/H_z_${im}.dat
      fi

      if [ ${x} -gt 2 ]; then
        echo "Joining $((x-1))/${im} with ${x}/${im}..."
        cat ../$((x-1))/joined/H_z_${im}.dat ${im}/H_z.dat > joined/H_z_${im}.dat
      fi
    done # nimages

  cd .. # finished with this run
done


