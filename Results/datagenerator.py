# -*- coding: utf-8 -*-
"""
Created on Sat Mar 31 22:55:31 2012

@author: St Elmo Wilken
"""

#this script should generate all the required data of the TE

from RGABristol import RGA
from localGainCalculator import localgains
from gainRank import gRanking

#the Tennessee Eastman Problem: 25h step to 100
step1 = localgains("connectionsTEnormallyconnected.csv", "inputgains45Scaled.txt", 13)
import numpy as np
localgainmatrix = step1.normaliseGainMatrix(step1.linlocalgainmatrix)
variables = step1.variables
np.savetxt("linearscaledlocalgainsTEnormallyconnected25hto100.txt", localgainmatrix, delimiter = ",")

#Ranking part
step2 = gRanking(localgainmatrix,variables)
#step2.showConnectRank()

import csv
w = csv.writer(open("rankingval.txt","w"))
w.writerow("blah")

#import csv
#w = csv.writer(open('filename.csv', 'w'))
#w.writerow(list_of_header_names)
#w.writerows(a)

step3 = RGA("connectionsTEnormallyconnected.csv", "inputgains45Scaled.txt", 13)
bristolarray = step3.bristolmatrix
np.savetxt("bristolmatrixTEnormallyconnected25hto100.txt", bristolarray, delimiter = ",")
