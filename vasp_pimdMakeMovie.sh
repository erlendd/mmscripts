#! /bin/bash

nimages=$1
nions=$2

echo "nimages = $nimages"
echo "nions = $nions"
echo

mkdir -p joined

vasp_xdat2xdatv_pimd.py $nimages

vasp5_merge_pimd.py $nimages $nions > joined/XDATCAR
vasp5_merge_pimd_poscar.py $nimages $nions > joined/POSCAR





