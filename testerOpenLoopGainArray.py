# -*- coding: utf-8 -*-
"""
Created on Thu Mar 29 21:13:04 2012

@author: St Elmo Wilken
"""

import unittest
from localGainCalculator import localgains

class testLGC(unittest.TestCase):
    
    def testLGC4x4(self):
        
        testOne = localgains("testOneConnections.csv","testOneIG.txt",4)
        expectedLocalGains = [0,0,0,0, 0,0,0,0, 2,5,0,0, 3,7,0,0]
        
        for element1, element2 in zip(expectedLocalGains, testOne.linlocalgainmatrix.flat):
            self.assertAlmostEquals(element1,element2,5)
    
    def testLGC9x9(self):
        #this test has 1 recycle stream and 3 inputs
        #due to an earlier irregularity with variable assigning testfour = testtwo
        #i will talk to you about this... it could potentially be a problem
        testTwo = localgains("testFourConnections.csv","testFourIG.txt",5)
        expectedLocalGains = [0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0, 1,0,0,0,0,0,0,0,0, 0,1,0,0,0,0,0,11,0, 0,0,1,0,0,0,0,0,0, 0,0,0,2,3,0,0,0,0, 0,0,0,0,7,5,0,0,0, 0,0,0,0,0,0,13,17,0]
        
        for element1, element2 in zip(expectedLocalGains, testTwo.linlocalgainmatrix.flat):
            self.assertAlmostEquals(element1,element2,1) #this one is not very accurate... relatively speaking
    
    def testLGC7x7(self):
        #this test has 2 recycle streams and 2 inputs
        testThree = localgains("testThreeConnections.csv","testThreeIG.txt",5)
        
        expectedLocalGains = [0,0,0,0,0,0,0, 0,0,0,0,0,0,0, 1,0,0,0,11,0,0, 0,1,0,0,0,13,0, 0,0,2,5,0,0,0, 0,0,3,7,0,0,0, 0,0,0,0,19,17,0 ]
        
        for element1, element2 in zip(expectedLocalGains, testThree.linlocalgainmatrix.flat):
            self.assertAlmostEquals(element1,element2,2) #this one is not very accurate... relatively speaking

        
if __name__ == "__main__":
    unittest.main()       