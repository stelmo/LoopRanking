# -*- coding: utf-8 -*-
"""
Created on Sat Feb 25 17:27:24 2012

@author: St Elmo Wilken
"""

import unittest
from nodeRank import nRanking
from gainRank import gRanking

class testNRank(unittest.TestCase):
    
    def testNRankInputMatrixOne(self):
        
        mat1 = [[0,0,1,0.5],[1.0/3,0,0,0],[1.0/3,1.0/2,0,1.0/2],[1.0/3,1.0/2,0,0]]
        mat2 = ['var1','var2','var3','var4'] 
        mat3 = [1,2,1,1] #so var2 is twice as important as the other variables
        
        
        #test to see if nRanking defaults to gRanking if alpha = 0
        test = nRanking(mat1,mat2,0,mat3) #node and gain ranking are of equal importance
        testCompare = gRanking(mat1,mat2)
        
        for inclIntrinsic, exclIntrinsic in zip(test.rankArray, testCompare.rankArray):
            self.assertAlmostEqual(inclIntrinsic, exclIntrinsic,msg="Does not simplify to gRanking")
        
        #test to see if important node is more important using this algorithm
        test = nRanking(mat1, mat2, 0.5, mat3)
        from numpy import array
        highlighted = array((array(mat3) > 1), dtype=int)
        for nrank, grank, high in zip(test.rankArray, testCompare.rankArray, highlighted):
            if (high == 1):
                self.assertGreater(nrank,grank,"The more important node is not more important!")
    
    def testNRankInputMatrixThree(self):
        
        mat1 = [[0,0,0,0,0,0,1.0/3,0],[1.0/2,0,1.0/2,1.0/3,0,0,0,0],[1.0/2,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0],[0,0,1.0/2,1.0/3,0,0,1.0/3,0],[0,0,0,1.0/3,1.0/3,0,0,1.0/2],[0,0,0,0,1.0/3,0,0,1.0/2],[0,0,0,0,1.0/3,1,1.0/3,0]]
        mat2 = ['var1','var2','var3','var4','var5','var6','var7','var8'] 
        mat3 = [1,2,1,1,2,1,1,1] #so var2,var5 is twice as important as the other variables 
        
        #test to see if nRanking defaults to gRanking if alpha = 0
        test = nRanking(mat1,mat2,0,mat3) #node and gain ranking are of equal importance
        testCompare = gRanking(mat1,mat2)
        
        for inclIntrinsic, exclIntrinsic in zip(test.rankArray, testCompare.rankArray):
            self.assertAlmostEqual(inclIntrinsic, exclIntrinsic,msg="Does not simplify to gRanking")
        
        #test to see if important node is more important using this algorithm
        test = nRanking(mat1, mat2, 0.5, mat3)
        from numpy import array
        highlighted = array((array(mat3) > 1), dtype=int)
        for nrank, grank, high in zip(test.rankArray, testCompare.rankArray, highlighted):
            if (high == 1):
                self.assertGreater(nrank,grank,"The more important node is not more important!")
    
    def testNRankTestPlantFeedReactorSeparatorRecycleOutput(self):
        
        mat1 = [[0,0,0,0,0,0,0,0,0,0,0,0.5,0,0],[0,0,0,0,0,0,0,0,0,0,0.5,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0.5,0,0],[0,0,0,0,0,0,0,0,0,0,0.5,0,0,0],[1.0/3,0,1.0/3,0,0,0,1.0/3,0,0,0,0,0,0,1.0/3],[1.0/3,0,1.0/3,0,1,0,1.0/3,0,0,0,0,0,0,1.0/3],[0,1,0,1,0,0.5,0,0,0,0,0,0,1,0],[1.0/3,0,1.0/3,0,0,0.5,0,0,0,0,0,0,0,1.0/3],[0,0,0,0,0,0,1.0/3,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0.5,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0.5,0,0,0,0],[0,0,0,0,0,0,0,0,0.5,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0.5,0,0,0,0]]   
        mat2 = ["T1","F1","T2","F2","R1","X1","F3","T3","F4","T4","F6","T6","F5","T5"]
        mat3 = [4,1,4,1,1,1,1,4,1,4,1,4,1,4] #all the temperature variable are 4 times more important than the other ones (why? for safety reasons)
       
        #test to see if nRanking defaults to gRanking if alpha = 0
        test = nRanking(mat1,mat2,0,mat3) #node and gain ranking are of equal importance
        testCompare = gRanking(mat1,mat2)
        
        for inclIntrinsic, exclIntrinsic in zip(test.rankArray, testCompare.rankArray):
            self.assertAlmostEqual(inclIntrinsic, exclIntrinsic,msg="Does not simplify to gRanking")
        
        #test to see if important node is more important using this algorithm
        test = nRanking(mat1, mat2, 0.5, mat3)
        from numpy import array
        highlighted = array((array(mat3) > 1), dtype=int)
        for nrank, grank, high in zip(test.rankArray, testCompare.rankArray, highlighted):
            if (high == 1):
                self.assertGreater(nrank,grank,"The more important node is not more important!")
    
    
        
if __name__ == "__main__":
    unittest.main()

    

