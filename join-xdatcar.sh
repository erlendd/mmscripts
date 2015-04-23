#! /bin/bash

counter=0
natoms=0

for xdat in $@; do
  echo ${xdat}
  if [ ${counter} == 0 ]; then
    # read the header of the first
    head -n6 ${xdat} > XDATCAR.joined  
    natoms=`head -n1 ${xdat} | cut -d' ' -f3`
  fi
  tail -n+7 ${xdat} >> XDATCAR.joined
  counter=$((counter+1))
done

