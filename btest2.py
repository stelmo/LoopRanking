# -*- coding: utf-8 -*-
"""
Created on Sat Apr 14 18:20:28 2012

@author: St Elmo Wilken
"""

"""This system tests a 2 input 3 measured variable system"""

"""All the imports"""
from RGABristol import RGA
from gainRank import gRanking
from localGainCalculator import localgains
import networkx as nx
import matplotlib.pyplot as plt
from numpy import array, transpose


"""Test system one: pairings should be obvious"""
localdata = localgains("btest2.csv","btest2GreedyConnections.txt",3)
G = nx.DiGraph()
connectionmatrix = localdata.connectionmatrix
localgainmatrix = localdata.linlocalgainmatrix 
variablenames = localdata.variables
localgaindict = dict()
"""Displays the causality with calculated local gains"""
for u in range(localdata.n):
    for v in range(localdata.n):
        if (connectionmatrix[u,v]==1):
            G.add_edge(variablenames[v], variablenames[u])
            localgaindict[(variablenames[u],variablenames[v])] = localgainmatrix[u,v]
posdict = {variablenames[0]: array([0.5,2]), variablenames[1]: array([0.5,1]), variablenames[2]: array([7,2]), variablenames[3]: array([7,1]), variablenames[4]: array([10,1.5])} #position dictionary

plt.figure(1)
plt.subplot(311)
plt.suptitle("RGA Implementation",size='x-large')
nx.draw_networkx(G, pos=posdict)
nx.draw_networkx_edge_labels(G,pos=posdict,edge_labels=localgaindict,label_pos=0.3)
nx.draw_networkx_edges(G,pos=posdict,width=5.0,edge_color='k', style='solid',alpha=0.5)
nx.draw_networkx_nodes(G,pos=posdict, node_color='y',node_size=900)
plt.axis('off') #it refuses to plot the ylabels if the grid is off... but it looks better with the grid off...
plt.ylabel("Open Loop Local Gains")

"""Displays the Bristol Matrix"""
"""First plot will show the connections of the max in each column"""
bristol = RGA(variablenames,localdata.localdiffmatrix,2)
spam = bristol.bristolmatrix
print(spam)

G1 = nx.DiGraph()
G1 = G.copy() #this is to prevent displaying a mix of max/0.5 pairs

pairlist = []
for row in bristol.pairedvariablesMax:
    pairlist.append((row[0],row[1]))
    G1.add_edge(row[0],row[1])

edgecolorlist = []
for element in G1.edges():
    found = 0
    for pair in pairlist:
        if element==pair:
            found = 1
    if found==1:                
        edgecolorlist.append("r")
    else:
        edgecolorlist.append("k")

plt.subplot(312)
nx.draw_networkx(G1, pos=posdict)
nx.draw_networkx_edges(G1,pos=posdict,width=5.0,edge_color=edgecolorlist, style='solid',alpha=0.5)
nx.draw_networkx_nodes(G1,pos=posdict, node_color='y',node_size=900)
plt.axis('off')
plt.ylabel("Separation point = maximum value in column")

"""Second plot will show the connections if and only if the the column has an entry bigger than 0.5"""
pairlist = []
for row in bristol.pairedvariablesHalf:
    pairlist.append((row[0],row[1]))
    G.add_edge(row[0],row[1]) 



edgecolorlist = []
for element in G.edges():
    found = 0
    for pair in pairlist:
        if element==pair:
            found = 1
    if found==1:                
        edgecolorlist.append("r")
    else:
        edgecolorlist.append("k")

plt.subplot(313)
nx.draw_networkx(G, pos=posdict)
nx.draw_networkx_edges(G,pos=posdict,width=5.0,edge_color=edgecolorlist, style='solid',alpha=0.5)
nx.draw_networkx_nodes(G,pos=posdict, node_color='y',node_size=900)
plt.axis('off')
plt.ylabel("Separation point = 0.5")

plt.figure("RGA")
plt.imshow(bristol.bristolmatrix, interpolation='nearest',extent=[0,1,0,1]) #need to fix this part!!! it looks ugly
plt.axis('off')
plt.colorbar()

"""************************************************************************************************************************************"""

"""Eigenvector Approach Time"""
"""Local Gain Ranking"""

forwardgain = gRanking(localdata.normaliseGainMatrix(localgainmatrix), variablenames)
backwardgain = gRanking(localdata.normaliseGainMatrix(transpose(localgainmatrix)),variablenames)
gfgain = gRanking(localdata.normaliseGainMatrix(connectionmatrix), variablenames)
gbgain = gRanking(localdata.normaliseGainMatrix(transpose(connectionmatrix)),variablenames)

frankdict = forwardgain.rankDict
brankdict = backwardgain.rankDict

gfdict = gfgain.rankDict
gbdict = gbgain.rankDict

plt.figure("Weight")
H = nx.DiGraph()
transconnect = transpose(connectionmatrix)
weights = dict()
for u in range(localdata.n):
    for v in range(localdata.n):
        if transconnect[u,v] == 1:
            H.add_edge(variablenames[v],variablenames[u], weight = abs(frankdict[variablenames[v]]/gfdict[variablenames[v]]-brankdict[variablenames[u]]/gbdict[variablenames[u]]))
            weights[(variablenames[v],variablenames[u])] = abs(frankdict[variablenames[v]]/gfdict[variablenames[v]]-brankdict[variablenames[u]]/gbdict[variablenames[u]])

nx.draw_networkx(H,pos=posdict)
nx.draw_networkx_edge_labels(H, pos=posdict,edge_labels=weights, style='solid',alpha=0.5, width = 0.5, label_pos= 0.3)
nx.draw_networkx_nodes(G,pos=posdict, node_color='y',node_size=900)
plt.axis("off")
plt.show()
