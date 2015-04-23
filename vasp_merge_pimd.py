#! /usr/bin/python

import sys
import os
import re

if len(sys.argv) < 3:
    print "Usage: "+sys.argv[0]+" <nimages> <nions> <XDATCAR-filename>"
    sys.exit(1)

space = re.compile(r'\s+')

nimages = int(sys.argv[1])
nions = int(sys.argv[2])
xdatfilename = str(sys.argv[3])

xdatn = nimages*nions

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
# Print the header of the XDATCAR file
#tplxdatfile = open('01/XDATCAR',"r",0)
tplxdatfile = open('01/'+xdatfilename,"r",0)
n = 0
while tplxdatfile:
    n = n + 1
    if n > 5: break
    if n == 1:
        line = space.split(tplxdatfile.readline().strip())
        line[0] = str(xdatn)
        print '   '.join(line)
        
    print tplxdatfile.readline().strip()
tplxdatfile.close()

###
# Now the trajectory

fileAr = []
for i in imageAr:
#    fileobj = open(i+'/XDATCAR','r',0)
    fileobj = open(i+'/'+xdatfilename,'r',0)
    fileAr.append( fileobj )

n = 0
eof=False
while True:
    n = n + 1
    if n < 6:
        for i in range(0, nimages):
            fileAr[i].readline()
    if n > 6:
        for i in range(0, nimages):
            for j in range(0, nions+1):
                thisline = fileAr[i].readline()
                if not thisline: # end of file
                    eof=True
                    break; 
                if len(thisline) > 5:
                    print thisline,
        if eof: break;
        print # a newline char after blanks
            

