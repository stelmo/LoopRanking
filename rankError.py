# -*- coding: utf-8 -*-
"""
Created on Fri Feb 24 16:59:46 2012

@author: St Elmo Wilken
"""

class rErr(Exception):
    def __init__(self,message):
        self.message = message
    
    def __str__(self):
        return repr(self.message)
        
        
        