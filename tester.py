# -*- coding: utf-8 -*-
"""
Created on Mon Mar 26 23:24:42 2012

@author: St Elmo Wilken
"""

from localGainCalculator import localgains
from RGABristol import RGA

test = localgains("testOneConnections.csv","testOneIG.txt",4) #dont forget to update the state-case variable
###test = localgains("connections.csv","inputgains45.txt",13)
##print(test.connectionmatrix) #works
##print(test.localchangematrix) #works
###print(test.localdiffmatrix) #works
#print(test.linlocalgainmatrix) #testing this
#print(test.linlocalgainmatrixAV)
print(test.avelocalgainmatrix)
print(test.avelocalgainmatrixAV)
##gainarray = test.linlocalgainmatrix
#
##import csv
##spam = csv.writer(open("openloopgainarray.txt",'w'))
##for row in gainarray:
##    print(row)
##print("done")

#localgains("testOneConnections.csv","testOneIG.txt",4)

test = RGA("testOneConnections.csv","testOneIG.txt",4)
print(test.bristol)











