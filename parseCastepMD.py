#!/usr/bin/env python
import os
import time
import sys

if len(sys.argv) < 2:
    print "Usage: "+sys.argv[0]+" <.castep file>"
    sys.exit(1)

file = sys.argv[1]
infile = open(file,"r",0)

pe = [] 
h = []

print "Reading in data..."
while infile:
    line = infile.readline()
    if not line: break
    if line.find("Potential Energy:") > 0:
        thisline = line.split(" ")
        pe.append(thisline[19])
    if line.find("Hamilt    Energy:") > 0:
        thisline = line.split(" ")
        h.append(thisline[22])

print "Read in ",len(h)," elements."
ofile = file+".energies" 
outfile = open(ofile,"a")
outfile.write('#iter pe ham \n')
print "Writing output file: ",ofile
for i in range(0,len(h)):
    oline=str(i)+" "+str(pe[i])+" "+str(h[i])+"\n"
    outfile.write(oline)

outfile.close()
print "Completed"

