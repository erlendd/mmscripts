#! /usr/bin/python

import sys
import os
import re
from subprocess import call

if len(sys.argv) < 2:
    print "Usage: "+sys.argv[0]+" <nimages>"
    sys.exit(1)

nimages=int(sys.argv[1])

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

for i in imageAr:
    print "Image: "+i
    call(["/bin/sh","-c", "cd "+i+"; vasp_xdat2xdatv.py > XDATCAR_"])

