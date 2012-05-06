# -*- coding: utf-8 -*-
"""
Created on Thu May 03 15:27:58 2012

@author: St Elmo Wilken
"""

"""This file attempts to find a suitable solution to the messenger problem
given a graph which is not too dense"""

import networkx as nx
import matplotlib.pyplot as plot

G = nx.DiGraph()
G.add_edge('A', 'B', weight= -2.0)
G.add_edge('A', 'C', weight= -1.0)
G.add_edge('B', 'C', weight= -6.0)
G.add_edge('B', 'D', weight= 3.0)
G.add_edge('C', 'D', weight= 5.0)
G.add_edge('D', 'C', weight= -7.0)
G.add_edge('E', 'F', weight= 1.0)
G.add_edge('F', 'C', weight= 5.0)
G.add_edge('D', 'G', weight= -2.0)
G.add_edge('C', 'A', weight= -5.0)

nx.draw_circular(G)
plot.show()

"""The above is a prime example of the bombing out of the Bellman-Ford algorithm"""
def getAllTours(graph, startnode, endnode, path=[]):
    path = path + [startnode]
    if startnode == endnode:
        return [path]
    if startnode not in nx.nodes(graph):
        return []
    paths = []
    for node in nx.neighbors(graph, startnode):
        if node not in path:
            newpaths = getAllTours(graph, node, endnode, path)
            for newpath in newpaths:
                paths.append(newpath)
                
    return paths


def calculateMinTour(graph, inputnode, outputnode):
    listofpossibletours = getAllTours(graph, inputnode, outputnode)
    minweight = float('inf')    
    for possibility in listofpossibletours:
        pathweight = 0
        for node in range(len(possibility)-1):
            pathweight = pathweight + graph[possibility[node]][possibility[node+1]]['weight']
        if pathweight < minweight:
            minweight = pathweight
    return minweight        

print(calculateMinTour(G, 'A','E'))
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        

