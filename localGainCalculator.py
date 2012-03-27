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
    
    def createAverageLocalGainMatrix(self):
        #this method should calculate average gains based on the connectivity matrix and the local change matrix      
        self.localgainmatrix = []
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
                    self.localgainmatrix.append(tempgain/12) #remember to average it out!
                else:
                    self.localgainmatrix.append(0)
        from numpy import array
        self.localgainmatrix = array(self.localgainmatrix).reshape(self.n,self.n)
        
        def normaliseGainMatrix(self): #the ranking algorithms expect a normalised input local gain matrix
            pass
                    
    
    def createLocalChangeMatrix(self, nameofgains,states):
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
        self.localchangematrix = array(self.localchangematrix).reshape(len(self.variables),states) #states = 12 input changes + 1 base case
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
        
                        
        
        
        

    
        


