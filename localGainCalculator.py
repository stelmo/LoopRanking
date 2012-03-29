# -*- coding: utf-8 -*-
"""
Created on Mon Mar 26 23:12:10 2012

@author: St Elmo Wilken
"""

#basically im trying to automate the local gain assigning mission... 
#this wont seem useful just quite yet.. but hold on

class localgains:
    
    def __init__(self, nameofconn, nameofgains,states):
        self.createConnectionMatrix(nameofconn)
        self.createLocalChangeMatrix(nameofgains,states)
        self.createAverageLocalGainMatrix()
        self.createLinearLocalGainMatrix(states)
    
    def createAverageLocalGainMatrix(self): #this is not going to be used linear combination idea supercedes it
        #this method should calculate average gains based on the connectivity matrix and the local change matrix      
        self.avelocalgainmatrix = [] #initialise the average local gain matrix
        for row in range(self.n):
            for col in range(self.n):
                if self.connectionmatrix[row,col] == 1: #local gain = top/bottom where top is output change and bottom is input change
                    bottomrow = self.localchangematrix[col,:] #this is the input row with base at the end (13 elements for TE)
                    toprow = self.localchangematrix[row,:] #this is the output row with base at the end (13 elements for TE)    
                    tempgain = 0 #dummy variable, needs to be reinitialised each time
                    endofrow = len(bottomrow)-1 #this works out: dont change me
                    for index in range(endofrow): #iterate through top/bottomrow except last element (base case)
                        topdiff = toprow[index] - toprow[endofrow] #output change
                        bottomdiff = bottomrow[index] - bottomrow[endofrow] #input change
                        if (bottomdiff!=0): #if no input change: this stops infinite gains
                            indextempgain = topdiff/bottomdiff
                        else: #if the input didn't change then the variable is being affect by something else
                            indextempgain = 0
                        tempgain = tempgain + abs(indextempgain) #is this absolute good? bad? what to do about gains cancelling each other?
                    self.avelocalgainmatrix.append(tempgain/endofrow) #remember to average it out! endofrow == number of runs
                else:
                    self.avelocalgainmatrix.append(0)
        from numpy import array
        self.avelocalgainmatrix = array(self.avelocalgainmatrix).reshape(self.n,self.n)
        
        
    def normaliseGainMatrix(self): #the ranking algorithms expect a normalised input local gain matrix
        pass
    
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
        
                        
        
        
        

    
        


