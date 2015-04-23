#! /usr/bin/python

import sys
import os
import re

if len(sys.argv) < 2:
    print "Usage: "+sys.argv[0]+" <nimages> <nions>"
    sys.exit(1)

space = re.compile(r'\s+')

nimages = int(sys.argv[1])
nions = int(sys.argv[2])

xdatn = nimages*nions

posfile = open('POSCAR',"r",0)
n = 0
line = []
line2 = []
while posfile:
    n = n + 1
    if n == 1: # the comment line (1)
        line.append( posfile.readline().strip() )
        for i in range(1,nimages):
            line.append( line[0] )
        print ' '.join(line)
        line = []
    if n > 1 and n < 6: # the cell size lines (2-5)
        print posfile.readline().strip()
    if n == 6: # nspecies line
        line.append( posfile.readline().strip() )
        for i in range(1,nimages):
            line.append( line[0] )
        print ' '.join(line)
        line = []
    if n > 6 and n < 9: # 7:selective dyn.; 8:direct
        print posfile.readline().strip()
    if n >= 9 and n <= (9+nions+1):
        line2.append( posfile.readline().strip() )
    #print line2
    if n == (9+nions + 1):
        for i in range(1,nimages):
            for j in range(0,nions):
                print line2[j]
    if n == (9+nions + 2): break

