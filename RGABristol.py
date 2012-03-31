# -*- coding: utf-8 -*-
"""
Created on Fri Mar 30 00:45:09 2012

@author: St Elmo Wilken
"""

#attempt at an implementation of the Bristol/ RGA method

from localGainCalculator import localgains 

class RGA:
    
    def __init__(self,nameofconnections, nameoflocalchanges, states):
        self.getOpenLoopGainArray(nameofconnections, nameoflocalchanges, states)
        self.calculateBristolmatrix()
        self.calculateBristolpairings()
    
    def getOpenLoopGainArray(self, nameofconnections, nameoflocalchanges, states):
        temp = localgains(nameofconnections, nameoflocalchanges, states)
        self.allvariables = temp.variables #this is defined here and only used in the show method
        #the reason being i dont feel like create duplicate objects
        gainmatrix = temp.linlocalgainmatrix
        
        #delete full zero rowss
        from numpy import vstack, hstack, transpose, array
        flag = 0 # this makes sure that you can stack the empty initialised array
        rowvariables = []        
        for row in gainmatrix:
            if sum(abs(row)) != 0:
                if flag == 0:
                    rowcorrection = hstack(row)
                    flag = 1
                else:
                    rowcorrection = vstack((rowcorrection, row))
                rowvariables.append(1)
            else:
                rowvariables.append(0)
        
        #delete full zero columns
        flag = 0
        colvariables = []
        for col in transpose(rowcorrection):
            if sum(abs(col)) != 0:
                if flag == 0:
                    colcorrection = hstack(col)
                    flag = 1
                else:
                    colcorrection = vstack((colcorrection, col))
                colvariables.append(1)
            else:
                colvariables.append(0)

        self.openloopgainmatrix = colcorrection #you dont actually want to transpose this matrix
        #because: RGA is outputs in columns and inputs in rows.
        #they way we defined causality swaps this around. colcorrection is already transposed so
        #it is in the correct format 
        rowvariables = array(rowvariables).reshape(-1,1)
        colvariables = array(colvariables).reshape(-1,1)
        self.variablecorrection = hstack((rowvariables,colvariables))
        #what i mean by variablecorrection is how you would read the rga
        #some variables are cut because they influence nothing i.e. rows and columns of zero
        #this works
    
    def calculateBristolmatrix(self):
        #so basically the inverse is either square, left or right
        [r,c] = self.openloopgainmatrix.shape #because not necessarily square
        self.bristolmatrix = []
        import numpy as np
        from numpy import array
        if (r==c): #square
            if (np.linalg.det(self.openloopgainmatrix) != 0):
                R = np.linalg.inv(self.openloopgainmatrix).transpose()
                for gij, rij in zip(self.openloopgainmatrix.flat, R.flat):
                    self.bristolmatrix.append(gij*rij)
                self.bristolmatrix = array(self.bristolmatrix).reshape(r,r)
            else:
                print("Sorry, the open loop gain matrix is singular")
        else: #seems pinv calculates the moore-penrose inverse... so left or right inverse is not a problem
            R = np.linalg.pinv(self.openloopgainmatrix).transpose()
            for gij, rij in zip(self.openloopgainmatrix.flat, R.flat):
                self.bristolmatrix.append(gij*rij)
            self.bristolmatrix = array(self.bristolmatrix).reshape(r,c)
        #this all works and generates believable results
            
        
    def calculateBristolpairings(self):
        n = len(self.allvariables)
        self.outputs = []
        self.inputs = []
        self.pairedvariables = []
        for index in range(n):
            if self.variablecorrection[index, 0] == 1:
                self.outputs.append(self.allvariables[index]) 
            if self.variablecorrection[index, 1] == 1:
                self.inputs.append(self.allvariables[index])
        [r,c] = self.bristolmatrix.shape
        for row in range(r):
            for col in range(c):
                if self.bristolmatrix[row,col] >= 0.5:#this 0.5 comes from theory
                    self.pairedvariables.append(self.outputs[col])
                    self.pairedvariables.append(self.inputs[row])
        from numpy import array
        self.pairedvariables = array(self.pairedvariables).reshape(-1,2)
            
        