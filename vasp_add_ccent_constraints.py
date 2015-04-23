#! /usr/bin/python

import sys

if len(sys.argv) < 2:
    print "Usage: "+sys.argv[0]+" <nimages> [from-image] [to-image]"
    sys.exit(1)

nimages = int(sys.argv[1])
nskip=9
fromIm = 1 # by default we don't apply constraints to image 00
toIm = nimages+1 # nor to the final one either (range is up-to-but-not-including)

if len(sys.argv) > 2: 
    print "Adding constraints from image number "+sys.argv[2]
    fromIm = int(sys.argv[2])

if len(sys.argv) > 3:
    print "Adding constraints up to image number "+sys.argv[3]
    toIm = int(sys.argv[3]) + 1 # NB: +1 since up to and not including

newthisline = ["first", "second"]

ccentAr = []
infile = open("ccent","r",0)
n = 0
while infile:
    linebare = infile.readline()
    if not linebare: break
    n = n + 1
    line = linebare.strip()
    ccentAr.append(line)

infile.close()


###
# fill the imageAr array with the names of the image directories.
imageAr = []
for i in range(fromIm,toIm): # does NOT include (00) and (nimages+1)
    # correct the form of the directory of 00,01,02...
    if i < 10:
        thisdir = "0"+str(i)
    else:
        thisdir = str(i)
        # by now, thisdir is in the 00 01 02... form.
        # put it into the imageAr array...
    imageAr.append(thisdir)



for im in imageAr:
  infile = open(im+"/POSCAR","r+w",0)
  n = 0
  outofpos=0 # 1:true, 0:false
  poscarline = []
  while infile:
    linebare = infile.readline()
    if not linebare: break # eof
    n = n + 1
    line = linebare.strip()
    if not line: outofpos=1 # line was empty
    if (n<=nskip or outofpos): poscarline.append(linebare)
    # nskip tells us we're at the POSITIONS part of POSCAR
    # outofpos will get triggered once we're at the end of that part.
    if n>nskip and not outofpos: # we're in the place to do stuff...
      newthisline[0] = linebare[:-1]
      newthisline[1] = ccentAr[n-nskip-1]+"\n"
      poscarline.append('   '.join(newthisline))
#    outfile = open(im+"/POSCAR_","w",0)
  infile.close()
  infile = open(im+"/POSCAR","r+w",0)
  infile.writelines(poscarline)
#    print poscarline

