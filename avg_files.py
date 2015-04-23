#! /usr/bin/python

import sys
import os
import re

if len(sys.argv) < 3:
    print "Usage: "+sys.argv[0]+" <nimages> <fn>"
    sys.exit(1)

space = re.compile(r'\s+')

nimages = int(sys.argv[1])
fn = str(sys.argv[2])


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
while True:
    n = n + 1 # not actually used, but nice in case
    # n^{th} iter: we read each image
    ncimages = 0
    for i in range(0,nimages): # for each image
        thisNum = fileAr[i].readline()
        if not thisNum: 
            eof=True; # stop at the end of this iteration
        else: # we do something useful
	    try:
                number[i] = float(thisNum)
		ncimages = ncimages + 1 # number of images which count
            except ValueError:
	        sys.stderr.write("Skipping due to convert to float error\n")
    if ncimages > 0:
        print sum(number)/float(ncimages) # the answer!
    if eof: break;
    
