#! /usr/bin/python

######################################################
# Author: Erlend Davidson <Erlend.Davidson[]ucl.ac.uk>
# Date: 27/03/09
#
# Reads the "forces" file and an 1_f, 2_f... file.
# Finds the projection of the force along the direction 
# of the vibrational mode.
#
# This checks the validity of a finite displacement calculation
#
#
###

import sys
import os
import re

if len(sys.argv) < 3:
    print "Usage: "+sys.argv[0]+" <n_f> i"
    print "       where n is the nth frequency mode, and i the number of ions"
    print "       for which to calculate the projected force."
    sys.exit(1)

file = sys.argv[1]
infile = open(file,"r",0)

natoms = int(sys.argv[2])

iforcefilename = "forces"
iforcefile = open(iforcefilename,"r",0)

space = re.compile(r'\s+');

for i in range(natoms):
    # first split the i^{th} line of forces
    # NB: first 3 indices will be positions, last 3 the forces.
    posforceline = iforcefile.readline().strip()
    if not posforceline: break
    posforces = space.split(posforceline)
    # now we need the eigenmodes (vectors) from n_f
    modesline = infile.readline().strip()
    modes = space.split(modesline)
    # now dot_product: F.mode
    dot=0.0
    for i in range(len(modes[2:6])-1):
        dot = dot + float(posforces[3+i]) * float(modes[3+i])
    print dot
