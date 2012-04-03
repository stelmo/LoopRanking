# -*- coding: utf-8 -*-
"""
Created on Mon Mar 26 23:24:42 2012

@author: St Elmo Wilken
"""

from localGainCalculator import localgains
from gainRank import gRanking
from RGABristol import RGA
#the Tennessee Eastman Problem!
step1 = localgains("connectionsTE.csv", "inputgains45Scaled.txt", 13) #dont forget to update the state-case variable
import numpy as np
localgainmatrix = step1.normaliseGainMatrix(step1.linlocalgainmatrix)
variables = step1.variables
#np.savetxt("linearscaledlocalgainsTE.txt", localgainmatrix, delimiter = ",")

#print(localgainmatrix)
#print(variables)
#this has all been saved to an excel

#lets see what the rankings look like!
#step2 = gRanking(localgainmatrix,variables)
#step2.showConnectRank()
#sortme = step2.rankDict
#for w in sorted(sortme, key=sortme.get):
#    print w, sortme[w]
#
#
#step3 = RGA("connectionsTEfullyconnected.csv", "inputgains45Scaled.txt", 13)
##print(step3.pairedvariables)
#bristolarray = step3.bristolmatrix
##print(step3.inputs)
##print(step3.outputs)
#np.savetxt("bristolmatrixTEfullyconnected.txt", bristolarray, delimiter = ",")
#
##test = RGA("testThreeConnections.csv","testThreeIG.txt", 5)
##gainmatrix = test.openloopgainmatrix.transpose() #this is transposed for convenience
##variables = test.variablecorrection
##rgab = test.bristolmatrix
##print(rgab)
##print(variables)
##print(test.pairedvariables)




