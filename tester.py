# -*- coding: utf-8 -*-
"""
Created on Mon Mar 26 23:24:42 2012

@author: St Elmo Wilken
"""

from localGainCalculator import localgains

#test = localgains("testConn.csv","testIG.txt",4) #dont forget to update the state-case variable
test = localgains("connections.csv","inputgains45.txt",13)
#print(test.connectionmatrix) #works
#print(test.localchangematrix) #works
#print(test.avelocalgainmatrix) #works
print(test.linlocalgainmatrix) #testing this










