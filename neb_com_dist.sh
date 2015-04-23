#! /bin/bash

neb_com.py $1 > /tmp/neb_com.dat
neb_com.py $2 >> /tmp/neb_com.dat

cat /tmp/neb_com.dat | cartlength.py

