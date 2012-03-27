# -*- coding: utf-8 -*-
"""
Created on Mon Mar 26 23:12:10 2012

@author: St Elmo Wilken
"""

#basically im trying to automate the local gain assigning mission... 
#this wont seem useful just quite yet.. but hold on

class localgains:
    
    def __init__(self, nameofconn, nameofgains):
        self.createConn(nameofconn)
        self.createLocalChangeMatrix(nameofgains)
        
    
    def assignLocalGains(self):
        #this method should calculate average gains based on the connectivity matrix and the local change matrix
        pass
    
    def createLocalChangeMatrix(self, nameofgains):
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
        self.localchangematrix = array(self.localchangematrix).reshape(len(self.variables),13) #12 input changes + 1 base case
        #reasonably sure this works well
    
    def createConn(self, nameofconn): # assigns variable names and connection scheme
        import csv
        from numpy import array
        fromfile = csv.reader(open(nameofconn))
        #first row: empty space, var1, var2, var3, ... varN
        #second row: var1, gain1, gain2, gain3, ... gainN
        self.variables = fromfile.next()[1:] #gets rid of that first space. Now the variables are all stored
        #now to get the connection matrix
        self.connections = []
        for row in fromfile:
            col = row[1:] #this gets rid of the variable name on each row (its there to help create the matrix before its read in)
            for element in col:
                if element == '1':
                    self.connections.append(1)
                else:
                    self.connections.append(0)
        
        self.n = len(self.variables)
        self.connections = array(self.connections).reshape(self.n,self.n)
        #I have a strong suspicion that this works...
        
                        
        
        
        

    
        


