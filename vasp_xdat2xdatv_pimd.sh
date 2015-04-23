#! /bin/bash



for x in 01 02 03 04 05 06 07 08 09 10 11 12; do
  cd ${x}; vasp_xdat2xdatv.py > XDATCAR_
  cd ..
done

