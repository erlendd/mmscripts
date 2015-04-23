#! /usr/bin/python

import sys
import os
import re
from math import sqrt, cos, tan, sin, radians
#from Numeric import *
from numpy import *

if len(sys.argv) < 6:
    print
    print "Usage: "+sys.argv[0]+" <a> <z> <n> <m> <l>"
    print "       a = lattice constant"
    print "       z = total height of cell"
    print "       n x m = cell size"
    print "       l = number of layers"
    print
    sys.exit(1)

                
def printThisBasis(basis):
    n_in_basis = size(basis)/3 # since 3-dims
    for i in range(0, n_in_basis):
        x = basis[i,0]
        y = basis[i,1]
        z = basis[i,2]
        relax='T'
        # now fix the bottom layer...
        if z < 0.0000001:
            if z > -0.0000001:
                relax='F'
        print(" %1.16f    %1.16f    %1.16f   %s   %s   %s"
                                         % (x,y,z,relax,relax,relax))

def makeFirstLayer(nx, ny):
    #startAtom = array([0.00, 0.00, 0.00], typecode=Float32)
    #layer = array( [[0,0,0]], typecode=Float32 )
    #shiftX = array( [1.0/nx, 0.0, 0.0], typecode=Float32 )
    #shiftY = array( [0.0, 1.0/ny, 0.0], typecode=Float32 )
    #arX = array( [[0,0,0]]*nx*ny, typecode=Float32 )
    startAtom = array([0.00, 0.00, 0.00])
    layer = array( [[0.0,0.0,0.0]] )
    shiftX = array( [1.0/nx, 0.0, 0.0] )
    shiftY = array( [0.0, 1.0/ny, 0.0] )
    arX = array( [[0.0,0.0,0.0]]*nx*ny )

    count = 0
    for x in range(0,nx):
        thisx = startAtom[:] + x*shiftX[:]
        for y in range(0,ny):
            thisxy = thisx[:] + y*shiftY[:]
            for i in range(0,size(arX[x])):
                arX[count][i] = thisxy[i]
            count = count + 1
    return arX

def makeBasis(latticeParam, z, nx, ny):
    skewedA = latticeParam/sqrt(2)
    x = nx*skewedA
    y1 = 0.5*ny*skewedA
    y2 = ny*sin(radians(60))*skewedA
    print("    %1.16f    %1.16f    %1.16f" % (x,0,0))
    print("    %1.16f    %1.16f    %1.16f" % (y1,y2,0))
    print("    %1.16f    %1.16f    %1.16f" % (0,0,z))
    return x,y1,y2,z

def placeAtoms(latticeParam, nx, ny, nz, lx, ly1, ly2, lz):
    skewedA = latticeParam/sqrt(2)
    ##              [0.00, 0.50, 0.00],
    # basis: one unit cell;
    ##basis = array([[0.00, 0.00, 0.00],
    ##              [0.50, 0.00, 0.00],
    ##              [0.00, 0.50, 0.00],
    ##              [0.50, 0.50, 0.00]], typecode=Float32)
    basis = makeFirstLayer(nx, ny)
    # each time you apply this vector a new layer is created;
    layerShiftVector = array([(1/3.0)/nx, 
                              (1/3.0)/ny, 
                              latticeParam/sqrt(3)/lz]
                             )
    sys.stderr.write('%dx%dx%d surface\n' % (nx,ny,nz))
    for i in range(0,nz):
        printThisBasis(basis)        
        basis = basis + layerShiftVector
        

a0 = float(sys.argv[1])
z_vacuum = float(sys.argv[2])
n = int(sys.argv[3])
m = int(sys.argv[4])
l = int(sys.argv[5])

#comment = "Vasp POSCAR file: generated with Erlend's make111.py script"
comment = "a0:"+str(a0)+" z:"+str(z_vacuum)+" "+str(n)+"x"+str(m)+" l:"+str(l)

nx=n
ny=m
nz=l

print comment
print("  %1.16f" % 1)
lx1,lx2,ly,lz = makeBasis(a0, z_vacuum, nx, ny)
print " "+str(nx*ny*nz)
print "Selective dynamics"
print "Direct"
#sys.stderr.write('%d\n' % (lz))
placeAtoms(a0, nx, ny, nz, lx1, lx2, ly, lz)

