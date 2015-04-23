#! /usr/bin/env python

import os
import time
import sys
import re

file = sys.argv[1]
infile = open(file,"r",0)

space = re.compile(r'\s+')

u = []
linecounter = 0
while infile:
    line = infile.readline()
    if not line: break
    linecounter = linecounter + 1
    if linecounter < 49: continue
    thisline = space.split(line.strip())
#    print thisline
    for i in range(0,5):
      u.append(thisline[i])

#  http://cms.mpi.univie.ac.at/vasp/vasp/CHGCAR_file.html
#  WRITE(IU,FORM) (((C(NX,NY,NZ),NX=1,NGXC),NY=1,NGYZ),NZ=1,NGZC)

#nx=72;ny=108;nz=180

chgden = [ [ [0 for col in range(180)] for row in range(108) ] for depth in range(72) ]

for z in range(0,180):
  for y in range(0,108):
    for x in range(0,72):
      # if z were the quickest moving index...
#      chgden[x][y][z] = u[ x*180*108 + y*180 + z ]    
      chgden[x][y][z] = u[ z*72*108 + y*72 + x ]    
     


#print u[10]

avgchgden = []
plane = 0.0
for z in range(0,180):
  for y in range(0,108):
    for x in range(0,72):
      plane = plane + float(chgden[x][y][z])
  avgchgden.append( plane/(108+72) )
  plane = 0.0

for z in range(0,180):
  print avgchgden[z]
# print chgden[0][0][z]

