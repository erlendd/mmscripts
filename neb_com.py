#! /usr/bin/env python

import os
import time
import sys
import re
from math import sqrt
from math import atan
from math import sin
from math import cos
from math import degrees

if len(sys.argv) < 2:
    print "Usage: "+sys.argv[0]+" <POSCAR>"
    sys.exit(1)

##############
## This script finds the Centre of Mass for the first two atoms in POSCAR.
## You will need to edit below
##############
m1 = 1
m2 = 16
cellx = 10.88039999999
celly = 7.693604622022
cellz = 17.84680200000

file1 = sys.argv[1]
#file2 = sys.argv[2]
ifile1 = open(file1, "r", 0)
#ifile2 = open(file2, "r", 0)

# read both input files
ffile = ifile1.readlines()
#sfile = ifile2.readlines()

# the interesting data is on lines 8 and 9 (counting from 0)
Hf = ffile[8]
Of = ffile[9]
#Hs = sfile[8]
#Os = sfile[9]

# to deal with multiple spaces
space = re.compile(r'\s+')

# split that data up, giving xyz for the species
speciesOne_init = space.split(Hf.strip())
#speciesOne_fin = space.split(Hs.strip())
speciesTwo_init = space.split(Of.strip())
#speciesTwo_fin = space.split(Os.strip())
#print speciesOne_init
#print speciesTwo_init


# now calculate the bond length
# NB: special case: ignore y-axis!
x = abs( float(speciesOne_init[0]) - float(speciesTwo_init[0]) )*cellx
z = abs( float(speciesOne_init[2]) - float(speciesTwo_init[2]) )*cellz
###print x,z
l = sqrt( x**2 + z**2 )
###print l

# find theta (angle of adsorbate from the vertical)
theta = atan( x/z )
###print degrees(theta)

# finally, find the CoM as vector, rel. to the first atom
mratio = float(m2)/float(m1+m2)
com_x = (l*mratio)*sin(theta)
com_z = (l*mratio)*cos(theta)
com_y = 0.0
###print com_x,com_y,com_z

# convert CoM vector to fractional coords
com_x_frac = com_x/cellx
com_y_frac = 0.0
com_z_frac = com_z/cellz
###print com_x_frac, com_y_frac, com_z_frac


## add this vector to the position of the first atom
#COMx = float(speciesOne_init[0]) + com_x_frac
#COMy = float(speciesOne_init[1]) + com_y_frac
#COMz = float(speciesOne_init[2]) - com_z_frac

# alternatively, COM in Angstroms
COMx = float(speciesOne_init[0])*cellx - com_x
COMy = float(speciesOne_init[1])
COMz = float(speciesOne_init[2])*cellz - com_z


print COMx
print COMy
print COMz

