#! /usr/bin/python

import sys
import os
import re
from array import array

if len(sys.argv) < 2:
    print "Usage: "+sys.argv[0]+" <XYZ file>"
    sys.exit(1)

file = sys.argv[1]
infile = open(file,"r",0)

line_num = 0
ions_to_smear = array('l', [1,2,3])
n_ions_to_smear = len(ions_to_smear)

smearList = []
staticList = []

while infile:
    line = infile.readline()
    if not line: break
    line_num = line_num + 1
    line = line.strip()
    if line_num == 1:
        n_ions = int(line)
    if line_num > 2:
        # NB: the -2 is to include the comment and n_ions!
        if (ions_to_smear.count(line_num-2)) > 0:
            # we append this to the list
            smearList.append(line)
        else:
            if len(staticList) < (n_ions - n_ions_to_smear):
                staticList.append(line)
    if line_num >= n_ions+2:
        line_num = 0

print len(smearList)+len(staticList)
print file, "smeared"
for i in range(0, len(smearList)):
    print smearList[i]
for i in range(0, len(staticList)):
    print staticList[i]

