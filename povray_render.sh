#! /bin/bash


for x in $(ls *.pov); do
  povray +W656 +H832 +X +A +FN -I${x} \
    Display=False Quality=11 Sampling_Method=2 Antialias_Threshold=2 
  counter=$((counter+1))
done

