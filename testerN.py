# -*- coding: utf-8 -*-
"""
Created on Sat Feb 25 17:27:24 2012

@author: St Elmo Wilken
"""

import unittest
from clusterRank import cRanking

class testCRank(unittest.TestCase):
    
    def testCRankNoClusters(self):
        
        mat1 = [[0,0,1,0.5],[1.0/3,0,0,0],[1.0/3,1.0/2,0,1.0/2],[1.0/3,1.0/2,0,0]]
        mat2 = ['var1','var2','var3','var4']

        test = cRanking(mat1,mat2)
        
        from numpy import shape #check if gain matrix is square
        [row,col] = shape(test.gMatrix) 
        self.assertNotEqual(row, test.n+1, "The matrix is not square: rows")
        self.assertNotEqual(col, test.n+1, "The matrix is not square: columns")
        
        digits = 5 # number of digits of accuracy
        
        for i in range(test.n): #check if all columns sum to 1 in the gain Matrix (otherwise not-stochastic and not solution is not meaningful)
            self.assertAlmostEqual(sum(test.gMatrix[:,i]),1.0,digits)        
        
        self.assertAlmostEqual(test.maxeig, 1.0, digits)
        
        

