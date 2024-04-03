#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Oct 29 14:04:52 2023

@author: maazbhatti
"""

#%% Function definitions (HINT: you can move functions in a separate file to 
# keep the length of the analysis script reasonable...)
import pandas as pd

def read_file_to_df(filename):
    data = pd.read_json(filename, typ='series')
    value = []
    key = []
    totalval = 0
    for j in list(range(0, data.size)):
        if list(data[j].keys())[0] != 'points':
            key.append(list(data[j].keys())[0])
            value.append(list(data[j].items())[0][1])
            dictionary = dict(zip(key, value))
       

    if list(data[j].keys())[0] == 'points':
        try:
            start = list(list(list(data[data.size-1].items()))[0][1][0][0].items())[0][1][0]
            dictionary['start_lat'] = list(start[0].items())[0][1]
            dictionary['start_long'] = list(start[1].items())[0][1]
            dictionary['end_lat'] = list(start[0].items())[0][1]
            dictionary['end_long'] = list(start[1].items())[0][1]
        except:
            totalval = totalval+1
            
        
    df = pd.DataFrame(dictionary, index = [0])

    return df