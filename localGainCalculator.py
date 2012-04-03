# -*- coding: utf-8 -*-
"""
Created on Mon Mar 26 23:12:10 2012

@author: St Elmo Wilken
"""

class localgains:
    
    """This class calculates:
        1) imports a connection matrix scheme and implictly the ordered variable collection
        2) imports the Steady state values of all of the variables for (states) many experiments
        3) creates difference matrix where experiment value - base case value are the elements
        4) creates a local gain matrix by assuming all gains are linear combinations of the connected (locally) variables
        """
    
    def __init__(self, nameofconn, nameofgains, states):
        self.createConnectionMatrix(nameofconn)
        self.createLocalChangeMatrix(nameofgains,states)
        self.createLocalDiffmatrix(states)
        self.createLinearLocalGainMatrix(states)  
        
    """ it is important to run the constructor in this sequence """
        
    def normaliseGainMatrix(self,matrix):
        from numpy import array, transpose
        n = int(matrix.size**0.5) #assume square

        normalisedmatrix = []
        
        for col in range(n):
            colsum = sum(matrix[:,col])
            for row in range(n):
                if (colsum!=0):
                    normalisedmatrix.append(matrix[row,col]/colsum)
                else:
                    normalisedmatrix.append(0)
                        
        normalisedmatrix = transpose(array(normalisedmatrix).reshape(n,n))
        return normalisedmatrix
        
        """ this method should normalise all columns such that the sum of all elements in a column is 1.
            this is necessary as the ranking algorithm requires an input of a normalised matrix to ensure
            stochasticity. """
                
    def createLocalDiffmatrix(self, states):
        from numpy import array
        self.localdiffmatrix = []        
        for row in range(self.n):
            for col in range(states-1):
                temp = self.localchangematrix[row,col] - self.localchangematrix[row,states-1]
                self.localdiffmatrix.append(temp)
        
        self.localdiffmatrix = array(self.localdiffmatrix).reshape(self.n,-1)
        """this method calculates the changes of the inputs and measured variables from the base case
        its output is a matrix of shape total number of variables x number of experiments run
        the number of experiments run is one less than the number of columns in the data matrix"""
    
    def createLinearLocalGainMatrix(self, states):
        from numpy import array, zeros, hstack
        
        self.linlocalgainmatrix = array(zeros((self.n, self.n)))  #initialise the linear local gain matrix
        for row in range(self.n):
           index = self.connectionmatrix[row,:].reshape(1,self.n)
           if (max(max(index)) > 0): #crude but it works...    
               compoundvec = self.localdiffmatrix[row,:].reshape(states-1, 1)
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
        """this method creates a local gain matrix using the following method:
           output_change|exp1 = gain1*input_change1|exp1 + gain2*input_change2|exp1 + etc...
           output_change|exp2 = gain1*input_change1|exp2 + gain2*input_change2|exp2 + etc...
           a least squares routine is used to determine the gains which result in the smallest error.
           the connectivity is determined by the connection matrix
           
           the result is absoluted as the negative values can interfere with the normalisation routine"""
    
    def createLocalChangeMatrix(self, nameofgains, states):
        import csv
        fromfile = csv.reader(open(nameofgains),delimiter=' ')
        self.localchangematrix = []
        for line in fromfile:
            linefixed = line[1:] #to get rid of a white space preceeding every line
            for element in linefixed:
                self.localchangematrix.append(float(element))
        from numpy import array
        self.localchangematrix = array(self.localchangematrix).reshape(len(self.variables), -1)
        """this method imports the states of the variables during the different test runs (at the end time which is assumed at SS)
        octave inserts an empty space in front of every row so this program will assume this pattern for all inputs
        this program will assume the base case is the last column of data
        """
    
    def createConnectionMatrix(self, nameofconn):
        import csv
        from numpy import array
        fromfile = csv.reader(open(nameofconn))
        self.variables = fromfile.next()[1:] #gets rid of that first space. Now the variables are all stored
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

    """this method imports the connection scheme for the data. the format should be:
        empty space, var1, var2, etc... (first row)
        var1, 1 if connected 0 if not for var 1, 1 if connected 0 if not for var 2, etc...
        var2, dito, dito
        
        this method also stores the names of all the variables in the connection matrix
        it is important that the order of the variables in the connection matrix match
        those in the data matrix"""
                
                        
        
        
        

    
        


