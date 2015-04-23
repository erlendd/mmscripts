#! /usr/bin/python

import sys
import os
import re

if len(sys.argv) < 5:
    print "Usage: "+sys.argv[0]+" <DATAFILE> <MIN> <MAX> <NBINS> [NEQUIL] [NSTOP]"
    sys.exit(1)

file = sys.argv[1]
min = float(sys.argv[2])
max = float(sys.argv[3])
nbins = int(sys.argv[4])

nequil = 0
nstop = 0
if len(sys.argv) >= 6:
  nequil = int(sys.argv[5])
if len(sys.argv) >= 7:
  nstop = int(sys.argv[6])

infile = open(file,"r",0)
binwidth = (max-min)/nbins

hist = {}
n=0

while infile:
  n = n + 1
  if nstop > 0 and n%(nstop/10) == 0:
    sys.stderr.write('%')
  if nstop > 0 and n >= nstop:
    break
  line = infile.readline()
  if n < nequil:
    continue
  if not line: break
  line = float(line.strip())
  bin = int((line - min)/binwidth)
  if bin not in hist:
    hist[bin] = 1
  else:
    hist[bin] = hist[bin] + 1

# normalise
Z = 0 # normalisation constant
for i in hist:
  Z = Z + binwidth*hist[i]
  
#print hist,len(hist)
for i in hist:
  print (i*binwidth + min),hist[i]/Z

