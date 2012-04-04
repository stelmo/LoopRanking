# -*- coding: utf-8 -*-
"""
Created on Mon Mar 26 23:24:42 2012

@author: St Elmo Wilken
"""

from localGainCalculator import localgains
from gainRank import gRanking
from RGABristol import RGA
import numpy as np

test = localgains("connectionsTE.csv","statesinputstep005h5.txt",13)
conn = test.connectionmatrix
#np.savetxt("connmat.txt.",conn)
diff = test.localdiffmatrix
np.savetxt("diffmat.txt",diff)
gainm = test.linlocalgainmatrix
np.savetxt("linloc.txt",gainm)
gainnorm = test.normaliseGainMatrix(gainm)
vararr = test.variables

test = gRanking(gainnorm, vararr)
test.showConnectRank()
print(test.sortedRankings)

test  = RGA(vararr, diff, 13, 12)
locgain = test.openloopmatrix
#print(test.bristolmatrix)
br = test.bristolmatrix
np.savetxt("bristol.txt",br)
print(test.pairedvariables)






