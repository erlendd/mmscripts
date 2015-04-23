#! /bin/bash

if [ $# -lt 2 ]; then
  echo "Usage: mkv5mov.sh <nimages> <nions>"
  exit
fi


nimages=$1
nions=$2


vasp5_merge_pimd_poscar.py $nimages $nions > joined/POSCAR

vasp_xdat2xdatv_pimd.py $nimages

vasp5_merge_pimd.py $nimages $nions > joined/XDATCAR

sed '/Direct/d' joined/XDATCAR > joined/XDATCAR_

