# -*- coding: utf-8 -*-
"""
Created on Sat Apr 28 20:05:12 2012

@author: St Elmo Wilken
"""
from numpy import array, transpose, zeros, hstack, random
import numpy as np
import networkx as nx
import matplotlib.pyplot as plt

mat = np.random.rand(5, 5)           # A 5-by-5 matrix of random values from 0 to 1
imagesc(mat)           # Create a colored plot of the matrix values
colormap(flipud(gray))  # Change the colormap to gray (so higher values are
                         #   black and lower values are white)

textStrings = num2str(mat[:], '%0.2f')  # Create strings from the matrix values

textStrings = strtrim(cellstr(textStrings))  # Remove any space padding
[x,y] = meshgrid(_r[1:5])  # Create x and y coordinates for the strings
# Plot the strings
hStrings = text(x[:],y[:],textStrings,
                'HorizontalAlignment','center')
midValue = mean(get(gca,'CLim'));  # Get the middle value of the color range
textColors = repmat(mat[:] > midValue,1,3) # Choose white or black for the
                                             #   text color of the strings so
                                             #   they can be easily seen over
                                             #   the background color
set(hStrings,'Color', textColors)  # Change the text colors

set(gca,'XTick',_r[1:5],                         # Change the axes tick marks
        'XTickLabel',['A','B','C','D','E'],  #   and tick labels
        'YTick',_r[1:5],
        'YTickLabel',['A','B','C','D','E'],
        'TickLength',[0, 0])
