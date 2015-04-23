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
    echo "Processing PIMD run #${x}..."
    mkdir -p joined
    # First, a separate file with the forces for each image.
    # Each line in this file is another timestep.
    for im in `seq 1 $nimages`; do
      if [ $im -lt 10 ]; then
        im="0$im"
      fi
      echo "Extracting forces from  image #${im}..."
      if [ -f ${im}/OUTCAR ]; then
        outcarfn="OUTCAR"
      else
        outcarfn="OUTCAR.gz"
      fi
      zgrep -A2 "TOTAL-FORCE" ${im}/${outcarfn} | 
           awk '{if(NF==6) print $6}' |
           tail -n +2 > ${im}/forcesZ.dat
      #vasp-getZforces.py ${im}/OUTCAR 1 > ${im}/forcesZ.dat
    done
    # Average across these files (images) to get the centroid force.
    echo "Computing centroid forces..."
    avg_files.py $nimages forcesZ.dat > joined/centroid_forcesZ.dat
    # Now (consider) to join this .dat file with previous ones.
    if [ ${x} -eq 2 ]; then
      echo "Joining $((x-1)) with ${x}..."
      cd joined
        cat ../../1/joined/centroid_forcesZ.dat centroid_forcesZ.dat > jcentroid_forcesZ.dat
      cd ..
    fi

    if [ ${x} -gt 2 ]; then
      echo "Joining $((x-1)) with ${x}..."
      cd joined
        cat ../../$((x-1))/joined/jcentroid_forcesZ.dat centroid_forcesZ.dat > jcentroid_forcesZ.dat
      cd ..
    fi

  cd .. # finished with this run
done


