#! /usr/bin/python

import sys
import os
import re
from math import sqrt, cos, tan, sin, radians

if len(sys.argv) < 1:
    print "Usage: "+sys.argv[0]+" <a> <z>"
    sys.exit(1)

# latticeParam is the graphene lattice parameter
# z is the z dimension of the cell
# n is the cell size, i.e. a "n x n" cell
def makeBasis(latticeParam, z, n):
    x1 = 1.0 * n
    y1 = 0.5 * n
    y2 = 0.866025403 * n
    print("graphene")
    print(" %1.16f" % (latticeParam))
    print("    %1.16f    %1.16f    %1.16f" % (x1,0,0))
    print("    %1.16f    %1.16f    %1.16f" % (y1,y2,0))
    print("    %1.16f    %1.16f    %1.16f" % (0,0,z))
    return x1,y1,y2,z



a0 = 2.46550
z = 6.0839586289999996
n = 3
natoms = n*n*2 # num_cells*2 (<= two atoms per cell)

lx1,ly1,ly2,lz = makeBasis(a0, z, n)
print("   C") # can leave this out
print("   "+str(natoms))
print "Selective dynamics"
print("Direct")

cell_shift = 1.0/n

for nx in range(0,n):
    for ny in range(0,n):
        if ( nx*cell_shift > 0 or ny*cell_shift > 0 ): 
            print("  %1.16f %1.16f %1.16f   T  T  T" % (0.0 + nx*cell_shift, 0.0 + ny*cell_shift, 0.0))
        else:
            print("  %1.16f %1.16f %1.16f   F  F  F" % (0.0 + nx*cell_shift, 0.0 + ny*cell_shift, 0.0))
        print("  %1.16f %1.16f %1.16f   T  T  T" % (0.3333333333333333/n + nx*cell_shift, 0.3333333333333333/n + ny*cell_shift, 0.0))

