#! /bin/bash

ffiles=`ls *_f`

for x in $ffile; do
    vasp-dipoleIRAS.pl $x
done

