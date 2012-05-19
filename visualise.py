# -*- coding: utf-8 -*-
"""
Created on Sun Apr 15 14:52:25 2012

@author: St Elmo Wilken
"""

"""Import classes"""
from numpy import array, transpose, arange, empty, zeros
import networkx as nx
import matplotlib.pyplot as plt
from RGABristol import RGA
from gainRank import gRanking
from operator import itemgetter
from collections import Counter

class visualiseOpenLoopSystem:
    """The class name is not strictly speaking accurate as some calculations are 
    also done herein.
    This class will:
    
        1) Visualise the connectivity and local gain information
        2) Visualise the results of the RGA method
        3) Visualise the results of the eigen-vector approach method

    This class will create several graphs:
    
    G = the directed connection graph with edge attribute 'localgain'
    G1 = RGA recommended pairings using the greedy approach. edgecolour attribute
    G2 = RGA recommended pairings using max criteria. edgecolour attribute.
    LGF = Local Gain Forward (scaled) graph with node importance as node attribute 'importance'
    LGB = Local Gain Forward (scaled) graph with node importance as node attribute 'importance' 
    NFG = Normal Forward Gain (not scaled) graph with node importance as node attribute 'importance'
    NBG = Normal Backward Gain (not scaled) graph with node importance as node attribute 'importance'
    EBG = Eigen Blended Graph = Eigen approach using LGF and LGB to calculate node attribute 'importance' 
    """
    
    def __init__(self, variables, localdiff, numberofinputs, fgainmatrix, fconnectionmatrix, fvariablenames, bgainmatrix, bconnectionmatrix, bvariablenames, normalgains, normalconnections, controlvarsforRGA=None):
        """This constructor will create an RGABristol object so that you simply
        have to call the display method to see which pairings should be made.
        
        It will also create 6 different ranking systems. Note that variablenames
        is not the same as variables!! There is a formatting difference. 
        
        ASSUME: the first rows are the inputs up to numberofinputs"""
        
        self.bristol = RGA(variables, localdiff, numberofinputs, controlvarsforRGA)
        
        self.forwardgain = gRanking(self.normaliseMatrix(fgainmatrix), fvariablenames)      
        self.backwardgain = gRanking(self.normaliseMatrix(bgainmatrix), bvariablenames)
        
        self.normalforwardgain = gRanking(self.normaliseMatrix(normalgains), variables)
        self.normalbackwardgain = gRanking(self.normaliseMatrix(transpose(normalgains)), variables)
        
        self.listofinputs = variables[:numberofinputs]
        self.listofoutputs = variables[numberofinputs:]
        
    def displayConnectivityAndLocalGains(self, connectionmatrix, localgainmatrix, variablenames, nodepositiondictionary=None):
        """This method should display a graph indicating the connectivity of a
        system as well as the local gains calculated by this class. The default
        layout is circular.
        
        It specifically requires an input connection and local gain matrix
        so that you made format them before display. Be careful to make sure
        the variables are ordered correctly i.e. don't do this manually for large
        systems.
        
        It has an optional argument to specify the position of the nodes.
        This should be entered as a dictionary in the format:
        key = node : value = array([x,y])
        
        It will create a graph with an edge attribute called localgain."""
        
        [n, n] = localgainmatrix.shape        
        self.G = nx.DiGraph() #this is convenient
        localgaindict = dict()
        localgaindictformat = dict()
        for u in range(n):
            for v in range(n):
                if (connectionmatrix[u, v] == 1):
                    self.G.add_edge(variablenames[v], variablenames[u], localgain=localgainmatrix[u, v])
                    localgaindict[(variablenames[v], variablenames[u])] = localgainmatrix[u, v]
                    localgaindictformat[(variablenames[v], variablenames[u])] = round(localgainmatrix[u, v], 3)
                    
        posdict = nodepositiondictionary 
        
        if posdict == None:
            posdict = nx.circular_layout(self.G)
    
        plt.figure("Web of connectivity and local gains")
        nx.draw_networkx(self.G, pos=posdict)
        nx.draw_networkx_edge_labels(self.G, pos=posdict, edge_labels=localgaindictformat, label_pos=0.7)
        nx.draw_networkx_edges(self.G, pos=posdict, width=2.5, edge_color='k', style='solid', alpha=0.15)
        nx.draw_networkx_nodes(self.G, pos=posdict, node_color='y', node_size=450)
        plt.axis("off") 
        
    def displayRGA(self, pairingoption=2, nodepositions=None):
        """This method will display the RGA pairings.
        
        It has 2 options of pairings:
            1) pairingoption = 1 (the default) This method will display the greedy pairings
            such that each input is matched to an output exactly once and that it is done
            top down 
            2) pairingoption = 2 This displays the RGA pairs where each input is
            forced to have a paired output. This is done such that the maximum correlation
            is used per input/output pairing.
            
        It has an optional parameter to set node positions. If left out
        the default node positions will be circular. """

        if pairingoption == 1:
            pairingpattern = self.bristol.pairedvariablesGreedy
            message = "Standard RGA Pairings"
            self.G1 = nx.DiGraph()
            self.G1 = self.G.copy()
            print(pairingpattern)
            self.G1.add_edges_from(self.G1.edges(), edgecolour='k')
            self.G1.add_edges_from(pairingpattern, edgecolour='r')
            #correct up to here
            pairingtuplelist = [(row[0], row[1]) for row in pairingpattern] #what a mission to find this error
            edgecolorlist = ["r" if edge in pairingtuplelist else "k" for edge in self.G1.edges()]
        
                
            if nodepositions == None:
                nodepositions = nx.circular_layout(self.G1)
            
            plt.figure(message)            
            nx.draw_networkx(self.G1, pos=nodepositions)
            nx.draw_networkx_edges(self.G1, pos=nodepositions, width=2.5, edge_color=edgecolorlist, style='solid', alpha=0.5)
            nx.draw_networkx_nodes(self.G1, pos=nodepositions, node_color='y', node_size=450)
            plt.axis('off')
        else:
            pairingpattern = self.bristol.pairedvariablesMax
            message = "Maximum RGA Pairings"
            self.G2 = nx.DiGraph()
            self.G2 = self.G.copy()
            print(pairingpattern)
            self.G2.add_edges_from(self.G2.edges(), edgecolour='k')
            self.G2.add_edges_from(pairingpattern, edgecolour='r')
        #correct up to here
            pairingtuplelist = [(row[0], row[1]) for row in pairingpattern] #what a mission to find this error
            edgecolorlist = ["r" if edge in pairingtuplelist else "k" for edge in self.G2.edges()]
        
                
            if nodepositions == None:
                nodepositions = nx.circular_layout(self.G2)
            
            plt.figure(message)            
            nx.draw_networkx(self.G2, pos=nodepositions)
            nx.draw_networkx_edges(self.G2, pos=nodepositions, width=2.5, edge_color=edgecolorlist, style='solid', alpha=0.5)
            nx.draw_networkx_nodes(self.G2, pos=nodepositions, node_color='y', node_size=450)
            plt.axis('off')
                
    def displayRGAmatrix(self):
        """This method will display the RGA matrix in a colour block."""
        
        plt.figure("Relative Gain Array")
        [r, c] = self.bristol.bristolmatrix.shape
        
        """You want to re-order the rga matrix right here... It's the easiest way
        to make the output look better"""
        
        pairs = []
        lenofinputs = len(self.listofinputs)
        
        for ii in range(lenofinputs):
            mv = self.listofinputs[ii]
            for jj in range(lenofinputs):
                if mv in self.bristol.pairedvariablesMax[jj, :]:
                    pairs.append(self.bristol.pairedvariablesMax[jj, :])
        
        pairs = array(pairs).reshape(-1, 2)
                    
        outputs = self.bristol.vars[lenofinputs:]
        renamedoutputs = []
        tempmat = array(empty((r,c)))
        counter = 0
        for x in pairs:
            pos = outputs.index(x[0])
            tempmat[:, counter] = self.bristol.bristolmatrix[:, pos]
            renamedoutputs.append(x[0]) 
            counter += 1
