'''
Created on 05 May 2012

@author: St Elmo Wilken
'''
"""This class will be used to run controlranking"""

"""Import classes"""
from controlranking import loopranking
from formatmatrices import formatmatrix
from numpy import array, transpose, arange, empty
import networkx as nx
import matplotlib.pyplot as plt
from operator import itemgetter

testcase = 'local' #use local gains to calculate importances if == local

if testcase == 'local':
    
    datamatrix = formatmatrix("connectionsTEcontrol.csv", "localave50statesscaled.txt", 17 ,0)
    datamatrixNC = formatmatrix("connectionsTE.csv","localave50statesNOCONTROLscaled.txt",13,0 )
    controlmatrix = loopranking(datamatrix.scaledforwardgain, datamatrix.scaledforwardvariablelist, datamatrix.scaledforwardconnection, datamatrix.scaledbackwardgain, datamatrix.scaledbackwardvariablelist, datamatrix.scaledbackwardconnection, datamatrix.nodummyvariablelist, datamatrixNC.scaledforwardgain, datamatrixNC.scaledforwardvariablelist, datamatrixNC.scaledforwardconnection, datamatrixNC.scaledbackwardgain, datamatrixNC.scaledbackwardvariablelist, datamatrixNC.scaledbackwardconnection)
    
    controlmatrix.displayControlImportances(datamatrixNC.nodummyconnection, datamatrix.nodummyconnection)
    
    controlmatrix.showAll()
    controlmatrix.exportToGML()
else:
    #this works
    datamatrix = formatmatrix("connectionsTEcontrol.csv","controlcorrelation.txt",0,0,partialcorrelation=True)
    datamatrixNC = formatmatrix("connectionsTE.csv","controlcorrelationNOCONTROL.txt",0,0,partialcorrelation=True)
    controlmatrix = loopranking(datamatrix.scaledforwardgain, datamatrix.scaledforwardvariablelist, datamatrix.scaledforwardconnection, datamatrix.scaledbackwardgain, datamatrix.scaledbackwardvariablelist, datamatrix.scaledbackwardconnection, datamatrix.nodummyvariablelist, datamatrixNC.scaledforwardgain, datamatrixNC.scaledforwardvariablelist, datamatrixNC.scaledforwardconnection, datamatrixNC.scaledbackwardgain, datamatrixNC.scaledbackwardvariablelist, datamatrixNC.scaledbackwardconnection)
    
    controlmatrix.displayControlImportances(datamatrixNC.nodummyconnection, datamatrix.nodummyconnection)
    
    controlmatrix.showAll()
    controlmatrix.exportToGML()
        
    
