#!/usr/bin/env python
import os
import time
import sys
import re
from p4vasp.Structure import *

if len(sys.argv) < 7:
    print "Usage: "+sys.argv[0]+" <poscar file> <n> <m> <x> <y> <z>"
    print "           <poscar file> is the input POSCAR"
    print "           <n> <m> species the range of atoms to move (by index)"
    print "           <x> <y> <z> is the translation vector to add to those atoms (direct)."
    print "           The new POSCAR is output to stdout."
    sys.exit(1)

space = re.compile(r'\s+')

file = sys.argv[1]
p=Structure(file)
p.setDirect()

n = int(sys.argv[2])
m = int(sys.argv[3])
x = float(sys.argv[4])
y = float(sys.argv[5])
z = float(sys.argv[6])

# do the move
p.translate(Vector(x,y,z),range(n,m))

# write it out.
p.write(sys.stdout)