#            
        """The bristol matrix should be re-arranged now"""
        plt.imshow(tempmat, cmap=plt.cm.gray_r, interpolation='nearest', extent=[0, 1, 0, 1])
        rstart = 1.0 / (2.0 * r)
        cstart = 1.0 / (2.0 * c)
        rincr = 1.0 / r
        cincr = 1.0 / c
        revinputs = []
        revinputs.extend(self.listofinputs)
        revinputs.reverse()
        plt.yticks(arange(rstart, 1, rincr), revinputs, fontsize=10)
        plt.xticks(arange(cstart, 1, cincr), renamedoutputs, rotation= -45, fontsize=10)
        
        self.map_inputs = revinputs
        self.map_outputs = renamedoutputs
        
        rowstart = (r - 1) * rincr + rstart
        for i in range(r):
            ypos = rowstart - i * rincr
            for j in range(c):
                xpos = cstart + cincr * j - 0.15 * cincr
                val = round(tempmat[i, j], 3)
                if val <= 0.5:
                    colour = 'k'
                else:
                    colour = 'w'
                plt.text(xpos, ypos, val, color=colour, fontsize=10)
   
    def showAll(self):
        """This method is called at the end of the visualisation routine so that
        the user may see the whole collection of figures for the system under
        consideration."""
        
        plt.show()
        
    def normaliseMatrix(self, inputmatrix):
        """This method normalises the absolute value of the input matrix
        in the columns i.e. all columns will sum to 1
        
        It also appears in localGainCalculator but not for long! Unless I forget
        about it..."""
        
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
    
    def displayEigenRankLGf(self, nodepos=None):
        """This method constructs a network graph showing connections and rankings
        in terms of node size going FORWARD and using the local gains. 
        
        It has an optional parameter nodepos which sets the positions of the nodes,
        if left out the node layout defaults to circular. """
        
        
        self.LGF = nx.DiGraph()
        for i in range(self.forwardgain.n):
            for j in range(self.forwardgain.n):
                if (self.forwardgain.gMatrix[i, j] != 0):
                    self.LGF.add_edge(self.forwardgain.gVariables[j], self.forwardgain.gVariables[i]) #draws the connectivity graph to visualise rankArray
         
         
        plt.figure("Node Rankings: Local Gain Forward: Scaled")
        rearrange = self.LGF.nodes()

        for node in self.LGF.nodes():
            self.LGF.add_node(node, importance=self.forwardgain.rankDict[node])
        
        nodelabels = dict((n, [n, round(self.forwardgain.rankDict[n], 3)]) for n in self.LGF.nodes())
        sizeArray = [self.forwardgain.rankDict[var] * 10000 for var in rearrange]
        
        if nodepos == None:
            nodepos = nx.circular_layout(self.LGF)        
        
        nx.draw_networkx(self.LGF, pos=nodepos , labels=nodelabels, node_size=sizeArray, node_color='y')
        nx.draw_networkx_edges(self.LGF, pos=nodepos)
        plt.axis("off")        

    def displayEigenRankLGb(self, nodepos=None):
        """This method constructs a network graph showing connections and rankings
        in terms of node size going BACKWARD and using the local gains. 
        
        It has an optional parameter nodepos which sets the positions of the nodes,
        if left out the node layout defaults to circular. """
        
        
        self.LGB = nx.DiGraph()
        for i in range(self.backwardgain.n):
            for j in range(self.backwardgain.n):
                if (self.backwardgain.gMatrix[i, j] != 0):
                    self.LGB.add_edge(self.backwardgain.gVariables[j], self.backwardgain.gVariables[i]) #draws the connectivity graph to visualise rankArray
         
         
        plt.figure("Node Rankings: Local Gain Backward: Scaled")
        rearrange = self.LGB.nodes()
        
        for node in self.LGB.nodes():
            self.LGB.add_node(node, importance=self.backwardgain.rankDict[node])
        
        nodelabels = dict((n, [n, round(self.backwardgain.rankDict[n], 3)]) for n in self.LGB.nodes())
        sizeArray = [self.backwardgain.rankDict[var] * 10000 for var in rearrange]
        
        if nodepos == None:
            nodepos = nx.circular_layout(self.LGB)        
        
        nx.draw_networkx(self.LGB, pos=nodepos , labels=nodelabels, node_size=sizeArray, node_color='y')
        nx.draw_networkx_edges(self.LGB, pos=nodepos)
        plt.axis("off")
        
    def displayEigenRankNormalForward(self, nodepos=None):
        """This method constructs a network graph showing connections and rankings
        in terms of node size going FORWARD and using the local gains. (it is not
        scaled) 
        
        It has an optional parameter nodepos which sets the positions of the nodes,
        if left out the node layout defaults to circular. """
        
        
        self.NFG = nx.DiGraph()
        for i in range(self.normalforwardgain.n):
            for j in range(self.normalforwardgain.n):
                if (self.normalforwardgain.gMatrix[i, j] != 0):
                    self.NFG.add_edge(self.normalforwardgain.gVariables[j], self.normalforwardgain.gVariables[i]) #draws the connectivity graph to visualise rankArray
         
         
        plt.figure("Node Rankings: Local Gain Forward: Normal")
        rearrange = self.NFG.nodes()
        
        for node in self.NFG.nodes():
            self.NFG.add_node(node, importance=self.normalforwardgain.rankDict[node])
        
        nodelabels = dict((n, [n, round(self.normalforwardgain.rankDict[n], 3)]) for n in self.NFG.nodes())
        sizeArray = [self.normalforwardgain.rankDict[var] * 10000 for var in rearrange]
        
        if nodepos == None:
            nodepos = nx.circular_layout(self.NFG)        
        
        nx.draw_networkx(self.NFG, pos=nodepos , labels=nodelabels, node_size=sizeArray, node_color='y')
        nx.draw_networkx_edges(self.NFG, pos=nodepos)
        plt.axis("off")        
        
    def displayEigenRankNormalBackward(self, nodepos=None):
        """This method constructs a network graph showing connections and rankings
        in terms of node size going BACKWARD and using the local gains. (it is not
        scaled) 
        
        It has an optional parameter nodepos which sets the positions of the nodes,
        if left out the node layout defaults to circular. """
        
        
        self.NBG = nx.DiGraph()
        for i in range(self.normalbackwardgain.n):
            for j in range(self.normalbackwardgain.n):
                if (self.normalbackwardgain.gMatrix[i, j] != 0):
                    self.NBG.add_edge(self.normalbackwardgain.gVariables[j], self.normalbackwardgain.gVariables[i]) #draws the connectivity graph to visualise rankArray
         
         
        plt.figure("Node Rankings: Local Gain Backward: Normal")
        rearrange = self.NBG.nodes()
        
        for node in self.NBG.nodes():
            self.NBG.add_node(node, importance=self.normalbackwardgain.rankDict[node])
        
        nodelabels = dict((n, [n, round(self.normalbackwardgain.rankDict[n], 3)]) for n in self.NBG.nodes())
        sizeArray = [self.normalbackwardgain.rankDict[var] * 10000 for var in rearrange]
        
        if nodepos == None:
            nodepos = nx.circular_layout(self.NBG)        
        
        nx.draw_networkx(self.NBG, pos=nodepos , labels=nodelabels, node_size=sizeArray, node_color='y')
        nx.draw_networkx_edges(self.NBG, pos=nodepos)
        plt.axis("off") 
        
    def displayEigenRankBlend(self, nodummyvariablelist, alpha, nodepos=None, normaliseRankings = True):
        """This method displays the blended weightings of nodes i.e. it takes
        both forward and backward rankings into account.
        
        Note that this is purely ranking i.e. the standard google rankings do
        not come into play yet.
        
        The final parameter: normaliseRankings is only there for display purposes"""
        
        self.blendedranking = dict()
        for variable in nodummyvariablelist:
            self.blendedranking[variable] = (1 - alpha) * self.forwardgain.rankDict[variable] + (alpha) * self.backwardgain.rankDict[variable]
        
        if normaliseRankings: 
            slist = sorted(self.blendedranking.iteritems(), key = itemgetter(1), reverse=True)
            numberofentries = float(len(self.blendedranking))
            self.blendedranking = dict()
            for i, v in enumerate(slist):
                self.blendedranking[v[0]] = (numberofentries-i-1)/(numberofentries-1) 
            
        
        self.EBG = nx.DiGraph()
        for i in range(self.normalforwardgain.n):
            for j in range(self.normalforwardgain.n):
                if (self.normalforwardgain.gMatrix[i, j] != 0):
                    self.EBG.add_edge(self.normalforwardgain.gVariables[j], self.normalforwardgain.gVariables[i]) #draws the connectivity graph to visualise rankArray
         
         
        plt.figure("Blended Node Rankings")
        rearrange = self.EBG.nodes()
        
        """Need to alter the blendedranking dictionary here: the initial dict contains relative imporances,
        that needs to be altered to a more "absolute" importance"""
