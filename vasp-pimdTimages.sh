#! /bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: vasp-pimdTimages.sh <nimages>."
  echo "Outputs T.dat into each image directory and averages to Tav.dat."
  exit
fi


nimages=$1

echo "Getting temperatures for image: "
for x in $(seq 1 $nimages); do
  if [ $x -lt 10 ]; then
    x="0$x";
  fi;
  echo -n "$x "
  grep \(temperature $x/OUTCAR | awk '{print $7}' > $x/T.dat; 
done

echo "Averaging (Tav.dat) ..."
avg_files.py $nimages T.dat > Tav.dat


