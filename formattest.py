# -*- coding: utf-8 -*-
"""
Created on Sun Apr 15 13:34:20 2012

@author: St Elmo Wilken
"""

from formatmatrices import formatmatrix
from numpy import array
from visualise import visualiseOpenLoopSystem

"""This has been altered for the sake of convenience"""
testcase = 't'
dispRGA = False
dispEigenForwardAndBackward = False
dispEigenBlend = True
dispEdgeWeight = False
dispBestControl = False

if testcase == 'a':


    """This is btest1"""
    
    test = formatmatrix("btest1.csv", "btest1ObviousConnections.txt", 3,0)
    
    test2 = visualiseOpenLoopSystem(test.nodummyvariablelist, test.nodummydiff, 2,test.scaledforwardgain, test.scaledforwardconnection, test.scaledforwardvariablelist, test.scaledbackwardgain, test.scaledbackwardconnection, test.scaledbackwardvariablelist, test.nodummygain, test.nodummyconnection, ['v3', 'v4'])
    
    
    nodepos = {test.nodummyvariablelist[0]: array([1,1]), test.nodummyvariablelist[1]: array([1,2]), test.nodummyvariablelist[2]: array([4,1]), test.nodummyvariablelist[3]: array([4,2])}
    
  
    test2.displayConnectivityAndLocalGains(test.nodummyconnection, test.nodummygain, test.nodummyvariablelist, nodepos)
    
    if dispRGA: 
        test2.displayRGA(1, nodepos)
        test2.displayRGA(2, nodepos)
        test2.displayRGAmatrix()
    
    if dispEigenForwardAndBackward:
        test2.displayEigenRankGGf(nodepos)
        test2.displayEigenRankLGf(nodepos)
        test2.displayEigenRankGGb(nodepos)
        test2.displayEigenRankLGb(nodepos)
        test2.displayEigenRankNormalForward(nodepos)
        test2.displayEigenRankNormalBackward(nodepos)
        
    if dispEigenBlend:    
        test2.displayEigenRankBlend(test.nodummyvariablelist, 0.15, nodepos)
        test2.displayEigenRankBlendGoogle(test.nodummyvariablelist, 0.15, nodepos)
        
    if dispEdgeWeight & dispEigenBlend:
        test2.displayEdgeWeights(nodepos)
    
    if dispBestControl & dispEdgeWeight & dispEigenBlend:
        test2.calculateAndDisplayBestControl(nodepositions=nodepos)        
        
    
    test2.showAll()
    test2.exportToGML()

if testcase == 'b':
    
    """This is btest2"""
    
    test = formatmatrix("btest2.csv", "btest2GreedyConnections.txt", 3,0)
    
    test2 = visualiseOpenLoopSystem(test.nodummyvariablelist, test.nodummydiff, 2,test.scaledforwardgain, test.scaledforwardconnection, test.scaledforwardvariablelist, test.scaledbackwardgain, test.scaledbackwardconnection, test.scaledbackwardvariablelist, test.nodummygain, test.nodummyconnection, ['v4','v5']) 
    
    nodepos = {'v1': array([0.5,2]), 'v2': array([0.5,1]), 'v3' : array([7,2]), 'v4': array([7,1]), 'v5' : array([10,1.5])}
    
    nodeposf = {'v1': array([0.5,2]), 'v2': array([0.5,1]), 'v3' : array([7,2]), 'v4': array([7,1]), 'v5' : array([10,1.5]), 'DV1' : array([0.5, 3]), 'DV2' : array([0.5, 0]), 'DV3' : array([7,3]), 'DV4' : array([7, 0])}
    
    nodeposb = {'v1': array([0.5,2]), 'v2': array([0.5,1]), 'v3' : array([7,2]), 'v4': array([7,1]), 'v5' : array([10,1.5]), 'DV1' : array([7,3]), 'DV2' : array([7, 0])}
    
    test2.displayConnectivityAndLocalGains(test.nodummyconnection, test.nodummygain, test.nodummyvariablelist, nodepos)
    
    if dispRGA:
        test2.displayRGA(1, nodepos)
        test2.displayRGA(2, nodepos)
        test2.displayRGAmatrix()
    
    if dispEigenForwardAndBackward:
        test2.displayEigenRankGGf(nodeposf)
        test2.displayEigenRankLGf(nodeposf)
        test2.displayEigenRankGGb(nodeposb)
        test2.displayEigenRankLGb(nodeposb)
        test2.displayEigenRankNormalForward(nodepos)
        test2.displayEigenRankNormalBackward(nodepos)
    
    if dispEigenBlend:    
        test2.displayEigenRankBlendGoogle(test.nodummyvariablelist, 0.1, nodepos)
        test2.displayEigenRankBlend(test.nodummyvariablelist,  0.1, nodepos)
    
    
    if dispEdgeWeight & dispEigenBlend:
        test2.displayEdgeWeights(nodepos)

    if dispBestControl & dispEdgeWeight & dispEigenBlend :
        test2.calculateAndDisplayBestControl(nodepositions = nodepos, permute = False, variablestocontrol = ['v4','v5'])
        
    test2.showAll()
    test2.exportToGML()
    
