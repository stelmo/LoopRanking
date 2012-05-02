# -*- coding: utf-8 -*-
"""
Created on Sun Apr 15 14:52:25 2012

@author: St Elmo Wilken
"""

"""Import classes"""
from numpy import array, transpose
import networkx as nx
import matplotlib.pyplot as plt
from RGABristol import RGA
from gainRank import gRanking
from operator import itemgetter
from itertools import permutations


class visualiseOpenLoopSystem:
    """The class name is not strictly speaking accurate as some calculations are 
    also done herein.
    This class will:
        1) Visualise the connectivity and local gain information
        2) Visualise the results of the RGA method
        3) Visualise the results of the eigen-vector approach method
        4) Calculate the edge-weights based on the algorithm
        5) Calculate and display the best pairing scheme according to the
            eigen-method"""
    
    def __init__(self, variables, localdiff, numberofinputs, fgainmatrix, fconnectionmatrix, fvariablenames, bgainmatrix, bconnectionmatrix, bvariablenames, normalgains, normalconnections, controlvarsforRGA = None):
        """This constructor will create an RGABristol object so that you simply
        have to call the display method to see which pairings should be made.
        
        It will also create 6 different ranking systems. Note that variablenames
        is not the same as variables!! There is a formatting difference. """
        
        self.bristol = RGA(variables, localdiff, numberofinputs, controlvarsforRGA)
        
        self.forwardgain = gRanking(self.normaliseMatrix(fgainmatrix), fvariablenames)
        self.gfgain = gRanking(self.normaliseMatrix(fconnectionmatrix), fvariablenames)        
        
        self.backwardgain = gRanking(self.normaliseMatrix(bgainmatrix), bvariablenames)
        self.gbgain = gRanking(self.normaliseMatrix(bconnectionmatrix), bvariablenames)
        
        self.normalforwardgain = gRanking(self.normaliseMatrix(normalgains), variables)
        self.normalbackwardgain = gRanking(self.normaliseMatrix(transpose(normalgains)), variables)
        self.normalforwardgoogle = gRanking(self.normaliseMatrix(normalconnections), variables)
        
        self.listofinputs = variables[:numberofinputs]
        self.listofoutputs = variables[numberofinputs:]
        
    
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
                    localgaindict[(variablenames[v],variablenames[u])] = localgainmatrix[u,v]
    
        posdict = nodepositiondictionary 
        
        if posdict == None:
            posdict = nx.spectral_layout(self.G)
    
        plt.figure("Web of connectivity and local gains")
        nx.draw_networkx(self.G, pos=posdict)
        nx.draw_networkx_edge_labels(self.G,pos=posdict,edge_labels=localgaindict,label_pos=0.7)
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
        
    def normaliseMatrix(self,inputmatrix):
        """This method normalises the absolute value of the input matrix
        in the columns i.e. all columns will sum to 1
        
        It also appears in localGainCalculator but not for long! Unless I forget
        about it..."""
        
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
    
    def displayEigenRankLGf(self, nodepos=None):
        """This method constructs a network graph showing connections and rankings
        in terms of node size going FORWARD and using the local gains. 
        
        It has an optional parameter nodepos which sets the positions of the nodes,
        if left out the node layout defaults to spectral. """
        
        
        rG = nx.DiGraph()
        for i in range(self.forwardgain.n):
            for j in range(self.forwardgain.n):
                if (self.forwardgain.gMatrix[i,j] != 0):
                    rG.add_edge(self.forwardgain.gVariables[j], self.forwardgain.gVariables[i]) #draws the connectivity graph to visualise rankArray
         
         
        plt.figure("Node Rankings: Local Gain Forward: Scaled")
        rearrange = rG.nodes()
        nodelabels = dict((n, [n, round(self.forwardgain.rankDict[n], 3)]) for n in rG.nodes())
        sizeArray = [self.forwardgain.rankDict[var]*10000 for var in rearrange]
        
        if nodepos==None:
            nodepos = nx.spectral_layout(rG)        
        
        nx.draw_networkx(rG, pos = nodepos , labels=nodelabels, node_size = sizeArray, node_color='y')
        nx.draw_networkx_edges(rG, pos=nodepos)
        plt.axis("off")
        #print(nx.adjacency_matrix(rG))

 
    def displayEigenRankGGf(self, nodepos=None):
        """This method constructs a network graph showing connections and rankings
        in terms of node size going FORWARD and using unity gains between all node
        i.e. the google rank. 
        
        It has an optional parameter nodepos which sets the positions of the nodes,
        if left out the node layout defaults to spectral. """
        
        
        rG = nx.DiGraph()
        for i in range(self.gfgain.n):
            for j in range(self.gfgain.n):
                if (self.gfgain.gMatrix[i,j] != 0):
                    rG.add_edge(self.gfgain.gVariables[j], self.gfgain.gVariables[i])
         
         
        plt.figure("Node Rankings: Google Gain Forward: Scaled")
        rearrange = rG.nodes()
        nodelabels = dict((n, [n, round(self.gfgain.rankDict[n], 3)]) for n in rG.nodes())
        sizeArray = [self.gfgain.rankDict[var]*10000 for var in rearrange]
        
        if nodepos==None:
            nodepos = nx.spectral_layout(rG)           
        
        nx.draw_networkx(rG, pos = nodepos , labels=nodelabels, node_size = sizeArray, node_color='y')
        nx.draw_networkx_edges(rG, pos=nodepos)
        plt.axis("off")
        #print(nx.adjacency_matrix(rG))
        

    def displayEigenRankGGb(self, nodepos=None):
        """This method constructs a network graph showing connections and rankings
        in terms of node size going BACKWARD and using unity gains between all node
        i.e. the google rank. 
        
        It has an optional parameter nodepos which sets the positions of the nodes,
        if left out the node layout defaults to spectral. """
        
        
        rG = nx.DiGraph()
        for i in range(self.gbgain.n):
            for j in range(self.gbgain.n):
                if (self.gbgain.gMatrix[i,j] != 0):
                    rG.add_edge(self.gbgain.gVariables[j], self.gbgain.gVariables[i])
         
         
        plt.figure("Node Rankings: Google Gain Backward: Scaled")
        rearrange = rG.nodes()
        nodelabels = dict((n, [n, round(self.gbgain.rankDict[n], 3)]) for n in rG.nodes())
        sizeArray = [self.gbgain.rankDict[var]*10000 for var in rearrange]
        
        if nodepos==None:
            nodepos = nx.spectral_layout(rG)           
        
        nx.draw_networkx(rG, pos = nodepos , labels=nodelabels, node_size = sizeArray, node_color='y')
        nx.draw_networkx_edges(rG, pos=nodepos)
        plt.axis("off")

    def displayEigenRankLGb(self, nodepos=None):
        """This method constructs a network graph showing connections and rankings
        in terms of node size going BACKWARD and using the local gains. 
        
        It has an optional parameter nodepos which sets the positions of the nodes,
        if left out the node layout defaults to spectral. """
        
        
        rG = nx.DiGraph()
        for i in range(self.backwardgain.n):
            for j in range(self.backwardgain.n):
                if (self.backwardgain.gMatrix[i,j] != 0):
                    rG.add_edge(self.backwardgain.gVariables[j], self.backwardgain.gVariables[i]) #draws the connectivity graph to visualise rankArray
         
         
        plt.figure("Node Rankings: Local Gain Backward: Scaled")
        rearrange = rG.nodes()
        nodelabels = dict((n, [n, round(self.backwardgain.rankDict[n], 3)]) for n in rG.nodes())
        sizeArray = [self.backwardgain.rankDict[var]*10000 for var in rearrange]
        
        if nodepos==None:
            nodepos = nx.spectral_layout(rG)        
        
        nx.draw_networkx(rG, pos = nodepos , labels=nodelabels, node_size = sizeArray, node_color='y')
        nx.draw_networkx_edges(rG, pos=nodepos)
        plt.axis("off")
        
        
    def displayEigenRankNormalForward(self, nodepos=None):
        """This method constructs a network graph showing connections and rankings
        in terms of node size going FORWARD and using the local gains. (it is not
        scaled) 
        
        It has an optional parameter nodepos which sets the positions of the nodes,
        if left out the node layout defaults to spectral. """
        
        
        rG = nx.DiGraph()
        for i in range(self.normalforwardgain.n):
            for j in range(self.normalforwardgain.n):
                if (self.normalforwardgain.gMatrix[i,j] != 0):
                    rG.add_edge(self.normalforwardgain.gVariables[j], self.normalforwardgain.gVariables[i]) #draws the connectivity graph to visualise rankArray
         
         
        plt.figure("Node Rankings: Local Gain Forward: Normal")
        rearrange = rG.nodes()
        nodelabels = dict((n, [n, round(self.normalforwardgain.rankDict[n], 3)]) for n in rG.nodes())
        sizeArray = [self.normalforwardgain.rankDict[var]*10000 for var in rearrange]
        
        if nodepos==None:
            nodepos = nx.spectral_layout(rG)        
        
        nx.draw_networkx(rG, pos = nodepos , labels=nodelabels, node_size = sizeArray, node_color='y')
        nx.draw_networkx_edges(rG, pos=nodepos)
        plt.axis("off")        
        
        
    def displayEigenRankNormalBackward(self, nodepos=None):
        """This method constructs a network graph showing connections and rankings
        in terms of node size going BACKWARD and using the local gains. (it is not
        scaled) 
        
        It has an optional parameter nodepos which sets the positions of the nodes,
        if left out the node layout defaults to spectral. """
        
        
        rG = nx.DiGraph()
        for i in range(self.normalbackwardgain.n):
            for j in range(self.normalbackwardgain.n):
                if (self.normalbackwardgain.gMatrix[i,j] != 0):
                    rG.add_edge(self.normalbackwardgain.gVariables[j], self.normalbackwardgain.gVariables[i]) #draws the connectivity graph to visualise rankArray
         
         
        plt.figure("Node Rankings: Local Gain Backward: Normal")
        rearrange = rG.nodes()
        nodelabels = dict((n, [n, round(self.normalbackwardgain.rankDict[n], 3)]) for n in rG.nodes())
        sizeArray = [self.normalbackwardgain.rankDict[var]*10000 for var in rearrange]
        
        if nodepos==None:
            nodepos = nx.spectral_layout(rG)        
        
        nx.draw_networkx(rG, pos = nodepos , labels=nodelabels, node_size = sizeArray, node_color='y')
        nx.draw_networkx_edges(rG, pos=nodepos)
        plt.axis("off") 
        
    def displayEigenRankBlend(self, nodummyvariablelist, alpha, nodepos=None):
        """This method displays the blended weightings of nodes i.e. it takes
        both forward and backward rankings into account.
        
        Note that this is purely ranking i.e. the standard google rankings do
        not come into play yet."""
        
        self.blendedranking = dict()
        for variable in nodummyvariablelist:
            self.blendedranking[variable] = (1-alpha)*self.forwardgain.rankDict[variable] + (alpha)*self.backwardgain.rankDict[variable]
            
        
        rG = nx.DiGraph()
        for i in range(self.normalforwardgain.n):
            for j in range(self.normalforwardgain.n):
                if (self.normalforwardgain.gMatrix[i,j] != 0):
                    rG.add_edge(self.normalforwardgain.gVariables[j], self.normalforwardgain.gVariables[i]) #draws the connectivity graph to visualise rankArray
         
         
        plt.figure("Blended Node Rankings")
        rearrange = rG.nodes()
        nodelabels = dict((n, [n, round(self.blendedranking[n], 3)]) for n in rG.nodes())
        sizeArray = [self.blendedranking[var]*10000 for var in rearrange]
        
        if nodepos==None:
            nodepos = nx.spectral_layout(rG)        
        
        nx.draw_networkx(rG, pos = nodepos , labels=nodelabels, node_size = sizeArray, node_color='y')
        nx.draw_networkx_edges(rG, pos=nodepos)
        plt.axis("off")         

    def displayEigenRankBlendGoogle(self, nodummyvariablelist, alpha, nodepos=None):
        """This method displays the blended weightings of nodes i.e. it takes
        both forward and backward rankings into account.
        
        Note that this is purely ranking i.e. the standard google rankings do
        not come into play yet."""
        
        self.blendedrankingGoogle = dict()
        for variable in nodummyvariablelist:
            self.blendedrankingGoogle[variable] = (1-alpha)*self.gfgain.rankDict[variable] + (alpha)*self.gbgain.rankDict[variable]
            
        
        rG = nx.DiGraph()
        for i in range(self.normalforwardgain.n):
            for j in range(self.normalforwardgain.n):
                if (self.normalforwardgain.gMatrix[i,j] != 0):
                    rG.add_edge(self.normalforwardgain.gVariables[j], self.normalforwardgain.gVariables[i]) #draws the connectivity graph to visualise rankArray
         
         
        plt.figure("Blended Node Rankings: Google")
        rearrange = rG.nodes()
        nodelabels = dict((n, [n, round(self.blendedrankingGoogle[n], 3)]) for n in rG.nodes())
        sizeArray = [self.blendedrankingGoogle[var]*10000 for var in rearrange]
        
        if nodepos==None:
            nodepos = nx.spectral_layout(rG)        
        
        nx.draw_networkx(rG, pos = nodepos , labels=nodelabels, node_size = sizeArray, node_color='y')
        nx.draw_networkx_edges(rG, pos=nodepos)
        plt.axis("off")         
        
    def displayEdgeWeights(self, nodepos=None):
        """This method will compute and store the edge weights of the ranking web.
        
        It *NEEDS* the methods displayEigenBlend and displayEigenBlendGoogle to have
        been run!"""      
                
        self.P = nx.DiGraph()
        self.edgelabels = dict()
        
        for i in range(self.normalforwardgain.n):
            for j in range(self.normalforwardgain.n):
                if (self.normalforwardgain.gMatrix[i,j] != 0):
                    temp = self.normalforwardgain.gMatrix[i,j]*self.blendedranking[self.normalforwardgain.gVariables[j]] - self.blendedrankingGoogle[self.normalforwardgain.gVariables[j]]*self.normalforwardgoogle.gMatrix[i,j]
                    
                    self.edgelabels[(self.normalforwardgain.gVariables[j],self.normalforwardgain.gVariables[i])] = -1*round(temp,3)
                    self.P.add_edge(self.normalforwardgain.gVariables[j], self.normalforwardgain.gVariables[i], weight = -1*temp)
         
        plt.figure("Edge Weight Graph")
        if nodepos==None:
            nodepos = nx.spectral_layout(self.P)        
        
        nx.draw_networkx(self.P, pos=nodepos)
        nx.draw_networkx_edge_labels(self.P,pos=nodepos,edge_labels=self.edgelabels,label_pos=0.5)
        nx.draw_networkx_edges(self.P,pos=nodepos,width=5.0,edge_color='k', style='solid',alpha=0.5)
        nx.draw_networkx_nodes(self.P,pos=nodepos, node_color='y',node_size=900)        
        plt.axis("off") 
        
    def calculateAllEdgeWeights(self):
        """This method should calculate all the edge weights from all variables
        to all inputs.
        
        This method requires dispEigenWeightsBlend etc..."""
        
        self.pathlengthsdict = dict()
        
        for inlist in self.listofinputs:
            for outlist in self.listofoutputs:
                if nx.has_path(self.P, inlist, outlist):
                    plen = nx.shortest_path_length(self.P, inlist, outlist, weight='weight')
                    self.pathlengthsdict[(inlist, outlist)] = plen
                else:
                    self.pathlengthsdict[(inlist, outlist)] = float('nan')
        print(self.pathlengthsdict)           

    def calculateBestControl(self,  numberofinputs, variablestocontrol=None):
        """This method should calculate the best possible control settings i.e.
        which variables to pair with which other variables.
        The default tries to control the most important variables according to
        the ranking algorithm.
        Needs dispEigenBlend and calculateEdgeWeights. 
        
        ISSUE: coupling: the default assumes you want to control all variables"""
        
        if variablestocontrol == None:
            #get ordered variable rankings
            orderedvariablerankings = sorted(self.blendedranking.items(), key=itemgetter(1), reverse=True)
            controlme = []
            for index in range(numberofinputs):
                controlme.append(orderedvariablerankings[index][0]) #strip tuple such that only variable remains
        else:
            controlme = variablestocontrol
        #calculate all control permutations
        
        controllers = self.listofinputs
        r = len(controllers)
        sequence = permutations(controlme, r)
        print(controlme)
        print(controllers)
         
        
        
    
        
        
        
        