#! /usr/bin/python

import sys
import os
import re

if len(sys.argv) < 2:
    print "Usage: "+sys.argv[0]+" <nimages> <nions>"
    sys.exit(1)

space = re.compile(r'\s+')

nimages = int(sys.argv[1])
nions = int(sys.argv[2])

xdatn = nimages*nions # the number of things in each MD step

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
tplxdatfile = open('01/XDATCAR_',"r",0)
n = 0
while tplxdatfile:
    n = n + 1
    if n > 4: break
    if n == 1: # n==1: comment line
         print tplxdatfile.readline(), # no newline (already have one from the original)
    if n == 2: # n==2: species
        thisline = tplxdatfile.readline().strip() # the whole nspecies line
        # this is correct, since nions is nested INSIDE of nimages...
        for i in range(0,nimages):
            print " "+thisline,
        print # now we put in a newline
    if n == 3: # n==3: number of each species
        thisline = tplxdatfile.readline().strip() # the whole nspecies line
        line = space.split(thisline) # each nspecies
# this is correct, since nions is nested INSIDE of nimages...
        for i in range(0,nimages):
            print " "+thisline,
# this would be correct if the nimages was nested INSIDE of nions...
#        for i in line:
#            print str(nimages*int(i))+" ", # no newlines (nspecies1  nspecies2 ...)
        print # now we put in a newline
    if n == 4: # n==4: direct, or cartesian (normally direct)
        print tplxdatfile.readline(), # no newline (already have one from the original)
        print # newline

tplxdatfile.close()

###
# Now the trajectory

fileAr = []
for i in imageAr:
    fileobj = open(i+'/XDATCAR_','r',0)
    fileAr.append( fileobj )

n = 0
eof=False
while True:
    n = n + 1
    if n < 5:
        for i in range(0, nimages):
            fileAr[i].readline()
    if n > 5:
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
            

