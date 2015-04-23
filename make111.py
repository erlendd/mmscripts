#! /usr/bin/python

import sys
import os
import re
from math import sqrt, cos, tan, sin, radians

if len(sys.argv) < 1:
    print "Usage: "+sys.argv[0]+" <a> <z>"
    sys.exit(1)

def makeBasis(latticeParam, z, ny):
    skewedA = latticeParam/sqrt(2)
    y = skewedA * ny #TODO: make 3 var
    x1 = y*cos( radians(30) )
    #x2 = y*tan( radians(30) )
    x2 = y*cos( radians(120) )
    print("    %1.16f    %1.16f    %1.16f" % (x1,x2,0))
    print("    %1.16f    %1.16f    %1.16f" % (0,y,0))
    print("    %1.16f    %1.16f    %1.16f" % (0,0,z))
    return x1,x2,y,z

def placeAtoms(latticeParam, nx, ny, nz, lx1, lx2, ly, lz):
    skewedA = latticeParam/sqrt(2)
    lx = sqrt( lx1**2 + lx2**2 )
    sys.stderr.write('lx = %1.4f\nly = %1.4f\nlz = %1.4f\n' % (lx,ly,lz))
    for i in range(0,nz):
        z = i*(latticeParam/sqrt(3.0))/lz
        for j in range(0,ny):
            fac = (i % 3.0)/3.0
            y = j*skewedA # the next unit cell
            y = y + i*fac*skewedA
            #y = y + i*(1.0/3)*skewedA*cos( radians(30) )
            y = y*cos( radians(30) ) / ly
            for k in range(0,nx):
                fac = (2*i % 3.0)/3.0
                x = k*skewedA # the next unit cell (correct)
                #x = x + i*(2.0/3)*skewedA
                #x = x - i*(1.0/3)*skewedA*cos( radians(60) )
                #x = x + fac*skewedA - fac*skewedA*cos( radians(60) )
                x = x + fac*skewedA - y/tan( radians(60) )
                x = x / lx
                print(" %1.16f  %1.16f  %1.16f   T   T   T" % (x,y,z))

a0 = float(sys.argv[1])
z_vacuum = float(sys.argv[2])
comment = "Vasp POSCAR file: generated with Erlend's make111.py script"
nx=3
ny=3
nz=3

print comment
print("  %1.16f" % 1)
lx1,lx2,ly,lz = makeBasis(a0, z_vacuum, ny)
print " "+str(nx*ny*nz)
print "Selective dynamics"
print "Direct"
placeAtoms(a0, nx, ny, nz, lx1, lx2, ly, lz)
                
