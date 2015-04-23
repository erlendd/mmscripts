#! /usr/bin/python

import sys
import os
import re
import math

if len(sys.argv) < 3:
    print "Usage: "+sys.argv[0]+" <nimages> <col> <fn>"
    print 
    print "    averages the column <col> of files with file name <fn> within directories"
    print "    with names 01, 02, ... <nimages>."
    print "    Now also outputs std deviation of the average."
    print "    This is intended for use with VASP PIMD calculations."
    sys.exit(1)

space = re.compile(r'\s+')

nimages = int(sys.argv[1])
col = int(sys.argv[2])
fn = str(sys.argv[3])

#xdatn = nimages*nions # do i need this?

###
# fill the imageAr array with the names of the image directories.
imageAr = []
for i in range(1,nimages+1): # excludes (00) and (nimages+1)
    # correct the form of the directory of 00,01,02...
    if i < 10:
        thisdir = "0"+str(i)
    else:
        thisdir = str(i)
    # by now, thisdir is in the 00 01 02... form.
    # put it into the imageAr array...
    imageAr.append(thisdir)

#

### 
# Open the 'fn' files in each image directory
fileAr = []
for i in imageAr:
    fileobj = open(i+'/'+fn,'r',0)
    fileAr.append( fileobj )

# will hold the n^{th} line of each image (this will be avg'd)
number=list(0 for x in range(0,nimages)) # 'nimages' 0's
#print number

n = 0
eof=False
sdevAr = []
while True:
    n = n + 1 # not actually used, but nice in case
    # n^{th} iter: we read each image
    for i in range(0,nimages): # for each image
        thisLine = fileAr[i].readline()
        if not thisLine:
            eof=True; # stop at the end of this iteration
        else: # we do something useful
            thisNum = space.split(thisLine.strip())[col]
            number[i] = float(thisNum)

    avOverImages = sum(number)/float(nimages)

    # now compute the std.dev.
    variancesum = 0.0
    for i in range(0,nimages): # for each image
        variancesum = variancesum + (number[i]-avOverImages)**2

    stddev = math.sqrt(variancesum/float(nimages))
    sdevAr.append(stddev)

    print avOverImages, stddev # the answer!

    if eof: break;
    
print "Av(stddev): ",sum(sdevAr)/len(sdevAr)
