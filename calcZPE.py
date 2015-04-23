#!/usr/bin/env python
import os
import time
import sys
import re

file = sys.argv[1]
infile = open(file,"r",0)

ZPE=0

while infile:
    line = infile.readline()
    if not line: break
    # split on any length of whitespace...
    space = re.compile(r'\s+')
    thisFreq = space.split(line)[0]
    if thisFreq != "i": # do NOT include imaginary frequencies
        ZPE = ZPE + float(thisFreq)

ZPE = ZPE*0.5
print ZPE," cm-1"
print (ZPE/8065.5)," eV"

