#! /usr/bin/python

import sys
import os
import re

if len(sys.argv) < 2:
    print "Usage: "+sys.argv[0]+" <OSZICAR>"
    sys.exit(1)

file = sys.argv[1]
infile = open(file,"r",0)

while infile:
    line = infile.readline()
    if not line: break
    line = line.strip()
    needle = re.compile('^[0-9]+ T')
    if needle.match(line):
        thisstep = line[:4].strip().replace(' ','_')
        enline = line[4:].strip()
        space = re.compile(r'\s+');
        energies = space.split(enline);
        #['T=', '63.', 'E=', '', 'F=', '', 'E0=', '',
        # 'EK=', '1', 'SP=', '', 'SK=', '']
        #print energies
        print "\n"+thisstep,
        for x in range(0, len(sys.argv)-2):
            print " "+energies[int(sys.argv[x+2])],
