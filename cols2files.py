#! /usr/bin/python

import sys
import os
import re

if len(sys.argv) < 2:
    print "Usage: "+sys.argv[0]+" <fn>"
    sys.exit(1)

space = re.compile(r'\s+')

n = 0 # line counter
eof = False
ncols = 0 # this will be the number of columns
lines = [] # 2-d array of the lines (index1:line; index2:col)

fn = sys.argv[1]

infile = open(fn,'r',0)

while True:
    n = n + 1
    thisline = infile.readline()
    if not thisline:
        eof=True
    else: # do something useful
        sthis = space.split( thisline.strip() )
        #print sthis
        lines.append( sthis )
    if eof: break;

print "input file read"

#ncols = len(sthis[0])
ncols=2
outfiles = []
for nc in range(0,ncols): # we open ncols number of files
    fileObj = open(fn+'.col'+str(nc),'w')
    outfiles.append(fileObj)

print "nlines=",len(lines)
print "ncols=",ncols
print lines[0][0], lines[0][1], len(sthis[0]), lines[0]

print "successfully opened output files for writing"

#
# Now we write out the columns to separate files
#
for l in range(0,len(lines)): # for each line
    print l
    for nc in range(0,ncols): # for each col
        print nc
        outfiles[nc].write( lines[l][nc]+"\n" )

print "written data to files. exiting now"

# Close the files
for nc in range(0,ncols):
    outfiles[nc].close()

