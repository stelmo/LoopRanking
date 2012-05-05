'''
Created on 05 May 2012

@author: St Elmo Wilken
'''
"""Import classes"""
from visualise import visualiseOpenLoopSystem
from gainRank import gRanking
from numpy import array, transpose, arange, empty
import networkx as nx
import matplotlib.pyplot as plt
from operator import itemgetter
from itertools import permutations, izip

class loopranking:
    """This class will:
    1) Rank the importance of nodes in a system with control
    1.a) Use the local gains to determine importance
    1.b) Use partial correlation information to determine importance
    2) Determine the change of importance when variables change
    """
    
    def __init__(self, fgainmatrix, fvariablenames, fconnectionmatrix, bgainmatrix, bvariablenames, bconnectionmatrix, nodummyvariablelist, alpha = 0.35):
        """This constructor will:
        1) create a graph with associated node importances based on local gain information
        2) create a graph with associated node importances based on partial correlation data"""
        
        self.forwardgain = gRanking(self.normaliseMatrix(fgainmatrix), fvariablenames)      
        self.backwardgain = gRanking(self.normaliseMatrix(bgainmatrix), bvariablenames)
        self.createBlendedRanking(nodummyvariablelist, alpha)
        
    def createBlendedRanking(self, nodummyvariablelist, alpha = 0.35):
        """This method will create a blended ranking profile of the object"""
        
        self.blendedranking = dict()
        
        for variable in nodummyvariablelist:
            self.blendedranking[variable] = (1 - alpha) * self.forwardgain.rankDict[variable] + (alpha) * self.backwardgain.rankDict[variable]
            
    def normaliseMatrix(self, inputmatrix):
        """This method normalises the absolute value of the input matrix
        in the columns i.e. all columns will sum to 1
        
        It also appears in localGainCalculator but not for long! Unless I forget
        about it..."""
        
        [r, c] = inputmatrix.shape
        inputmatrix = abs(inputmatrix) #doesnt affect eigen
        normalisedmatrix = []
        
        for col in range(c):
            colsum = float(sum(inputmatrix[:, col]))
            for row in range(r):
                if (colsum != 0):
                    normalisedmatrix.append(inputmatrix[row, col] / colsum) #this was broken! fixed now...
                else:
                    normalisedmatrix.append(0.0)
                        
        normalisedmatrix = transpose(array(normalisedmatrix).reshape(r, c))
        return normalisedmatrix       
    
