#! /usr/bin/python

import sys
import os
import re

if len(sys.argv) < 2:
    print "Usage: "+sys.argv[0]+" <OUTCAR> <NIONS>"
    sys.exit(1)

file = sys.argv[1]
nions = sys.argv[2]

infile = open(file,"r",0)

space = re.compile(r'\s+')

n = 0
while infile:
    n = n + 1 # count the line number
    thisline = infile.readline()
    if not thisline: break;
    line = thisline.strip()
    if line.find('POSITION') > -1:
      line = infile.readline().strip() # this is full of -----'s
      line = infile.readline().strip() # this line has 3 positions and 3 forces.
      vectline = space.split(line)
      newline = vectline[0]
      print z