#        tt = sorted(self.blendedranking.iteritems(), key = itemgetter(1), reverse=True)
#        numberofentries = float(len(self.blendedranking))
#        self.blendedranking = dict()
#        for i, v in enumerate(tt):
#            self.blendedranking[v[0]] = (numberofentries-i)/numberofentries
        
        for node in self.EBG.nodes():
            self.EBG.add_node(node, importance=self.blendedranking[node])
        
        nodelabels = dict((n, [n, round(self.blendedranking[n], 3)]) for n in self.EBG.nodes())
        sizeArray = [self.blendedranking[var] * 10000 for var in rearrange]
        
        if nodepos == None:
            nodepos = nx.circular_layout(self.EBG)
            
        tt = sorted(self.blendedranking.iteritems(), key = itemgetter(1), reverse=True)
        for t in tt:
            print(t)            
        
        nx.draw_networkx(self.EBG, pos=nodepos , labels=nodelabels, node_size=sizeArray, node_color='y')
        nx.draw_networkx_edges(self.EBG, pos=nodepos)
        plt.axis("off")
        

        """This method should calculate the best possible control settings i.e.
        which variables to pair with which other variables.
        The default tries to control the most important variables according to
        the ranking algorithm.
        Needs dispEigenBlend and calculateEdgeWeights. 
        
        ASSUME: You will always have as many or more controlled variables
        as manipulated variables!!!  (The the code won't work properly otherwise...) 
        
        For large systems a much more memory efficient system needs to be designed. To 
        this end the default parameter permute will ensure that you use a greedy
        approach to determine pairings unless it is set to True. This greedy approach 
        takes about 2 min in the Tennessee Eastman problem. """

    def createInteractionDict(self, focus_vars = None, alpha = 0.2):
        """This method should try to quantify the interaction a MV has on all the other CVs."""
                
        #now create the forward and backward supergraphs
        super_forward = nx.DiGraph()
        super_backward = nx.DiGraph()
        
        for i in range(self.forwardgain.n):
            for j in range(self.forwardgain.n):
                if (self.forwardgain.gMatrix[i, j] != 0):
                    super_forward.add_edge(self.forwardgain.gVariables[j], self.forwardgain.gVariables[i], weight = self.forwardgain.gMatrix[i,j])
        
        for i in range(self.backwardgain.n):
            for j in range(self.backwardgain.n):
                if self.backwardgain.gMatrix[i,j] !=0:
                    super_backward.add_edge(self.backwardgain.gVariables[j], self.backwardgain.gVariables[i], weight = self.backwardgain.gMatrix[i,j])
        
        #super graph with implied weights created...
        
        temp_graph_f = nx.DiGraph() #this will be cleared after each iteration
        temp_graph_b = nx.DiGraph()
        
        self.interaction_dict = dict()
        
        for mv in self.listofinputs:
            temp_graph_f.clear()
            temp_graph_f = super_forward.copy()#finished house-keeping
            
            temp_graph_b.clear()
            temp_graph_b = super_backward.copy()
            
            for node in temp_graph_f.nodes():
                if not nx.has_path(temp_graph_f, mv, node):
                    temp_graph_f.remove_node(node)
                if node in self.listofinputs and not mv:
                    temp_graph_f.remove_node(node)
            
            for node in temp_graph_b.nodes():
                if not nx.has_path(temp_graph_b, node, mv):
                    temp_graph_b.remove_node(node)
                if node in self.listofinputs and not mv:
                    temp_graph_b.remove_node(node)        
            #now you have the modified graph with extra mvs and their direct dependencies removed
            
            temp_gainmatrix_f = transpose(nx.to_numpy_matrix(temp_graph_f, weight = "weight"))
            temp_variables_f = temp_graph_f.nodes()
            temp_ranking_object_f = gRanking(self.normaliseMatrix(temp_gainmatrix_f), temp_variables_f)

            temp_gainmatrix_b = transpose(nx.to_numpy_matrix(temp_graph_b, weight = "weight"))
            temp_variables_b = temp_graph_b.nodes()
            temp_ranking_object_b = gRanking(self.normaliseMatrix(temp_gainmatrix_b), temp_variables_b)

            blendedranking = dict()
            
            var_list = []
            for x in temp_graph_f.nodes():
                if x in self.listofoutputs:
                    var_list.append(x)
            
            for variable in var_list:
                blendedranking[variable] = (1 - alpha) * temp_ranking_object_f.rankDict[variable] + (alpha) * temp_ranking_object_b.rankDict[variable]
        
            slist = sorted(blendedranking.iteritems(), key = itemgetter(1), reverse=True)
            numberofentries = float(len(blendedranking))
            blendedranking = dict()
            for i, v in enumerate(slist):
                blendedranking[v[0]] = (numberofentries-i-1)/(numberofentries-1) 
            # nice! now you have a ranking dicitionary of all XMEASs for each case: this works!!!
            
            self.interaction_dict[mv] = blendedranking
            
        temp_interaction_dict = dict()    
        
        if focus_vars is not None:
            for x in self.interaction_dict.iterkeys():
                return_dict = self.interaction_dict[x]
                temp_inner_dict = dict()
                for y in return_dict.iterkeys():
                    if y in focus_vars:
                        temp_inner_dict[y] = return_dict[y]
                temp_interaction_dict[x] = temp_inner_dict
            self.interaction_dict = dict()
            self.interaction_dict = temp_interaction_dict.copy()
                    
    def createInteractionGraph(self, focus_vars):
        """This method will compare everything and hopefully generate useful results"""
        
        self.relative_importance = dict()
        for mv in self.interaction_dict.iterkeys():
            inner_dict = self.interaction_dict[mv]
            temp_dict = dict()
            for cv in inner_dict.iterkeys():
                temp_dict[cv] = inner_dict[cv]/self.blendedranking[cv]
            self.relative_importance[mv] = temp_dict
        
        #***********************************************#
        #now create a numpy array of the data above!
        #ASSUME it is square!!!!
        size_of_matrix = len(self.listofinputs)
        self.eigenmatrix = zeros((size_of_matrix, size_of_matrix))
        rev_inputs = []
        rev_inputs.extend(self.map_inputs)
        rev_inputs.reverse()
        
        for row_num in range(len(self.map_inputs)):
            mv = rev_inputs[row_num]
            for col_num in range(len(self.map_outputs)):
                cv = self.map_outputs[col_num]
                
                try:
                    temp = self.relative_importance[mv][cv]
                except KeyError:
                    temp = 1.0
                self.eigenmatrix[row_num, col_num] = temp
        
        #*********************************************3
        #Aha: isolate misbehaving elements
        most_common = []
        for column_vector in transpose(self.eigenmatrix):
            temp = Counter(column_vector)
            temp = temp.most_common(1)
            most_common.append(temp[0][0])
        #now get a new "most common" normalised eigen matrix
        [i, j] = self.eigenmatrix.shape

        for x in range(i):
            for y in range(j):
                self.eigenmatrix[x, y] = self.eigenmatrix[x, y]/most_common[y]    

        #*********************************************#
        #now plot this in a similar fashion to the RGA
        
        r = size_of_matrix
        c = size_of_matrix
        plt.figure("Eigen Interactions")
        plt.imshow(self.eigenmatrix, cmap=plt.cm.gray_r, interpolation='nearest', extent=[0, 1, 0, 1])
        rstart = 1.0 / (2.0 * r)
        cstart = 1.0 / (2.0 * c)
        rincr = 1.0 / r
        cincr = 1.0 / c
        plt.yticks(arange(rstart, 1, rincr), self.map_inputs, fontsize=10)
        plt.xticks(arange(cstart, 1, cincr), self.map_outputs, rotation= -45, fontsize=10)
        
        rowstart = (r - 1) * rincr + rstart
        for i in range(r):
            ypos = rowstart - i * rincr
            for j in range(c):
                xpos = cstart + cincr * j - 0.15 * cincr
                val = round(self.eigenmatrix[i, j], 3)
                if val <= 1:
                    colour = 'k'
                else:
                    colour = 'w'
                plt.text(xpos, ypos, val, color=colour, fontsize=10)       
        
    def exportToGML(self):
        """This method serves to export all the graphs created to GML files. It detects which 
        objects have been created."""
        
        try:
            if self.G:
                print("G exists")
                nx.write_gml(self.G, "graphG.gml")
        except:
            print("G does not exist")
        
        try:
            if self.EBG:
                print("EBG exists")
                nx.write_gml(self.EBG, "graphEBG.gml")
        except:
            print("EBG does not exist")
            
        try:
            if self.EBGG:
                print("EBGG exists")
                nx.write_gml(self.EBGG, "graphEBGG.gml")
        except:
            print("EBGG does not exist")
            
        try:
            if self.F:
                print("F exists")
                nx.write_gml(self.F, "graphF.gml")
        except:
            print("F does not exist")
        
        try:
            if self.P:
                print("P exists")
                nx.write_gml(self.P, "graphP.gml")
        except:
            print("P does not exist")
            
        try:
            if self.G1:
                print("G1 exists")
                nx.write_gml(self.G1, "graphG1.gml")
        except:
            print("G1 does not exist")
            
        try:
            if self.G2:
                print("G2 exists")
                nx.write_gml(self.G2, "graphG2.gml")
        except:
            print("G2 does not exist")    
            
        try:
            if self.GGF:
                print("GGF exists")
                nx.write_gml(self.GGF, "graphGGF.gml")
        except:
            print("GGF does not exist")
            
        try:
            if self.GGB:
                print("GGB exists")
                nx.write_gml(self.GGB, "graphGGB.gml")
        except:
            print("GGB does not exist")
            
        try:
            if self.LGB:
                print("LGB exists")
                nx.write_gml(self.LGB, "graphLGB.gml")
        except:
            print("LBG does not exist")
            
        try:
            if self.LGF:
                print("LGF exists")
                nx.write_gml(self.LGF, "graphLGF.gml")
        except:
            print("LGF does not exist")
            
        try:
            if self.NFG:
                print("NFG exists")
                nx.write_gml(self.NFG, "graphNFG.gml")
        except:
            print("NFG does not exist")
            
        try:
            if self.NBG:
                print("NBG exists")
                nx.write_gml(self.NBG, "graphNBG.gml")
        except:
            print("NBG does not exist")
