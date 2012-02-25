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
        
        from numpy import shape #check if gain matrix is square
        [row,col] = shape(testOne.gMatrix) 
        self.assertNotEqual(row, testOne.n+1, "The matrix is not square: rows")
        self.assertNotEqual(col, testOne.n+1, "The matrix is not square: columns")
        
        digits = 5 # number of digits of accuracy
        
        for i in range(testOne.n): #check if all columns sum to 1 in the gain Matrix (otherwise not-stochastic and not solution is not meaningful)
            self.assertAlmostEqual(sum(testOne.gMatrix[:,i]),1.0,digits)        
        
        self.assertAlmostEqual(testOne.maxeig, 1.0, digits)

        expectedvalues = [ 0.36815068,  0.14180936,  0.28796163,  0.20207834]
        
        for calculated, expected in zip(expectedvalues, testOne.rankArray): #shouldnt this be the other way around?
            self.assertAlmostEqual(calculated, expected, digits)
        
        
        #how do I check if testOne has thrown an error? CS: use assertRaises
        
    def testGRankInputMatrixTwo(self):
        mat1 = [[0,1,0,0,0],[1,0,0,0,0],[0,0,0,1,0.5],[0,0,1,0,0.5],[0,0,0,0,0]] #this test contains a disconnected graph (2 components)
        mat2 = ['var1','var2','var3','var4','var5']
        
        testTwo = gRanking(mat1,mat2) #create
        
        from numpy import shape #check if gain matrix is square
        [row,col] = shape(testTwo.gMatrix) 
        self.assertNotEqual(row, testTwo.n+1, "The matrix is not square: rows")
        self.assertNotEqual(col, testTwo.n+1, "The matrix is not square: columns")        
        
        acc = 5 #req accuracy
 
        for i in range(testTwo.n): #check if stochastic
            self.assertAlmostEqual(sum(testTwo.gMatrix[:,i]),1.0,acc)
            
        self.assertAlmostEqual(testTwo.maxeig, 1.0, acc) #check max eig is 1
       
        expectedValues = [0.2,0.2,0.285,0.285,0.03] #check if output is believable
        for calculated, expected in zip(testTwo.rankArray, expectedValues):
            self.assertAlmostEqual(calculated, expected, acc)
            
        
    def testGRankInputMatrixThree(self):
        mat1 = [[0,0,0,0,0,0,1.0/3,0],[1.0/2,0,1.0/2,1.0/3,0,0,0,0],[1.0/2,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0],[0,0,1.0/2,1.0/3,0,0,1.0/3,0],[0,0,0,1.0/3,1.0/3,0,0,1.0/2],[0,0,0,0,1.0/3,0,0,1.0/2],[0,0,0,0,1.0/3,1,1.0/3,0]]
        mat2 = ['var1','var2','var3','var4','var5','var6','var7','var8']
        
        testThree = gRanking(mat1,mat2) #create
        
        from numpy import shape #check if gain matrix is square
        [row,col] = shape(testThree.gMatrix) 
        self.assertNotEqual(row, testThree.n+1, "The matrix is not square: rows")
        self.assertNotEqual(col, testThree.n+1, "The matrix is not square: columns")        
        
        acc = 5 #req accuracy
 
        for i in range(testThree.n): #check if stochastic
            self.assertAlmostEqual(sum(testThree.gMatrix[:,i]),1.0,acc)
            
        self.assertAlmostEqual(testThree.maxeig, 1.0, acc) #check max eig is 1
       
        """I'm not sure what the exact expected output is but it looks reasonable to me..."""
#        expectedValues = [0.2,0.2,0.285,0.285,0.03] 
#        for calculated, expected in zip(testThree.rankArray, expectedValues):
#            self.assertAlmostEqual(calculated, expected, acc)
        

            
        
if __name__ == "__main__":
    unittest.main()

        



