# -*- coding: utf-8 -*-
"""
Created on Thu Nov 16 21:43:27 2023

@author: rocpa
"""

import numpy as np 
import matplotlib.pyplot as plt 
 
# set width of bar 
barWidth = 0.25
fig = plt.subplots(figsize =(12, 8)) 
 
# set height of bar 
target = [0.2762, 0.2658, 0.1863, 0.2026, 0.0260,0.0430] 
python = [0.2648, 0.2772, 0.1900, 0.1989, 0.0337,0.0353] 
netlogo = [0.2648, 0.2772, 0.1900, 0.1989, 0.0337,0.0353] 
 
# Set position of bar on X axis 
br1 = np.arange(len(target)) 
br2 = [x + barWidth for x in br1] 
br3 = [x + barWidth for x in br2] 
 
# Make the plot
plt.bar(br1, target, color ='r', width = barWidth, 
        edgecolor ='grey', label ='Target') 
plt.bar(br2, python, color ='g', width = barWidth, 
        edgecolor ='grey', label ='fitted\nPython') 
plt.bar(br3, netlogo, color ='b', width = barWidth, 
        edgecolor ='grey', label ='fitted\nNetLogo') 
 
# Adding Xticks 
plt.xlabel('Crosscategories', fontweight ='bold', fontsize = 15) 
plt.ylabel('Percentage', fontweight ='bold', fontsize = 15) 
plt.xticks([r + barWidth for r in range(len(target))], 
        ['male<=50', 'female<=50', 'male51<=80', 'female51<=80', 'male>80', 'female>80'])
 
plt.legend()
plt.show() 
