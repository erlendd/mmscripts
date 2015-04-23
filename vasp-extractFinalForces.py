#! /usr/bin/python

######################################################
# Author: Erlend Davidson <Erlend.Davidson[]ucl.ac.uk>
# Date: 27/03/09
#
# Extracts the ionic forces from the OUTCAR
# file, and places these in the file forces, ...
#
# Usage: vasp-extractFinalForces.py <OUTCAR>
#
###

import sys
import os
import re

if len(sys.argv) < 2:
    print "Usage: "+sys.argv[0]+" <OUTCAR>"
    sys.exit(1)

file = sys.argv[1]
infile = open(file,"r",0)

oforcefilename = "forces"
#oforcefile = open(oforcefilename,"w",0)
nforcedata = 0
freqdata = []

inRegion = False
regionCounter = 0
ndata = 0
data = []
space = re.compile(r'\s+');
needle = re.compile('POSITION     ')
stopneedle = re.compile('--------------------------------------------------')

while infile:
    line = infile.readline()
    if not line: break
    line = line.strip()
    # match the frequency lines...
    if inRegion is True:
        regionCounter = regionCounter + 1 
        #if len(line) < 5: # end of block (blank / nearly blank line)
        if regionCounter > 1 and stopneedle.match(line): 
            inRegion = False
            ndata = regionCounter - 2
            regionCounter = 0
            oforcefile = open(oforcefilename,"w",0)
            for x in range(0, len(data)):
                oforcefile.write(data[x]+"\n")
            data = []
            oforcefile.close()
        else:
            if regionCounter > 1: # first row is dashes "----"
                data.append(line)
    #print "data: ", data
    # find the frequency lines...
    if needle.match(line):
        inRegion = True
