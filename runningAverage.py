#!/usr/bin/env python
import os
import time
import sys
import re
import math

# 2/2/2011: This doesn't work - it's just wrong.
# I've rewritten a v.simple average=totalvalue/linecounter
# just in the main loop.
def RunningAverage(NewItem, ItemsInAverage, OldAverage=None):
    if OldAverage:
        return OldAverage - (OldAverage - NewItem)/ItemsInAverage
    else:
        return NewItem



if len(sys.argv) < 4:
    print "Usage: "+sys.argv[0]+" <Energy.dat file> <col> <equilib> [max]"
    sys.exit(1)

file = sys.argv[1]
infile = open(file,"r",0)
col = int(sys.argv[2])
equilib = 1
if len(sys.argv) >= 4:
    equilib = int(sys.argv[3])
maxi=100000000000
if len(sys.argv) >= 5:
    maxi = float(sys.argv[4])

if equilib < 1:
    equilib = 1

print "# equil:",equilib

linecounter = 0
totalvalue = 0.0
averagecounter = 0

while infile:
    line = infile.readline()
    if not line: break
    linecounter = linecounter + 1
    # only do the runnning averages after equilibriation...
    if linecounter < equilib:
        continue
    # split on any length of whitespace...
    space = re.compile(r'\s+')
    thisline = space.split(line.strip())
#    if linecounter == equilib:
#        totalvalue = float(thisline[col])
#	print thisline[col].strip(),thisline[col].strip()
    if linecounter >= equilib and abs(float(thisline[col])) < maxi:
        averagecounter = averagecounter + 1
        totalvalue = totalvalue + float(thisline[col])
        average = totalvalue / averagecounter
        print thisline[col].strip(),average,totalvalue,averagecounter

infile.close()
infile = open(file,"r",0)


linecounter = 0
stddevcounter = 0
stddevsum=0.0
# compute the std.dev. 
while infile:
    line = infile.readline()
    if not line: break
    linecounter = linecounter + 1
    # only do the runnning averages after equilibriation...
    if linecounter < equilib:
        continue
    # split on any length of whitespace...
    space = re.compile(r'\s+')
    thisline = space.split(line.strip())
    # we are now equilibrated, so compute std.dev.
    if linecounter >= equilib and abs(float(thisline[col])) < maxi:
        stddevcounter = stddevcounter + 1
        thisvalue = float(thisline[col])
	stddevsum = stddevsum + (thisvalue-average)**2

print "# ",stddevcounter,average
print "# ",math.sqrt(stddevsum / stddevcounter)





