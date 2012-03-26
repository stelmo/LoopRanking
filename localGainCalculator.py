# -*- coding: utf-8 -*-
"""
Created on Mon Mar 26 23:12:10 2012

@author: St Elmo Wilken
"""

#basically im trying to automate the local gain assigning mission... 
#this wont seem useful just quite yet.. but just hold on

class localgains:
    
    def __init__(self,nameofconn):
        self.createConn(nameofconn)
    
    def createConn(self,nameofconn): # assigns variable names and connection scheme
        import csv
        from numpy import array
        fromfile = csv.reader(open(nameofconn));
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
        
                        
        
        
        

    
        


