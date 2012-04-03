# -*- coding: utf-8 -*-
"""
Created on Fri Feb 24 16:33:40 2012

@author: St Elmo Wilken
"""
 
class gRanking:
    #description of the class gRanking
    """This class has two inputs:
        1) a normalised square local gain array 
        2) an array containing all the variable tags written in order of the local gain array
        
        The class calculates the rankings of the variables using the eigenvector approach (Ax = x)"""
    
    def __init__(self,mat,var):
        from numpy import array        
        self.gMatrix = array(mat) #feed in a normalised gain matrix NB: no dangling nodes!!!
        self.gVariables = var #feed in ordered variables wrt gMatrix
        self.constructRankArray()  
        self.sortRankings()

    """The constructor method creates a  """

    
    def constructRankArray(self):
        from numpy import ones, argmax
        from numpy import linalg as linCalc
        
        self.n = len(self.gMatrix) #length of gain matrix = number of nodes
        S = (1.0/self.n)*ones((self.n,self.n))
        m = 0.15
        self.M = (1-m)*self.gMatrix + m*S #basic page rank algorithm
        [eigVal, eigVec] = linCalc.eig(self.M) #calc eigenvalues, eigenvectors as usual
        
        maxeigindex = argmax(eigVal)
        self.maxeig = eigVal[maxeigindex].real # store value for downstream checking

        self.rankArray = eigVec[:,maxeigindex] #cuts array into the eigenvector corrosponding to the eigenvalue above
        self.rankArray = (1/sum(self.rankArray))*self.rankArray #this is the 1 dimensional array composed of rankings (normalised)
        self.rankArray = self.rankArray.real #to take away the useless +0j part...
                
        #create a dictionary of the rankings with their respective nodes ie {NODE:RANKING}
        self.rankDict = dict(zip(self.gVariables,self.rankArray))
        #print(self.rankDict) this works. now need to rearrange the rank sizes to corrospond to the drawing...
        
        """The method constructRankArray actually implements the eigenvector approach """
        
    def showConnectRank(self):
        import networkx as nx
        import matplotlib.pyplot as plot

        rG = nx.DiGraph()
        for i in range(self.n):
            for j in range(self.n):
                if (self.gMatrix[i,j] != 0):
                    rG.add_edge(self.gVariables[j],self.gVariables[i]) #draws the connectivity graph to visualise rankArray


        self.rearrange = rG.nodes()
        self.sizeArray = [self.rankDict[var]*10000 for var in self.rearrange]
        
        nx.draw_circular(rG,node_size = self.sizeArray)
        plot.show()
        
        """this method constructs a network graph showing connections and rankings ito node size"""

    def sortRankings(self):
        sortme = self.rankDict
        from numpy import array
        self.sortedRankings = []
        for w in sorted(sortme, key=sortme.get, reverse=True):
            self.sortedRankings.append(w)
            self.sortedRankings.append(sortme[w])
        self.sortedRankings = array(self.sortedRankings).reshape(-1, 2)
        #basically this method sorts the dictionary
        """ this method creates a matrix showing the ordered rankings"""
















