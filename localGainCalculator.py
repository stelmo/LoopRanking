# -*- coding: utf-8 -*-
"""
Created on Mon Mar 26 23:12:10 2012

@author: St Elmo Wilken
"""

#calculates:
    #1) non normalised local gain matrix by assuming local variables are linearly superimposed
    #2) normalises a numpy array if commanded
    #3) reads in the connection and steady state output matrix from plant model or experiments

class localgains:
    
    def __init__(self, nameofconn, nameofgains,states):
        self.createConnectionMatrix(nameofconn)
        self.createLocalChangeMatrix(nameofgains,states)
        self.createLinearLocalGainMatrix(states)  
        
    def normaliseGainMatrix(self,matrix): #the ranking algorithms expect a normalised input local gain matrix
        #this should normalise columns i.e. all columns sum to 1
        #assuming input is square
        from numpy import array, transpose
        n = int(matrix.size**0.5)

        normalisedmatrix = []
        
        for col in range(n):
            colsum = sum(matrix[:,col])
            for row in range(n):
                if (colsum!=0):
                    normalisedmatrix.append(matrix[row,col]/colsum)
                else:
                    normalisedmatrix.append(0)
                        
        normalisedmatrix = transpose(array(normalisedmatrix).reshape(n,n))
        return normalisedmatrix #works
                
    
    def createLinearLocalGainMatrix(self, states): #note: not very efficient but it works... will try to improve later if necessary
        from numpy import array, zeros, hstack
        
        self.linlocalgainmatrix = array(zeros((self.n, self.n)))  #initialise the linear local gain matrix
        #this will be slightly inefficient at the moment... its this way to be sure of the method
        self.localdiffmatrix = []        
        for row in range(self.n):
            for col in range(states-1):
                temp = self.localchangematrix[row,col] - self.localchangematrix[row,states-1]
                self.localdiffmatrix.append(temp)
        
        self.localdiffmatrix = array(self.localdiffmatrix).reshape(self.n,-1)
        #now you have all the necessary inputs i.e. delta y and delta u (all in one matrix row wise)        
        #now go in to the connection matrix and determine local gains row by row
           #*************************************works well
        for row in range(self.n):
           index = self.connectionmatrix[row,:].reshape(1,self.n) #see the next line as well... there seems to be a persistent wrapping error... this fixes it
           if (max(max(index)) > 0): #crude but it works...    
               compoundvec = self.localdiffmatrix[row,:].reshape(states-1, 1) #this basically transposes the array... for some reason i cant get it to work with tranpose()... probably a wrapping fault somewhere
               #now you need to get uvec so that you may calculate the aprox gains
               #note: rows == number of experiments       
               for position in range(self.n):
                   if index[0, position] == 1:
                       temp = self.localdiffmatrix[position,:].reshape(-1,1) # dummy variable
                       compoundvec = hstack((compoundvec,temp))
                   else:
                       pass #do nothing as the index will sort out the order of gain association
               yvec = compoundvec[:,0].reshape(-1,1)
               uvec = compoundvec[:,1:]
               import numpy as np #is the good?        
               localgains =  np.linalg.lstsq(uvec,yvec)[0].reshape(1,-1)
               tempindex = 0        
               for position in range(self.n):
                   if index[0, position] == 1:
                       self.linlocalgainmatrix[row,position] = localgains[0,tempindex]
                       tempindex = tempindex + 1
               else:
                   pass #do nothing as the index will sort out the order of gain association
           else:
               pass #everything works
        self.linlocalgainmatrix = abs(self.linlocalgainmatrix) #some gains are negative but this has no effect on the eigenvector approach but it does pose some difficulties for the normalisation routine
        
    
    def createLocalChangeMatrix(self, nameofgains,states): #NB NB NB the octave output inserts a white space before every row!!! if you use a different source file make sure it is as such or this method will either bomb out or neglect an entire column of data
        #this method should return an array of local changes   
        #the variable name are already in order due to foresight (hopefully)
        import csv
        fromfile = csv.reader(open(nameofgains),delimiter=' ')
        self.localchangematrix = []
        for line in fromfile:
            linefixed = line[1:] #to get rid of a white space preceeding every line
            for element in linefixed:
                self.localchangematrix.append(float(element))
        from numpy import array
        self.localchangematrix = array(self.localchangematrix).reshape(len(self.variables),states) #states = 13 TE => 12 input changes + 1 base case
        #reasonably sure this works well
    
    def createConnectionMatrix(self, nameofconn): # assigns variable names and connection scheme
        import csv
        from numpy import array
        fromfile = csv.reader(open(nameofconn))
        #first row: empty space, var1, var2, var3, ... varN
        #second row: var1, gain1, gain2, gain3, ... gainN
        self.variables = fromfile.next()[1:] #gets rid of that first space. Now the variables are all stored
        #now to get the connection matrix
        self.connectionmatrix = []
        for row in fromfile:
            col = row[1:] #this gets rid of the variable name on each row (its there to help create the matrix before its read in)
            for element in col:
                if element == '1':
                    self.connectionmatrix.append(1)
                else:
                    self.connectionmatrix.append(0)
        
        self.n = len(self.variables)
        self.connectionmatrix = array(self.connectionmatrix).reshape(self.n,self.n)
        #I have a strong suspicion that this works...
        
                        
        
        
        

    
        


