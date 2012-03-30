# -*- coding: utf-8 -*-
"""
Created on Fri Mar 30 20:46:04 2012

@author: St Elmo Wilken
"""

import unittest
from RGABristol import RGA
#im not sure what a good test would be for the actual rga... 
#i do test that i have the correct sequence of variables and
#the correct open loop gain array...

class testRGA(unittest.TestCase):
    
    def testRGA4x4(self):
        #this test a very simple 4x4 system
        #this is the only system where i could verify that the RGA is correctly calculated
        #mostly because the inverse is easy to calculate
       test = RGA("testOneConnections.csv","testOneIG.txt",4)
       gainmatrix = test.openloopgainmatrix.transpose() #this is transposed for convenience
       variables = test.variablecorrection
       rga = test.bristolmatrix
       
       expectedgainmatrix = [2,5,3,7]
       expectedvariables = [0,1,0,1,1,0,1,0]
       expectedrga = [-14,15,15,-14]
       
       for testelement, element in zip(gainmatrix.flat, expectedgainmatrix):
           self.assertAlmostEquals(testelement, element,1)
           
       for testelement, element in zip(variables.flat, expectedvariables):
           self.assertAlmostEquals(testelement, element,1)
           
       for testelement, element in zip(rga.flat, expectedrga):
           self.assertAlmostEquals(testelement, element,1)   
       
    def testRGA7x7(self):
       test = RGA("testThreeConnections.csv","testThreeIG.txt",5)
       gainmatrix = test.openloopgainmatrix.transpose()
       variables = test.variablecorrection
       
       expectedgainmatrix = [1,0,0,0,11,0,0,1,0,0,0,13,0,0,2,5,0,0,0,0,3,7,0,0,0,0,0,0,19,17]
       expectedvariables = [0,1, 0,1, 1,1, 1,1, 1,1, 1,1, 1,0]
       
       for testelement, element in zip(gainmatrix.flat, expectedgainmatrix):
           self.assertAlmostEquals(testelement, element,1)
           
       for testelement, element in zip(variables.flat, expectedvariables):
           self.assertAlmostEquals(testelement, element,1)

    def testRGA9x9(self):
       test = RGA("testFourConnections.csv","testFourIG.txt",5)
       gainmatrix = test.openloopgainmatrix.transpose()
       variables = test.variablecorrection
       
       expectedgainmatrix = [1,0,0,0,0,0,0,0, 0,1,0,0,0,0,0,11, 0,0,1,0,0,0,0,0, 0,0,0,2,3,0,0,0, 0,0,0,0,7,5,0,0, 0,0,0,0,0,0,13,17]
       expectedvariables = [0,1, 0,1, 0,1, 1,1, 1,1, 1,1, 1,1, 1,1, 1,0]
       
       for testelement, element in zip(gainmatrix.flat, expectedgainmatrix):
           self.assertAlmostEquals(testelement, element,1)
           
       for testelement, element in zip(variables.flat, expectedvariables):
           self.assertAlmostEquals(testelement, element,1)

if __name__ == "__main__":
    unittest.main()   