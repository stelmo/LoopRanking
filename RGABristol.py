# -*- coding: utf-8 -*-
"""
Created on Fri Mar 30 00:45:09 2012

@author: St Elmo Wilken
"""

#attempt at an implementation of the Bristol/ RGA method

from localGainCalculator import localgains 

class RGA:
    
    def __init__(self,nameofconnections,nameoflocalchanges,states):
        self.getOpenLoopGainArray(nameofconnections,nameoflocalchanges,states)
        self.calculateBristolmatrix()
    
    def getOpenLoopGainArray(self,nameofconnections,nameoflocalchanges,states):
        temp = localgains(nameofconnections,nameoflocalchanges,states)
        self.openloopgainmatrix = temp.avelocalgainmatrix #ave seems better than the linear combination method but still no cigar
    
    def calculateBristolmatrix(self):
        from numpy import transpose, array
        import numpy as np
        if (np.linalg.det(self.openloopgainmatrix) != 0):
            self.R = transpose(np.linalg.inv(self.openloopgainmatrix))
            self.bristol = [] #spelled like this becuase lambda is a reserved word        
        
            for rij, gij in zip(self.R.flat,self.openloopgainmatrix.flat):
                self.bristol.append(rij*gij)
            nn = len(self.bristol)**0.5
            self.bristol = array(self.bristol).reshape(nn,nn)
        else:
            print("Sorry, this open loop gain matrix is singular i.e. it has no inverse")
            self.bristol = []
        

            
        
        

        
    