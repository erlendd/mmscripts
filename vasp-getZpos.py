#! /usr/bin/python

import sys
import os
import re

if len(sys.argv) < 2:
    print "Usage: "+sys.argv[0]+" <OUTCAR> [n-forces-to-skip]"
    sys.exit(1)

file = sys.argv[1]

infile = open(file,"r",0)

space = re.compile(r'\s+')

if len(sys.argv) > 2:
     nskip = int(sys.argv[2])
else:
    nskip = 1

n = 0
nforce = 0
while infile:
    n = n + 1 # count the line number
    thisline = infile.readline()
    if not thisline: break;
    line = thisline.strip()
    if line.find('POSITION      ') > -1:
      nforce = nforce + 1
      if nforce > nskip:
        line = infile.readline().strip() # this is full of -----'s
        line = infile.readline().strip() # this line has 3 positions and 3 forces.
        z=space.split(line)[2]
        print z

