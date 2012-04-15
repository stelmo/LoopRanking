# -*- coding: utf-8 -*-
"""
Created on Mon Mar 26 23:24:42 2012

@author: St Elmo Wilken
"""

from localGainCalculator import localgains
from gainRank import gRanking
from RGABristol import RGA
import numpy as np

import matplotlib.pyplot as plt

test1 = localgains("testFourConnections.csv", "testFourIG.txt", 5)
gainm = test1.normaliseGainMatrix(test1.linlocalgainmatrix)
varm = test1.variables
googlem = test1.normaliseGainMatrix(test1.connectionmatrix)
test2 = gRanking(googlem, varm)

#print(test2.sortedRankingsKey)
#print(test2.sortedRankingsValue)
#test2.showConnectRank()

localdiffsm = test1.localdiffmatrix
test3 = RGA(varm, localdiffsm, 5, 3) #remember to change me for each case!!!
#print(test3.pairedvariables)
haha = test3.bristolmatrix
print(haha)
#print(test3.openloopmatrix)
np.savetxt("rgatest.txt",haha)

plt.matshow(haha)
plt.show()