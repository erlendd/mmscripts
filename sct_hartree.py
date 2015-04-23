#!/usr/bin/env python
import os
import time
import sys
import re
import math
from math import exp
from scipy import integrate

if len(sys.argv) < 2:
    T = 100
else:
    T = float(sys.argv[1])

AngBohr=1.0/0.529
evHar=1.0/27.2

# Coefficients from 0 to 7
c = [0.0311691, -1.79148, 21.8965, -49.0635, 18.12, 52.3101, -60.954, 19.3968]
RClength = 1.15
# Energy barrier in eV
Eb = 0.46*evHar
# Temperature in K
if T <= 10: T=10
# Boltzmann constant in eV/K
kB = 8.617e-5*evHar
# mass of the particle in kg
m = 2*1836 
# Planck's constant in AU
hbar = 1.0


def V(x):
    polyn = 0.0
    for y in range(0,8):
        polyn = polyn + c[y]*x**y
    return polyn/27.2


def WKBintegrand(x,E):
    result = V(x) - E
    if result < 1e-14:
        result = 0.0
    return math.sqrt(result)


# Do a WKB integration:
# T = exp(-2*gamma)
# This function just computes gamma.
def WKBint(E,m):
    return math.sqrt(2*m)*AngBohr*integrate.quad(WKBintegrand, 0, RClength, args=(E), full_output=0, epsabs=1e-14, epsrel=1e-14, limit=500000)[0]


def numeratorIntegrand(E,m):
    return 1/(1+exp(2*WKBint(E,m)))*exp(-E/(kB*T))




#denominator = integrate.quad(lambda x: math.exp(-x/(kB*T)), Eb, Eb*5)

# Can analytically integrate the denominator...
denominator = kB*T/Eb * math.exp( -Eb/(kB*T) )
print denominator

print "WKB"+str(WKBint(0.00,m))
print "WKB"+str(WKBint(0.005,m))
print "WKB"+str(WKBint(0.010,m))

print "Numerator:"
#numerator = integrate.quad(lambda thisE: 1/(1+exp(2*WKBint(thisE,m)))*exp(-thisE/(kB*T)), 0, 0.1)
#print numerator
numerator = integrate.quad(numeratorIntegrand, 0, 0.1, args=(m), full_output=0, epsabs=1e-16, epsrel=1e-16, limit=500000)
print numerator

print "Correction:"
print numerator[0]/denominator

print "Classical:"
classicalT = math.exp( -Eb/(kB*T) )
print classicalT

print "Rate:"
print (numerator[0]/denominator)*classicalT

#correction = integrate.dblquad(lambda thisE,x: 1/(1+math.exp(math.sqrt(JoeV)*2*math.sqrt(2*m)/hbar*WKBintegrand(x,thisE)))*math.exp(-thisE/(kB*T)), 0,100, lambda x:0,lambda x:RClength)
#print correction

