# -*- coding: utf-8 -*-
"""
Created on Fri Feb 24 16:33:40 2012

@author: St Elmo Wilken
"""


#this class just needs an input gain matrix to work its magic. 

#the "gain" matrix i input here comes from that pagerank document you gave me
#I kind of started over in lieu of our conversation earlier today i.e. assume the gain matrix is given and then go from there. 
class gRanking:
    
    def __init__(self,mat,var):
        from numpy import array, where, ones
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
        
        unityEig = where(eigVal > 0.99999)[0] #checks where eigenvalue is one. need to check if largest is one (tried to do that below)
        try: 
            from rankError import rErr
            if (unityEig[0] >= 0.99999 and unityEig[0] <= 1.0): #why does this bomb out if i replace and with & ? The reason for the weird constraints is that the eigenvalue is very very close to one but not exactly one.. (Im guessing its a rounding thing)
                raise rErr('eigenvalue selected is not 1') #using my own error class but it is failing miserably
        except rErr as err:
            print('The matrix is probably not column stochastic ',err.message)
        
        self.rankArray = eigVec[:,unityEig][:,0] #cuts array into the eigenvector corrosponding to the eigenvalue above
        self.rankArray = (1/sum(self.rankArray))*self.rankArray #this is the 1 dimensional array composed of rankings (normalised)
        self.rankArray = self.rankArray.real #to take away the useless +0j part...

    def showConnectRank(self):
        try:
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
        except Exception as err: #hoping this is the general error class
            print("Something bad happened ", err)



#manual testing: this part works

#mat1 = [[0,0,1,0.5],[1.0/3,0,0,0],[1.0/3,1.0/2,0,1.0/2],[1.0/3,1.0/2,0,0]]
#mat2 = ['var1','var2','var3','var4']
#    
#testOne = gRanking(mat1,mat2)
#print(testOne.rankArray)
#testOne.showConnectRank()













