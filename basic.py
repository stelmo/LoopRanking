'''
Created on 13 May 2012

@author: St Elmo Wilken
'''
"""This script will try to show the basic idea of how the eigen-vector approach 
to ranking works"""
from gainRank import gRanking
from numpy import transpose, array
import csv
import networkx as nx
import matplotlib.pyplot as plt

"""Methods used to display the graphs etc"""

def normaliseMatrix(inputmatrix):
    """This method normalises the absolute value of the input matrix
    in the columns i.e. all columns will sum to 1"""
        
    [r, c] = inputmatrix.shape
    inputmatrix = abs(inputmatrix) #doesnt affect eigen
    normalisedmatrix = []
    
    for col in range(c):
        colsum = float(sum(inputmatrix[:, col]))
        for row in range(r):
            if (colsum != 0):
                normalisedmatrix.append(inputmatrix[row, col] / colsum) #this was broken! fixed now...
            else:
                normalisedmatrix.append(0.0)
                    
    normalisedmatrix = transpose(array(normalisedmatrix).reshape(r, c))
    return normalisedmatrix

def createConnectionMatrix(nameofconn):
    """This method imports the connection scheme for the data. 
    The format should be: 
    empty space, var1, var2, etc... (first row)
    var1, value, value, value, etc... (second row)
    var2, value, value, value, etc... (third row)
    etc...
    
    Value is 1 if column variable points to row variable (causal relationship)
    Value is 0 otherwise
    
    This method also stores the names of all the variables in the connection matrix.
    It is important that the order of the variables in the connection matrix match
    those in the data matrix"""
    
    fromfile = csv.reader(open(nameofconn))
    variables = fromfile.next()[1:] #gets rid of that first space. Now the variables are all stored
    connectionmatrix = []
    for row in fromfile:
        col = row[1:] #this gets rid of the variable name on each row (its there to help create the matrix before its read in)
        for element in col:
            if element == '1':
                connectionmatrix.append(1)
            else:
                connectionmatrix.append(0)
    
    n = len(variables)
    connectionmatrix = array(connectionmatrix).reshape(n, n)
    return connectionmatrix, variables, n

def showSystem(n, gMatrix, gVariables, rankDict, name):
    G = nx.DiGraph()
    for i in range(n):
        for j in range(n):
            if (gMatrix[i, j] != 0):
                G.add_edge(gVariables[j], gVariables[i]) 


    plt.figure("Node Rankings")
    rearrange = G.nodes()

    for node in G.nodes():
        G.add_node(node, importance=rankDict[node])

    nodelabels = dict((n, [n, round(rankDict[n], 3)]) for n in G.nodes())
    sizeArray = [rankDict[var] * 10000 for var in rearrange]


    nodepos = nx.circular_layout(G)        

    nx.draw_networkx(G, pos=nodepos , labels=nodelabels, node_size=sizeArray, node_color='y')
    nx.draw_networkx_edges(G, pos=nodepos)
    plt.axis("off")
    nx.write_gml(G, name+".gml")
    plt.show()


"""Functional part"""
showcase = True


if showcase:
    
    [prem1, var1, n1] = createConnectionMatrix("premise1.csv")
    rankings1 = gRanking(normaliseMatrix(prem1), var1)
    print(rankings1.rankDict)
    showSystem(n1, prem1, var1, rankings1.rankDict, "premise1")
    
else:
    
    [prem2, var2, n2] = createConnectionMatrix("premise2.csv")
    rankings2 = gRanking(normaliseMatrix(prem2), var2)
    showSystem(n2, prem2, var2, rankings2.rankDict, "premise2")
    





















