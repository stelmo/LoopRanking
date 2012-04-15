# -*- coding: utf-8 -*-
"""
Created on Sun Apr 15 13:34:20 2012

@author: St Elmo Wilken
"""

from formatmatrices import formatmatrix
from numpy import array
from localGainCalculator import localgains
from visualise import visualiseOpenLoopSystem

"""This is btest1 and its variations (to be added later)"""

test = formatmatrix("btest1.csv", "btest1ObviousConnections.txt", 3,0)

test2 = visualiseOpenLoopSystem(test.nodummyvariablelist, test.nodummydiff, 2) #because as many inputs as diff runs

nodepos = {test.nodummyvariablelist[0]: array([1,1]), test.nodummyvariablelist[1]: array([1,2]), test.nodummyvariablelist[2]: array([4,1]), test.nodummyvariablelist[3]: array([4,2])}

test2.displayConnectivityAndLocalGains(test.nodummyconnection, test.nodummygain, test.nodummyvariablelist, nodepos)
#test2.displayRGA(1, nodepos)
#test2.displayRGA(2, nodepos)
#test2.displayRGAmatrix()


test2.displayEigenWeights(test.nodummyconnection, test.nodummygain, test.nodummyvariablelist, test.nodummyN, nodepos)
test2.showAll()

"""**********************************************************"""

"""This is btest2"""

#test = formatmatrix("btest2.csv", "btest2GreedyConnections.txt", 3,0)
#
#test2 = visualiseOpenLoopSystem(test.nodummyvariablelist, test.nodummydiff, 2) #because as many inputs as diff runs
#
#nodepos = {test.nodummyvariablelist[0]: array([0.5,2]), test.nodummyvariablelist[1]: array([0.5,1]), test.nodummyvariablelist[2]: array([7,2]), test.nodummyvariablelist[3]: array([7,1]), test.nodummyvariablelist[4]: array([10,1.5])}
#
#test2.displayConnectivityAndLocalGains(test.nodummyconnection, test.nodummygain, test.nodummyvariablelist, nodepos)
#test2.displayRGA(1, nodepos)
#test2.displayRGA(2, nodepos)
#test2.displayRGAmatrix()
#test2.showAll()



