# -*- coding: utf-8 -*-
"""
Created on Fri Mar 30 00:45:09 2012

@author: St Elmo Wilken
"""

#attempt at an implementation of the Bristol/ RGA method

class RGA:
    
    def __init__(self, variables, localdiffs, states, numberofinputs):
        self.getOpenLoopGainArray(localdiffs, states, numberofinputs)
        self.calculateBristolmatrix()
        self.calculateBristolpairings(variables, numberofinputs)
    
    def getOpenLoopGainArray(self, localdiffs, states, numberofinputs):
        from numpy import where, array, empty        
        [r, c] = localdiffs.shape
        outputs = localdiffs[numberofinputs:r, :] 
        [r, c] = outputs.shape
        self.openloopmatrix = array(empty((numberofinputs, r)))
        inputs = localdiffs[:numberofinputs, :] #array of inputs
        [r, c] = inputs.shape
        for row in inputs:
            index = array(where(row != 0))[0,0] #this returns which input is being changed: column reference
            outputsincolumn = outputs[:, index].transpose()
            rowoutputs = outputsincolumn/row[index]
            self.openloopmatrix[index, :] = rowoutputs
        """ this method breaks up the data (experiment) array into two pieces: an input side and an output side
        the input side is scanned and the indices where the change is not 0 (i.e. where the input was stepped) are stored
        the output side is transposed; the change in input corrosponding to the output column vector is divided. 
        these rows are then stacked together to generate an overall gain matrix"""
        
    
    def calculateBristolmatrix(self):
        #so basically the inverse is either square, left or right
        [r,c] = self.openloopmatrix.shape #because not necessarily square
        self.bristolmatrix = []
        import numpy as np
        from numpy import array
        if (r==c): #square
            if (np.linalg.det(self.openloopmatrix) != 0):
                R = np.linalg.inv(self.openloopmatrix).transpose()
                for gij, rij in zip(self.openloopmatrix.flat, R.flat):
                    self.bristolmatrix.append(gij*rij)
                self.bristolmatrix = array(self.bristolmatrix).reshape(r,r)
            else:
                print("Sorry, the open loop gain matrix is singular")
        else: #seems pinv calculates the moore-penrose inverse... so left or right inverse is not a problem
            R = np.linalg.pinv(self.openloopmatrix).transpose()
            for gij, rij in zip(self.openloopmatrix.flat, R.flat):
                self.bristolmatrix.append(gij*rij)
            self.bristolmatrix = array(self.bristolmatrix).reshape(r,c)
        #this all works and generates believable results
        """ this method calculates the RG array. """   
        
    def calculateBristolpairings(self,vararrs,numofinputs):
        inputvars = vararrs[:numofinputs]        
        outputvars = vararrs[numofinputs:]
        [r, c] = self.bristolmatrix.shape
        self.pairedvariables = []
        for row in range(r):
            for col in range(c):
                if self.bristolmatrix[row,col] > 0.5: #from theory
                    self.pairedvariables.append(inputvars[row])
                    self.pairedvariables.append(outputvars[col])
        from numpy import array
        self.pairedvariables = array(self.pairedvariables).reshape(-1,2)
        """ this just generates a matrix of variables which should be paired using the RGA method"""
        
        
            
        