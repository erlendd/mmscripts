#! /usr/bin/python

import os
import time
import sys
import re

if len(sys.argv) < 3:
    print "Usage: "+sys.argv[0]+" <poscar file> <n-skip>"
    print "           outputs a new POSCAR to stdout with the scale set to 1"
    print "           n-skip should be 8 (9) for vasp 4.6 (5.2)"
    sys.exit(1)

file = sys.argv[1]
infile = open(file,"r",0)
nskip = int(sys.argv[2])
space = re.compile(r'\s+')

n = 0
while infile:
    linebare = infile.readline().strip()
    if not linebare: break
    n = n + 1
    if n == 1:
      print linebare # comment
    if n == 2:
      scale = float(linebare)
      print "1.0" # the new scale
    if n > 2 and n < 6:
      thisline = space.split(linebare)
      thisX = scale * float(thisline[0])
      thisY = scale * float(thisline[1])
      thisZ = scale * float(thisline[2])
      print thisX,'  ',thisY,'  ',thisZ
    if n >= 6 and n <= nskip:
      print linebare
    if n > nskip:
      thisline = space.split(linebare)
      newthisline = [col for col in range(len(thisline))]
      for col in range(len(thisline)): # number of columns
        eCol = thisline[col].strip()
        if col < 3:
          eCol = float(thisline[col].strip())
          newthisline[col] = eCol * scale
          newthisline[col] = "%1.16f" % (newthisline[col])
        else:
          newthisline[col] = eCol
        #print newthisline[col]
      print '  '.join(newthisline)