if testcase == 't':
    
    test = formatmatrix("connectionsTE.csv", "scaledinputs100h5.txt", 13 ,0)
    
    controlme = ['Reactor Pressure', 'Reactor Temperature','S11 F', 'S11 E ', 'S9 D', 'S6 F', 'Reactor Level','Product Sep Temp', 'Stripper Temp', 'Stream 6',  'Stream 10','S9 F' ]    
    
    test2 = visualiseOpenLoopSystem(test.nodummyvariablelist, test.nodummydiff, 12,test.scaledforwardgain, test.scaledforwardconnection, test.scaledforwardvariablelist, test.scaledbackwardgain, test.scaledbackwardconnection, test.scaledbackwardvariablelist, test.nodummygain, test.nodummyconnection, controlme) 
    
    nodepos = {'Stream 2': array([0,80]), 'Stream 3': array([0,70]), 'Stream 1': array([0,90]), 'Stream 4': array([0,0]), 'Compressor Recycle Valve': array([100,75]), 'Purge Valve': array([92,95]),'Product Separator (stream 10)': array([75,50]),'Stripper underflow (stream 11)': array([80,0]),'Stripper Steam Valve': array([77,5]),'Reactor Cooling Water Flow': array([45,50]), 'Condensor Cooling Water Flow': array([47,85]),'Agitator Speed': array([20,80]),'Stream 8': array([62,96]),'Stream 6': array([10,25]),'Reactor Pressure': array([30, 75]), 'Reactor Level': array([15,72]),'Reactor Temperature': array([20, 17]),'Stream 9': array([87, 95]),'Product Sep Temp': array([77, 78]),'Product Sep Level': array([77, 85]),'Prod Sep Press': array([85,87]),'Stream 10': array([80,50]),'Stripper Level': array([55,10]),'Stripper Press': array([55,50]),'Stream 11': array([85,0]), 'Stripper Temp': array([65,25]),'Stripper Steam Flow': array([85,10]),'Compressor Work': array([65,87]),'Reactor Cooling Water out temp': array([40,20]),'Condensor Cooling water out temp': array([45,85]),'S6 A': array([0,30]),'S6 B': array([0,25]),'S6 C': array([0,20]),'S6 D': array([0,15]),'S6 F': array([0,5]), 'S6 E': array([0,10]),'S9 A': array([100,95]),'S9 B': array([100,90]),'S9 C': array([100,85]),'S9 D': array([100,80]),'S9 E': array([100,75]),'S9 F': array([100,70]),'S9 G': array([100,65]),'S9 H': array([100,60]),'S11 D': array([100,30]),'S11 E ': array([100,25]),'S11 F': array([100,20]),'S11 G': array([100,15]),'S11 H': array([100,10])}
             
    nodeposf = None
    nodeposb = None
    
    for values in nodepos.keys():
        nodepos[values] = nodepos[values]*100

    
    test2.displayConnectivityAndLocalGains(test.nodummyconnection, test.nodummygain, test.nodummyvariablelist, nodepos)
    
    if dispRGA:
        test2.displayRGA(1, nodepos)
        test2.displayRGA(2, nodepos)
        test2.displayRGAmatrix()
    
    if dispEigenForwardAndBackward:
        test2.displayEigenRankGGf(nodeposf)
        test2.displayEigenRankLGf(nodeposf)
        test2.displayEigenRankGGb(nodeposb)
        test2.displayEigenRankLGb(nodeposb)
        test2.displayEigenRankNormalForward(nodepos)
        test2.displayEigenRankNormalBackward(nodepos)
    
    if dispEigenBlend:    
        test2.displayEigenRankBlendGoogle(test.nodummyvariablelist, 0.35, nodepos)
        test2.displayEigenRankBlend(test.nodummyvariablelist,  0.35, nodepos)
    
    
    if dispEdgeWeight & dispEigenBlend:
        test2.displayEdgeWeights(nodepos)

    if dispBestControl & dispEdgeWeight & dispEigenBlend :
        test2.calculateAndDisplayBestControl(variablestocontrol = controlme, nodepositions = nodepos)
        
    test2.showAll()
    test2.exportToGML()
    
    
    



