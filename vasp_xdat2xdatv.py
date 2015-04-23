#! /usr/bin/python

import sys
import os
import re

# This is very simple: convert the 5.2.11 XDATCAR format to 5.2.

if len(sys.argv) < 0:
    print "Usage: "+sys.argv[0]
    sys.exit(1)

space = re.compile(r'\s+')

if len(sys.argv) < 2:
    xfile = "XDATCAR"
else:
    xfile = sys.argv[1]

tplxdatfile = open(xfile,"r",0)
n = 0
skipped = 0
while tplxdatfile:
    n = n + 1
    line = tplxdatfile.readline()
    if not line: break; # eof
    if n == 1: # the comment
        print line,
    if n > 5: # we skip the next 4 lines
        print line,
    if n == 7: # "direct"
        print "direct"
    
    
  
