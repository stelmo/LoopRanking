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
import csv
import numpy as np


class loopranking:
    """This class will:
    1) Rank the importance of nodes in a system with control
    1.a) Use the local gains to determine importance
    1.b) Use partial correlation information to determine importance
    2) Determine the change of importance when variables change
    """
    
    def __init__(self, fgainmatrix, fvariablenames, bgainmatrix, bvariablenames, nodummyvariablelist, alpha = 0.35):
        """This constructor will:
        1) create a graph with associated node importances based on local gain information
        2) create a graph with associated node importances based on partial correlation data"""
        
        self.forwardgain = gRanking(self.normaliseMatrix(fgainmatrix), fvariablenames)      
        self.backwardgain = gRanking(self.normaliseMatrix(bgainmatrix), bvariablenames)
        self.createBlendedRanking(nodummyvariablelist, alpha)
        self.variablelist = nodummyvariablelist
        
    def createBlendedRanking(self, nodummyvariablelist, alpha = 0.35):
        """This method will create a blended ranking profile of the object"""
        
        blendedranking = dict()
        for variable in nodummyvariablelist:
            blendedranking[variable] = (1 - alpha) * self.forwardgain.rankDict[variable] + (alpha) * self.backwardgain.rankDict[variable]
            
        slist = sorted(blendedranking.iteritems(), key = itemgetter(1), reverse=True)
        numberofentries = float(len(blendedranking))
        self.blendedranking = dict()
        for i, v in enumerate(slist):
            self.blendedranking[v[0]] = (numberofentries-i-1)/(numberofentries-1)
           
    def printBlendedRanking(self, mvlist = None):
        """This method will just print the blended ranking dictionary in order"""
        
        tt = sorted(self.blendedranking.iteritems(), key = itemgetter(1), reverse=True)
        for t in tt:
            if t[0] in mvlist:
                print(t)
            
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
 
    def displaySuperGraph(self, nocontrolconnectionmatrix, rankingNoControl, controlconnectionmatrix, rankingControl, mvlist, mvImportDict1, mvImportDict2, mvImportDict3):
        """This method will create a graph containing the 
        connectivity and importance of the system being displayed.
        Edge Attribute: color for control connection
        Node Attribute: node importance
        
        It's easier to just create the no control connecion matrix here...
        
        """
        
        ncG = nx.DiGraph()
        n = len(self.variablelist)
        for u in range(n):
            for v in range(n):
                if nocontrolconnectionmatrix[u,v] == 1:
                    ncG.add_edge(self.variablelist[v], self.variablelist[u])
        
        edgelistNC = ncG.edges()
        
        self.controlG = nx.DiGraph()
        
        for u in range(n):
            for v in range(n):
                if controlconnectionmatrix[u,v] == 1:
                    if (self.variablelist[v], self.variablelist[u]) in edgelistNC:
                        self.controlG.add_edge(self.variablelist[v], self.variablelist[u], controlloop = 0)
                    else:
                        self.controlG.add_edge(self.variablelist[v], self.variablelist[u], controlloop = 1)
        
        
        for node in self.controlG.nodes():
            self.controlG.add_node(node, nocontrolimportance = rankingNoControl[node] , controlimportance = rankingControl[node])
        
        for node in mvlist:
            self.controlG.add_node(node, time_1_importance = mvImportDict1[node], time_2_importance = mvImportDict2[node], time_3_importance = mvImportDict3[node], control_node = 1)
            
        for node in self.controlG.nodes():
            if node not in mvlist:
                self.controlG.add_node(node, time_1_importance = -2.0, time_2_importance = -2.0, time_3_importance = -2.0, control_node = 0)    
        
        plt.figure("The Controlled System")
        nx.draw_circular(self.controlG)
        
    def showAll(self):
        """This method will show all figures"""
        
        plt.show()
        
    def exportToGML(self):
        """This method will just export the control graphs
        to a gml file"""
        
        try:
            if self.controlG:
                print("controlG exists")
                nx.write_gml(self.controlG, "controlG.gml")
        except:
            print("controlG does not exist")
        
    def rankDifference(self, rank_initial, rank_now):
        """This method will compute the difference in node importance for a system being controlled"""
        
        difference = dict()
        for node in self.variablelist:
            difference[node] = rank_initial[node] - rank_now[node]
        
        #the maximum imporance will always be 1 as we "normalise" the rankings earlier
        slist = sorted(difference.iteritems(), key = itemgetter(1), reverse=True)
        #returning a sorted list where the biggest changers will be displayed first
        return slist, difference
    
    def differenceOfDifference(self, diff_initial, diff_now):
        """This method will compute the difference of difference (in %) of the nodes for a system being controlled.
        It does effectively the exact same thing as rankDifference but the name is used for convenience. """
        
        difference = dict()
        for node in self.variablelist:
            difference[node] = diff_now[node] - diff_initial[node]
        
        #the maximum imporance will always be 1 as we "normalise" the rankings earlier
        slist = sorted(difference.iteritems(), key = itemgetter(1), reverse=True)
        #returning a sorted list where the biggest changers will be displayed first
        return slist, difference
        
    def conciseView(self, inirank, dict1, dict2, dict3, mvlist):
        """Will display all rank data on one line concisely"""
        
        dict0 = inirank
 
        concise = dict()
        for element in mvlist:
            concise[element] = [dict1[element], dict2[element], dict3[element]]

        for compound in concise.iteritems():
            print compound






















