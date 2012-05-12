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
    controlobject = loopranking(datamatrix.scaledforwardgain, datamatrix.scaledforwardvariablelist, datamatrix.scaledbackwardgain, datamatrix.scaledbackwardvariablelist, datamatrix.nodummyvariablelist)
    
    datamatrixNC = formatmatrix("connectionsTE.csv","localave50statesNOCONTROLscaled.txt",13,0 )
    nocontrolobject = loopranking(datamatrixNC.scaledforwardgain, datamatrixNC.scaledforwardvariablelist, datamatrixNC.scaledbackwardgain, datamatrixNC.scaledbackwardvariablelist, datamatrixNC.nodummyvariablelist)
   
#    controlobject.printBlendedRanking()
#    nocontrolobject.printBlendedRanking()
#    
#    controlobject.displayImportancesCvsNC(datamatrixNC.nodummyconnection, nocontrolobject.blendedranking, datamatrix.nodummyconnection, controlobject.blendedranking)
#    controlobject.exportToGML()

    datamatrixBroken1 = formatmatrix("connectionsTEcontrol.csv", "localaveBROKEN1.txt", 18 ,0)
    brokencontrol1 = loopranking(datamatrixBroken1.scaledforwardgain, datamatrixBroken1.scaledforwardvariablelist, datamatrixBroken1.scaledbackwardgain, datamatrixBroken1.scaledbackwardvariablelist, datamatrixBroken1.nodummyvariablelist)
    
    datamatrixBroken2 = formatmatrix("connectionsTEcontrol.csv", "localaveBROKEN2.txt", 18 ,0)
    brokencontrol2 = loopranking(datamatrixBroken1.scaledforwardgain, datamatrixBroken1.scaledforwardvariablelist, datamatrixBroken1.scaledbackwardgain, datamatrixBroken1.scaledbackwardvariablelist, datamatrixBroken1.nodummyvariablelist)
    
    
    [valvelist1, valvedict1] = brokencontrol1.rankDifference(controlobject.blendedranking, brokencontrol1.blendedranking)
    
    [valvelist2, valvedict2] = brokencontrol2.rankDifference(controlobject.blendedranking, brokencontrol2.blendedranking)
    
    [out1, out2] = brokencontrol2.differenceOfDifference(valvedict1, valvedict2)
    
    for x in valvelist2:
        print(x)
    
else:
    #this works
    datamatrix = formatmatrix("connectionsTEcontrol.csv","controlcorrelation.txt",0,0,partialcorrelation=True)
    controlobject = loopranking(datamatrix.scaledforwardgain, datamatrix.scaledforwardvariablelist, datamatrix.scaledbackwardgain, datamatrix.scaledbackwardvariablelist, datamatrix.nodummyvariablelist)
    
    
    datamatrixNC = formatmatrix("connectionsTE.csv","controlcorrelationNOCONTROL.txt",0,0,partialcorrelation=True)
    nocontrolobject = loopranking(datamatrixNC.scaledforwardgain, datamatrixNC.scaledforwardvariablelist, datamatrixNC.scaledbackwardgain, datamatrixNC.scaledbackwardvariablelist, datamatrixNC.nodummyvariablelist)
   
#    controlobject.printBlendedRanking()
#    nocontrolobject.printBlendedRanking()
    
#    controlobject.displayImportancesCvsNC(datamatrixNC.nodummyconnection, nocontrolobject.blendedranking, datamatrix.nodummyconnection, controlobject.blendedranking)
#    controlobject.exportToGML()
    
    datamatrixBroken1 = formatmatrix("connectionsTEcontrol.csv","controlcorrelationBROKEN1.txt",0,0,partialcorrelation=True)
    brokencontrol1 = loopranking(datamatrixBroken1.scaledforwardgain, datamatrixBroken1.scaledforwardvariablelist, datamatrixBroken1.scaledbackwardgain, datamatrixBroken1.scaledbackwardvariablelist, datamatrixBroken1.nodummyvariablelist)
    
    [valvelist, valvedict] = brokencontrol1.rankDifference(controlobject.blendedranking, brokencontrol1.blendedranking)
    for x in valvelist:
        print(x)
    
      
     
    
