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

testcase = '1local' #use local gains to calculate importances

if testcase == 'local':
    
    datamatrix = formatmatrix("connectionsTEcontrol.csv", "scaledcontrol.txt", 21 ,0)
    controlmatrix = loopranking(datamatrix.scaledforwardgain, datamatrix.scaledforwardvariablelist, datamatrix.scaledforwardconnection, datamatrix.scaledbackwardgain, datamatrix.scaledbackwardvariablelist, datamatrix.scaledbackwardconnection, datamatrix.nodummyvariablelist)
    """Now you have a control matrix which has a dictionary of "ideal" blended node importances based on local gains"""
    
else:
    
    datamatrix = formatmatrix("connectionsTEcontrol.csv","correlatedcontrol.txt",0,0,partialcorrelation=True)
    
        
    
