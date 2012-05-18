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

testcase = 'local1' #use local gains to calculate importances if == local

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
    brokencontrol2 = loopranking(datamatrixBroken2.scaledforwardgain, datamatrixBroken2.scaledforwardvariablelist, datamatrixBroken2.scaledbackwardgain, datamatrixBroken2.scaledbackwardvariablelist, datamatrixBroken2.nodummyvariablelist)
    
    datamatrixBroken3 = formatmatrix("connectionsTEcontrol.csv", "localaveBROKEN3.txt", 18 ,0)
    brokencontrol3 = loopranking(datamatrixBroken3.scaledforwardgain, datamatrixBroken3.scaledforwardvariablelist, datamatrixBroken3.scaledbackwardgain, datamatrixBroken3.scaledbackwardvariablelist, datamatrixBroken3.nodummyvariablelist)
    
    
    [valvelist1, valvedict1] = brokencontrol1.rankDifference(controlobject.blendedranking, brokencontrol1.blendedranking)
    
    [valvelist2, valvedict2] = brokencontrol2.rankDifference(controlobject.blendedranking, brokencontrol2.blendedranking)
    
    [valvelist3, valvedict3] = brokencontrol3.rankDifference(controlobject.blendedranking, brokencontrol3.blendedranking)
    
    [out1, out2] = brokencontrol2.differenceOfDifference(valvedict1, valvedict2)
    
    mvs = ['Stream 1', 'Stream 2', 'Stream 3', 'Stream 4', 'Compressor Recycle Valve','Purge Valve', 'Product Separator (stream 10)', 'Stripper underflow (stream 11)', 'Stripper Steam Valve', 'Reactor Cooling Water Flow', 'Condensor Cooling Water Flow']
    
    for x in valvelist1:
        if x[0] in mvs:
            print(x)
            
    controlobject.displaySuperGraph(datamatrixNC.nodummyconnection, nocontrolobject.blendedranking, datamatrix.nodummyconnection, controlobject.blendedranking, mvs, valvedict1, valvedict2, valvedict3)
    controlobject.exportToGML()
    
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
    
    datamatrixBroken2 = formatmatrix("connectionsTEcontrol.csv","controlcorrelationBROKEN2.txt",0,0,partialcorrelation=True)
    brokencontrol2 = loopranking(datamatrixBroken2.scaledforwardgain, datamatrixBroken2.scaledforwardvariablelist, datamatrixBroken2.scaledbackwardgain, datamatrixBroken2.scaledbackwardvariablelist, datamatrixBroken2.nodummyvariablelist)
    
    datamatrixBroken3 = formatmatrix("connectionsTEcontrol.csv","controlcorrelationBROKEN3.txt",0,0,partialcorrelation=True)
    brokencontrol3 = loopranking(datamatrixBroken3.scaledforwardgain, datamatrixBroken3.scaledforwardvariablelist, datamatrixBroken3.scaledbackwardgain, datamatrixBroken3.scaledbackwardvariablelist, datamatrixBroken3.nodummyvariablelist)
    
    
    [valvelist1, valvedict1] = brokencontrol1.rankDifference(controlobject.blendedranking, brokencontrol1.blendedranking)
    
    [valvelist2, valvedict2] = brokencontrol2.rankDifference(controlobject.blendedranking, brokencontrol2.blendedranking)
    
    [valvelist3, valvedict3] = brokencontrol3.rankDifference(controlobject.blendedranking, brokencontrol3.blendedranking)
    
    [out1, out2] = brokencontrol2.differenceOfDifference(valvedict1, valvedict2)
    
    mvs = ['Stream 1', 'Stream 2', 'Stream 3', 'Stream 4', 'Compressor Recycle Valve','Purge Valve', 'Product Separator (stream 10)', 'Stripper underflow (stream 11)', 'Stripper Steam Valve', 'Reactor Cooling Water Flow', 'Condensor Cooling Water Flow']
    
    for x in valvelist1:
        if x[0] in mvs:
            print(x)
            
    controlobject.displaySuperGraph(datamatrixNC.nodummyconnection, nocontrolobject.blendedranking, datamatrix.nodummyconnection, controlobject.blendedranking, mvs, valvedict1, valvedict2, valvedict3)
    controlobject.exportToGML()
    
      
     
    
