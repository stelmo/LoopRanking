# -*- coding: utf-8 -*-
"""
Created on Sun Apr 15 13:04:23 2012

@author: St Elmo Wilken
"""

"""Import classes"""
from localGainCalculator import localgains
import numpy as np
from numpy import array, transpose


class formatmatrix:
    """This class should format the input connection, gain and variable name matrices.
    This should make it such that you will never have to call localGainCalculator.
    For self made test systems you will have numberofdummyvariables not equal to 0;
    this is especially true if you have recycle streams.
    Additionally, you might want to run formatDiffMatrixForRGA if you have more runs
    than inputs otherwise RGABristol will not work properly. """
    
    def __init__(self, locationofconnections, locationofstates, numberofruns, numberofdummyvariables):
        """This class will assume you input a connection matrix (ordered according 
        to the statematrix) with the numberofdummy variables the first N variables
        which are dummy variables to be stripped. """
        
        self.initialiseSystem(locationofconnections, locationofstates, numberofruns)
        self.removeDummyVariables(numberofdummyvariables) #can be zero!
        
    
    def initialiseSystem(self, locationofconnections, locationofstates, numberofruns):
        """This method should create the orignal gain matrix (incl dummy gains)
        and the original connection matrix"""
        
        original = localgains(locationofconnections, locationofstates, numberofruns)
        
        self.originalgain = original.linlocalgainmatrix
        self.originaln =original.n #number of rows or columns of gain matrix
        self.variablelist = original.variables
        self.originaldiff = original.localdiffmatrix
        self.originalconnection = original.connectionmatrix
        
    def removeDummyVariables(self, numberofdummyvariables):
        """This method assumed the first variables up to numberofdummyvariables
        are the dummy variables"""
        
        #fix the list of variables
        self.nodummyvariablelist = [] #necessary for a list copy
        self.nodummyvariablelist.extend(self.variablelist)
        self.nodummygain = self.originalgain.copy()
        self.nodummyconnection = self.originalconnection.copy()
        self.nodummydiff = self.originaldiff.copy()
        for index in range(numberofdummyvariables):
            self.nodummyvariablelist.pop(0)
            self.nodummygain = np.delete(self.nodummygain,0,0)        
            self.nodummygain = np.delete(self.nodummygain,0,1)
            self.nodummydiff = np.delete(self.nodummydiff,0,0) #you don't want to delete "runs" i.e. columns from the difference matrix       
            self.nodummyconnection = np.delete(self.nodummyconnection,0,0)        
            self.nodummyconnection = np.delete(self.nodummyconnection,0,1)
            
        [r, c] = self.nodummyconnection.shape
        self.nodummyN = r
        
    def formatDiffMatrixForRGA(self, numberofinputs):
        """This method will format the difference matrix such that the RGA method 
        getOpenLoopGain will work properly. It assumes that the no-dummy difference 
        matrix steps each input individually.
        
        This method will create a 2D array where the number of inputs = number of
        columns and the number of rows equals the number of input + output variables.
        Everything should still be ordered. """
        
        self.nodummyRGAformatDiff = []
        
        for ncol in range(numberofinputs):
            self.nodummyRGAformatDiff.append(self.nodummydiff[:,ncol])
            
        self.nodummyRGAformatDiff = transpose(array(self.nodummyRGAformatDiff).reshape(numberofinputs,-1))
        #this works
        
        

        
        
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    