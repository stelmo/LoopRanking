# -*- coding: utf-8 -*-
"""
Created on Fri Feb 24 16:38:56 2012

@author: St Elmo Wilken
"""
import unittest
from gainRank import gRanking

class testGRank(unittest.TestCase):
    
    def testGRankInputMatrixOne(self):
        mat1 = [[0,0,1,0.5],[1.0/3,0,0,0],[1.0/3,1.0/2,0,1.0/2],[1.0/3,1.0/2,0,0]]
        mat2 = ['var1','var2','var3','var4']

        testOne = gRanking(mat1,mat2)

        digits = 5 # number of digits of accuracy

        self.assertAlmostEqual(testOne.maxeig, 1.0, digits)

        expectedvalues = [ 0.36815068,  0.14180936,  0.28796163,  0.20207834]
        
        for calculated, expected in zip(expectedvalues, testOne.rankArray):
            self.assertAlmostEqual(calculated, expected, digits)
        #how do I check if testOne has thrown an error? CS: use assertRaises
        
if __name__ == "__main__":
    unittest.main()

        



