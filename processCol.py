#!/usr/bin/env python
import os
import time
import sys
import re

if len(sys.argv) < 4:
    print "Usage: "+sys.argv[0]+" <dat file> <col> <number-to-mult>"
    sys.exit(1)

file = sys.argv[1]
infile = open(file,"r",0)
colToEdit = int(sys.argv[2])
fac = float(sys.argv[3])

while infile:
    line = infile.readline()
    if not line: break
    line = line.strip()
    if line[:1] == '#': continue
    space = re.compile(r'\s+')
    thisline = space.split(line)
    newthisline = []
    for col in range(len(thisline)):
        eCol = float(thisline[col].strip())
        if col == colToEdit:
            newthisline.append(str(eCol*fac))
        else:
            newthisline.append(thisline[col].strip())
        if col == len(thisline)-1:
            strthisline = " ".join(newthisline)
            print strthisline


