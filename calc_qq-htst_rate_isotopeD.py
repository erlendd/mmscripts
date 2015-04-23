#!/usr/bin/env python
import os
import time
import sys
import re
import math

if len(sys.argv) < 5:
    print "Usage: "+sys.argv[0]+" <file freqs-at-IS> <file freqs-at-TS> <Temp> <Barrier>"
    print
    print "    Computes the simplest quantum rate correction"
    print "    by replacing the classical vibrational partition functions"
    print "    with their quantum analogs."
    print "    For details see pg. 32 Andri Arnaldsson's thesis."
    sys.exit(1)

space = re.compile(r'\s+')

fileIS = sys.argv[1]
fileTS = sys.argv[2]
T = float(sys.argv[3])
dE = float(sys.argv[4])

infileIS = open(fileIS,"r",0)
infileTS = open(fileTS,"r",0)

# planck is in eV
planck = 4.135667e-15
# hbar converts cm^{1} to eV units.
hbar = 1.0/8065.5
# boltz is in eV/K
boltz = 8.617e-5
hbar_over_boltz = hbar / ( 2.0*boltz*T )

print "Computing the reactant partition function..."

qIS = 1.0
while True:
    line = infileIS.readline().strip()
    if not line:
        break;
    thisFreq = float(line)/math.sqrt(2)
    qIS = qIS * 2*math.sinh( hbar_over_boltz*thisFreq )

print qIS

print "Computing the TS partition function..."

qTS = 1.0
while True:
    line = infileTS.readline().strip()
    if not line:
        break;
    thisFreq = float(line)/math.sqrt(2)
    qTS = qTS * 2*math.sinh( hbar_over_boltz*thisFreq )

print qTS

print (boltz*T)/(2*math.pi*planck) * (qIS/qTS) * math.exp(-dE/(boltz*T))

