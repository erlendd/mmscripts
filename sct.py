#!/usr/bin/env python
import os
import time
import sys
import re
import math
from scipy import integrate

if len(sys.argv) < 2:
    T = 100
else:
    T = float(sys.argv[1])


# Coefficients from 0 to 7
c = [0.0311691, -1.79148, 21.8965, -49.0635, 18.12, 52.3101, -60.954, 19.3968]
RClength = 1.15

def V(x):
    polyn = 0.0
    for y in range(0,8):
        polyn = polyn + c[y]*x**y
    return polyn


def WKBintegrand(x,E):
    result = V(x) - E
    if result < 1e-14:
        result = 0.0
    return math.sqrt(result)


# Just the integration part of the WKB
def WKBint(E):
    return integrate.quad(lambda x: WKBintegrand(x,E), 0, RClength)[0]

# Energy barrier in eV
Eb = 0.46 
# Temperature in K
#T = 10
# Boltzmann constant in eV/K
kB = 8.617e-5
# mass of the particle in kg
m = 1.67262158e-27
# Planck's constant in eVs
hbar = 6.58211928e-16
# Joules/eV
JoeV = 1/6.2415e18


#denominator = integrate.quad(lambda x: math.exp(-x/(kB*T)), Eb, Eb*5)

# Can analytically integrate the denominator...
denominator = kB*T/Eb * math.exp( -Eb/(kB*T) )
print denominator

print "WKB"+str(WKBint(1.0))

numerator = integrate.quad(lambda thisE: 1/(1+math.exp(math.sqrt(JoeV)*2*math.sqrt(2*m)/hbar*WKBint(thisE)))*math.exp(-thisE/(kB*T)), 0, 10000)
print numerator

print numerator[0]/denominator

classicalT = math.exp( -Eb/(kB*T) )
print classicalT

print (numerator[0]/denominator)*classicalT

#correction = integrate.dblquad(lambda thisE,x: 1/(1+math.exp(math.sqrt(JoeV)*2*math.sqrt(2*m)/hbar*WKBintegrand(x,thisE)))*math.exp(-thisE/(kB*T)), 0,100, lambda x:0,lambda x:RClength)
#print correction

