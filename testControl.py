# -*- coding: utf-8 -*-
"""
Created on Wed Apr 11 00:07:50 2012

@author: St Elmo Wilken
"""

from localGainCalculator import localgains
from gainRank import gRanking
from RGABristol import RGA
import numpy as np
from numpy import array, zeros

test1 = localgains("connectionsTE.csv", "scaledinputs005h5.txt", 13)
gainm = test1.normaliseGainMatrix(test1.linlocalgainmatrix)
varm = test1.variables
googlem = test1.normaliseGainMatrix(test1.connectionmatrix)

test2 = gRanking(gainm, varm)

test2.showConnectRank()
gainnc = array(test2.rankArray).reshape(-1,1)

test2 = gRanking(googlem, varm)
test2.showConnectRank()

googlenc = array(test2.rankArray).reshape(-1,1)

rationc = array(gainnc/googlenc).reshape(-1,1)

"""**************"""

test1 = localgains("connectionsTEcontrol.csv", "scaledcontrol.txt", 21)

gainm = test1.normaliseGainMatrix(test1.linlocalgainmatrix)
varm = test1.variables
googlem = test1.normaliseGainMatrix(test1.connectionmatrix)
test2 = gRanking(gainm, varm)

#test2.showConnectRank()
gainnc = array(test2.rankArray).reshape(-1,1)

test2 = gRanking(googlem, varm)
#test2.showConnectRank()

googlec = array(test2.rankArray).reshape(-1,1)

ratioc = array(gainnc/googlec).reshape(-1,1)

compare = array(zeros((49,2)))
compare[:,0] = rationc[:,0]
compare[:,1] = ratioc[:,0]
diff = array(compare[:,0] - compare[:,1]).reshape(-1,1)
print(diff)


