# -*- coding: utf-8 -*-
"""
Created on Fri Feb 24 16:33:40 2012

@author: St Elmo Wilken
"""

class rErr(Exception):
    def __init__(self,message):
        self.message = message
    
    def __str__(self):
        return repr(self.message)


#the "gain" matrix i input here comes from that pagerank document you gave me
#I kind of started over in lieu of our conversation earlier today i.e. assume the gain matrix is given and then go from there. 
class gRanking:
    """ this class just needs an input gain matrix to work its magic. """
    
    def __init__(self,mat,var):
        from numpy import array, where, ones, argmax
        from numpy import linalg as linCalc
        
        #input
        self.gMatrix = array(mat) #feed in a normalised gain matrix
        self.gVariables = var #feed in ordered variables wrt gMatrix
        
        #output
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


    def showConnectRank(self):
        import networkx as nx
        import matplotlib.pyplot as plot

        rG = nx.DiGraph()

        for i in range(self.n):
            for j in range(self.n):
                if (self.gMatrix[i,j] != 0):
                    rG.add_edge(self.gVariables[j],self.gVariables[i]) #draws the connectivity graph to visualise rankArray

        sizeArray = 10000*self.rankArray #gives you a nice spread of node size for a small (less than 20 nodes) system
        #import matplotlib.colors as cp
        #colorList = cp.LinearSegmentedColormap.from_list([0.1,0.9],['r','b'],N=n,gamma=1.0)
        #I cant get the above method to work... Basically it is supposed to change the colours based on importance where more important is more red...
        nx.draw_circular(rG,node_size=sizeArray,node_color=self.rankArray)
        plot.show()


#manual testing: this part works
if __name__ == "__main__":
    mat1 = [[0,0,1,0.5],[1.0/3,0,0,0],[1.0/3,1.0/2,0,1.0/2],[1.0/3,1.0/2,0,0]]
    mat2 = ['var1','var2','var3','var4']

    testOne = gRanking(mat1,mat2)
    print(testOne.rankArray)
    testOne.showConnectRank()
