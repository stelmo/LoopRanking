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
dispRGA = True
dispEigenForwardAndBackward = False
dispEigenBlend = True
dispEdgeWeight = True
dispBestControl = True

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
        test2.calculateAndDisplayBestControl(nodepositions = nodepos)
        
    test2.showAll()
    
if testcase == 't':
    
    test = formatmatrix("connectionsTE.csv", "scaledinputs100h5.txt", 13 ,0)
    
    controlme = ['Reactor Pressure', 'Reactor Temperature','S11 F', 'S11 E ', 'S9 D', 'S6 F', 'Reactor Level','Product Sep Temp', 'Stripper Temp', 'Stream 6',  'Stream 10','S9 F' ]    
    
    test2 = visualiseOpenLoopSystem(test.nodummyvariablelist, test.nodummydiff, 12,test.scaledforwardgain, test.scaledforwardconnection, test.scaledforwardvariablelist, test.scaledbackwardgain, test.scaledbackwardconnection, test.scaledbackwardvariablelist, test.nodummygain, test.nodummyconnection, controlme) 
    
    nodepos = None
    nodeposf = None
    nodeposb = None
    

    
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
        test2.calculateAndDisplayBestControl(variablestocontrol = None, nodepositions = nodepos)
        
    test2.showAll()
    
    
    



