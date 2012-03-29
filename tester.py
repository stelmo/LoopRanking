# -*- coding: utf-8 -*-
"""
Created on Mon Mar 26 23:24:42 2012

@author: St Elmo Wilken
"""

from localGainCalculator import localgains

test = localgains("testConn.csv","testIGprop.txt",4) #dont forget to update the state-case variable
#test = localgains("connections.csv","inputgains45.txt",13)
#print(test.connectionmatrix) #works
#print(test.localchangematrix) #works
#print(test.localdiffmatrix) #works
print(test.linlocalgainmatrix) #testing this
gainarray = test.linlocalgainmatrix

import csv
spam = csv.writer(open("openloopgainarray.txt",'w'))
for row in gainarray:
    print(row)
print("done")









