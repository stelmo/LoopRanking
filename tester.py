# -*- coding: utf-8 -*-
"""
Created on Mon Mar 26 23:24:42 2012

@author: St Elmo Wilken
"""

from localGainCalculator import localgains

test = localgains("connections.csv","inputgains.txt",13)
#print(test.connectionmatrix) #works
#print(test.localchangematrix) #works
print(test.localgainmatrix) #how do I see whats happening here?








