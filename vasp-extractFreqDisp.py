#! /usr/bin/python

######################################################
# Author: Erlend Davidson <Erlend.Davidson[]ucl.ac.uk>
# Date: 21/11/08
#
# Extracts the frequency displacements from the OUTCAR
# file, and places these in files 1_f, 2_f, 3_f, ...
# These output files are then in the correct format to
# be used with Javi's fmovie.pl script.
#
# Usage: vasp-extractFreqDisp.py <OUTCAR>
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

ofreqfilename = "frequencies"
ofreqfile = open(ofreqfilename,"w",0)
nfreqdata = 0
freqdata = []

#idipoleIntensityfilename = "dipoleIntensities"
#idipoleIntensityfile = open(idipoleIntensityfilename,"r",0)
#dipoleMoments = []
#while idipoleIntensityfile:
#    line = idipoleIntensityfile.readline()
#    if not line: break
#    dipoleMoments.append(line)


inRegion = False
regionCounter = 0
ndata = 0
data = []

space = re.compile(r'\s+')
needle = re.compile('^[0-9]+ f')

while infile:
    line = infile.readline()
    if not line: break
    line = line.strip()
    # match the frequency lines...
    if inRegion is True:
        regionCounter = regionCounter + 1 
        if len(line) < 5: # end of block
            inRegion = False
            ndata = regionCounter - 2
            regionCounter = 0
            outfile = open(thisfreq,"w",0)
            for x in range(0, len(data)):
                outfile.write(data[x]+"\n")
            data = []
            outfile.close()
        else:
            if regionCounter > 1: # first row is xyz labels
                data.append(line)
    # find the frequency lines...
    if needle.match(line):
        thisline = space.split(line) 
#        print thisline # '1', 'f', '=', '94.966819' ...
#        print '_'.join(thisline[:2])
#        thisfreq = line[:3].strip().replace(' ','_')
        thisfreq = '_'.join(thisline[:2]).replace('/','_')
        inRegion = True
        freqline = line[10:].strip()
        freqs = space.split(freqline);
        # we just Happen To Know (TM) that the 5th col is in cm-1
        modeNum = int( line[:2].strip() )
        if len(freqdata) < modeNum:
            freqdata.append(freqs[4])
        else:
            freqdata[modeNum-1] = freqs[4]
        
        # but we'll check that, Just In Case (TM) ;-)
        if not freqs[5]=="cm-1":
            print "ERROR: Frequency missing!"
            print "  --> "+sys.argv[0]+" cannot read off the correct freqs."

for x in range(0, len(freqdata)):
    #ofreqfile.write(freqdata[x]+" "+dipoleMoments[x])
    ofreqfile.write(freqdata[x]+" "+str(5)+"\n")
    

ofreqfile.close()

print "Finished"

