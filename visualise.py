# -*- coding: utf-8 -*-
"""
Created on Sun Apr 15 14:52:25 2012

@author: St Elmo Wilken
"""

"""Import classes"""
from numpy import array, transpose, zeros, hstack
import numpy as np
import networkx as nx
import matplotlib.pyplot as plt
from RGABristol import RGA
from gainRank import gRanking


class visualiseOpenLoopSystem:
    """This class will:
        1) Visualise the connectivity and local gain information
        2) Visualise the results of the RGA method
        3)  Visualise the results of the eigen-vector approach method"""
    
    def __init__(self, variables, localdiff, numberofinputs):
        """This constructor will create an RGABristol object so that you simply
        have to call the display method to see which pairings should be made. """
        
        #self.bristol = RGA(variables, localdiff, numberofinputs)
    
    def displayConnectivityAndLocalGains(self, connectionmatrix, localgainmatrix, variablenames, nodepositiondictionary=None):
        """This method should display a graph indicating the connectivity of a
        system as well as the local gains calculated by this class. The default
        layout is spectral.
        
        It specifically requires an input connection and local gain matrix
        so that you made format them before display. Becareful to make sure
        the variables are ordered correctly i.e. don't do this manually for large
        systems.
        
        It has an optional argument to specify the position of the nodes.
        This should be entered as a dictionary in the format:
        key = node : value = array([x,y])"""
        
        [n, n] = localgainmatrix.shape        
        self.G = nx.DiGraph() #this is convenient
        localgaindict = dict()
        for u in range(n):
            for v in range(n):
                if (connectionmatrix[u,v]==1):
                    self.G.add_edge(variablenames[v], variablenames[u])
                    localgaindict[(variablenames[u],variablenames[v])] = localgainmatrix[u,v]
    
        posdict = nodepositiondictionary 
        
        if posdict == None:
            posdict = nx.spectral_layout(self.G)
    
        plt.figure("Web of connectivity and local gains")
        nx.draw_networkx(self.G, pos=posdict)
        nx.draw_networkx_edge_labels(self.G,pos=posdict,edge_labels=localgaindict,label_pos=0.3)
        nx.draw_networkx_edges(self.G,pos=posdict,width=5.0,edge_color='k', style='solid',alpha=0.5)
        nx.draw_networkx_nodes(self.G,pos=posdict, node_color='y',node_size=900)
        plt.axis("off") 
        
        
    def displayRGA(self,pairingoption = 1, nodepositions = None):
        """This method will display the RGA pairings.
        
        It has 2 options of pairings:
            1) pairingoption = 1 (the default) This displays the standard RGA
            pairings where the decision to pair is positive if the relative gain
            array has an element value of more than or equal to 0.5. 
            2) pairingoption = 2 This displays the RGA pairs where each input is
            forced to have a paired output. This is selected by using the maximum 
            value in each column as a pair.
            
        It has an optional parameter to set node positions. If left out
        the default node positions will be spectral. """
        G1 = None
        G1 = nx.DiGraph()
        G1 = self.G.copy()
        
        pairlist = []
        message = "You have erred in method selection"
        
        if (pairingoption == 1):
            pairingpattern =  self.bristol.pairedvariablesHalf
            message = "Standard RGA Pairings"
        else:
            pairingpattern =  self.bristol.pairedvariablesMax
            message = "Maximum RGA Pairings"
              
        for row in pairingpattern:
            pairlist.append((row[0],row[1]))
            G1.add_edge(row[0],row[1])
        
        edgecolorlist = []
        for element in G1.edges():
            found = 0
            for pair in pairlist:
                if element==pair:
                    found = 1
            if found==1:                
                edgecolorlist.append("r")
            else:
                edgecolorlist.append("k")
        
                
        if nodepositions == None:
            nodepositions = nx.spectral_layout(self.G)
        
        plt.figure(message)            
        nx.draw_networkx(G1, pos=nodepositions)
        nx.draw_networkx_edges(G1,pos=nodepositions,width=5.0,edge_color=edgecolorlist, style='solid',alpha=0.5)
        nx.draw_networkx_nodes(G1,pos=nodepositions, node_color='y',node_size=900)
        plt.axis('off')
        
    def displayRGAmatrix(self):
        """This method will display the RGA matrix in a colour block."""
        
        plt.figure("Relative Gain Array")
        plt.imshow(self.bristol.bristolmatrix, interpolation='nearest',extent=[0,1,0,1]) #need to fix this part!!! it looks ugly
        plt.axis('off')
        plt.colorbar()
    
    
    def showAll(self):
        """This method is called at the end of the visualisation routine so that
        the user may see the whole collection of figures for the system under
        consideration."""
        
        plt.show()
        

    def displayEigenWeights(self, connectionmatrix, gainmatrix, variablenames, localn, posdict=None):
        """This method displays the system connectivity and the calculated edge
        weights using the eigenvector approach.
        
        localn = length or height of connection or gain matrix
        posdict = position dictionary of nodes, defaults to a spectral layout
        of web. """
        
        forwardgain = gRanking(self.normaliseMatrix(gainmatrix), variablenames)
        gfgain = gRanking(self.normaliseMatrix(connectionmatrix), variablenames)        
        
        backwardgain = gRanking(self.normaliseMatrix(transpose(gainmatrix)), variablenames)
        gbgain = gRanking(self.normaliseMatrix(transpose(connectionmatrix)), variablenames)
        
        
        frankdict = forwardgain.rankDict
        brankdict = backwardgain.rankDict
        gfdict = gfgain.rankDict
        gbdict = gbgain.rankDict
        
        print(frankdict)
        print(gfdict)       
        
        
        plt.figure("Eigen-Vector Approach: Edge Weightings")
        H = nx.DiGraph()        
        weighting = dict()
        for u in range(localn):
            for v in range(localn):
                if connectionmatrix[u,v] == 1:
                    H.add_edge(variablenames[v],variablenames[u])
                    weighting[(variablenames[v],variablenames[u])] = 1# a miracle occurs

        
        if posdict == None:
            posdict = nx.spectral_layout(H)
            
        nx.draw_networkx(H,pos=posdict)
        nx.draw_networkx_edge_labels(H, pos=posdict,edge_labels=weighting, style='solid',alpha=0.5, width = 0.5, label_pos= 0.3)
        nx.draw_networkx_nodes(H,pos=posdict, node_color='y',node_size=900)
        plt.axis("off")
        
        
        
    def normaliseMatrix(self,inputmatrix):
        """This method normalises the absolute value of the input matrix
        in the columns i.e. all columns will sum to 1
        
        It also appears in localGainCalculator but not for long! Unless I forget about it..."""
        
        [r, c] = inputmatrix.shape
        inputmatrix = abs(inputmatrix) #doesnt affect eigen
        normalisedmatrix = []
        
        for col in range(c):
            colsum = float(sum(inputmatrix[:,col]))
            for row in range(r):
                if (colsum!=0):
                    normalisedmatrix.append(inputmatrix[row,col]/colsum) #this was broken! fixed now...
                else:
                    normalisedmatrix.append(0.0)
                        
        normalisedmatrix = transpose(array(normalisedmatrix).reshape(r,c))
        return normalisedmatrix       
    
        
        
        
        
        
        
        
        
        
        
        
        
        
        