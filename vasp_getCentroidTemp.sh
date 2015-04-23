#! /bin/bash

nimages=$1

for x in $(seq 1 $nimages); do
  if [ $x -lt 10 ]; then
    x="0$x";
  fi;
  grep \(temperature $x/OUTCAR | awk '{print $7}' > $x/T.dat; 
done


avg_files.py $nimages T.dat > joined/T_cent.dat


