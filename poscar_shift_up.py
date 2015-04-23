#!/usr/bin/env python
import os
import time
import sys
import re

if len(sys.argv) < 5:
    print "Usage: "+sys.argv[0]+" <poscar file> <n-skip> <col> <num to add> [n-stop] [normalize]"
    print "           n-skip should be 8 (9) for vasp 4.6 (5.2)"
    sys.exit(1)

space = re.compile(r'\s+')

nstop = 100000000
normalize = False

file = sys.argv[1]
infile = open(file,"r",0)
nskip = int(sys.argv[2])
colToEdit = int(sys.argv[3])
add = float(sys.argv[4])

if len(sys.argv) >= 6:
    nstop = int(sys.argv[5])
if len(sys.argv) >= 7:
    normalize = True

n = 0
while infile:
    linebare = infile.readline()
    if not linebare: break
    n = n + 1
    line = linebare.strip()
    if n > nskip and n < nstop: 
        thisline = space.split(line)
        #print thisline
        newthisline = [col for col in range(len(thisline))]
        for col in range(len(thisline)): # number of columns
            eCol = thisline[col].strip()
            if col == colToEdit:
                eCol = float(thisline[col].strip())
                newthisline[col] = eCol + add
                if normalize and newthisline[col] > 1.0:
                    newthisline[col] = newthisline[col] - 1.0
                newthisline[col] = "%1.16f" % (newthisline[col])
                #newthisline[col] = str(newthisline[col])
            else:
                newthisline[col] = eCol
        print '  '.join(newthisline)
    else:
        print linebare,

