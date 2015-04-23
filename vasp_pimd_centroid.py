#! /usr/bin/python

import sys
import os
import re
import math

if len(sys.argv) < 2:
    print "Usage: "+sys.argv[0]+" <nimages> <nions>"
    sys.exit(1)

space = re.compile(r'\s+')

nimages = int(sys.argv[1])
nions = int(sys.argv[2])

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
tplxdatfile = open('01/XDATCAR',"r",0)
n = 0
while tplxdatfile:
    n = n + 1
    if n > 5: break
    print tplxdatfile.readline().strip()
tplxdatfile.close()

###
# Now the trajectory


fileAr = []
for i in imageAr:
    fileobj = open(i+'/XDATCAR','r',0)
    fileAr.append( fileobj )

n = 0
eof=False
thision = []
cent = [] # definition: cent[ion][dim]
while True:
    if eof: break;
    n = n + 1
    if n < 7:
        for i in range(0, nimages):
            fileAr[i].readline()
    if n == 7: print
    if n > 7:
        cent = [] # reset
        for i in range(0, nions+1):
            cent.append([])
            for j in range(0, nimages):
                thisline = fileAr[j].readline()#.strip()
                if not thisline: # eof
                    eof=True
                    break;
                if len(thisline) > 5: # not blank
                    if j == 0:
                        for k in range(0,3):
                            cent[i].append( float(space.split(thisline.strip())[k]) )
                    else:
                        for k in range(0,3):
                            thispos = float(space.split(thisline.strip())[k])
#                            if thispos - cent[i][k] > 0.5:
#                                cent[i][k] = cent[i][k] + (thispos - 1.0)
#                            elif thispos - cent[i][k] < -0.5:
#                                cent[i][k] = cent[i][k] + (1.0 - thispos)
#                            else:
                            cent[i][k] = cent[i][k] + \
                                             float(space.split(thisline.strip())[k])
            if eof: break;
            # ok gone through all the images now, can average and print
            if len(thisline) > 5:
                for k in range(0,3):
                   cent[i][k] = cent[i][k]/nimages
                print '  %(x).8f  %(y).8f  %(z).8f' % {'x':cent[i][0], 'y':cent[i][1], 'z':cent[i][2]}
        print
            
   
