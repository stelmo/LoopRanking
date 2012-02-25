# -*- coding: utf-8 -*-
"""
Created on Sat Feb 25 17:09:34 2012

@author: St Elmo Wilken
"""

class nRanking:
    
    def __init__(self,inMat1,inMat2):
        from numpy import array        
        self.gMatrix = array(inMat1) #feed in a normalised gain matrix
        self.gVariables = inMat2 #feed in ordered variables wrt gMatrix
        self.construcRankArray()
                
        
        
    def construcRankArray(self):
        from numpy import ones, argmax
        from numpy import linalg as linCalc
        
        self.n = len(self.gMatrix) #length of gain matrix = number of nodes
        m = 0.15
        S = (1.0/self.n)*ones((self.n,self.n))
        
        self.M = (1-m)*self.gMatrix + m*S #basic page rank algorithm
        [eigVal, eigVec] = linCalc.eig(self.M) #calc eigenvalues, eigenvectors as usua
    
    def showConnectRank(self):
        pass

if __name__ == "__main__":
    test = cRanking()
    print(test.M)
    
