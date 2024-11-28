# -*- coding: utf-8 -*-
"""
Created on Thu Nov 16 21:43:27 2023

@author: rocpa
"""

import numpy as np
import matplotlib.pyplot as plt
import json

# set width of bar
BARWIDTH = 0.25
# fig = plt.subplots(figsize =(12, 8))


def compare(target, python, netlogo, plotfile=True, dest_file=None, barWidth=BARWIDTH):
    fig = plt.subplots(figsize=(12, 8))

    size = len(target)
    # Set position of bar on X axis
    br1 = np.arange(size * 1.0)
    br2 = [x + barWidth for x in br1]
    br3 = [x + barWidth for x in br2]

    # Make the plot
    plt.bar(br1, target, color='r', width=barWidth,
            edgecolor='grey', label='Target\nIstat 2022')
    plt.bar(br2, python, color='g', width=barWidth,
            edgecolor='grey', label='fitted\nPython')
    plt.bar(br3, netlogo, color='b', width=barWidth,
            edgecolor='grey', label='fitted\nNetLogo')

    # Adding Xticks
    plt.xlabel('Crosscategories', fontweight='bold', fontsize=15)
    plt.ylabel('Percentage', fontweight='bold', fontsize=15)
    plt.xticks([r + barWidth for r in range(size)],
               ['male<=50', 'female<=50', 'male51<=80', 'female51<=80', 'male=>81', 'female=>81'])

    plt.legend()

    if plotfile:
        plt.show()

    if dest_file:
        plt.savefig(dest_file)


def generic_compare(data, plotfile=True, dest_file=None):
    fig = plt.subplots(figsize=(12, 8))

    size = len(data[0]["data"])

    num = len(data)
    barWidth = 1.0 / (num + 1)

    # Set position of bar on X axis
    # br1 = np.arange(size)
    # br2 = [x + barWidth for x in br1]
    # br3 = [x + barWidth for x in br2]
    # Make the plot

    for i in range(num):
        entry = data[i]
        bars = [(i * barWidth) + x for x in np.arange(size)]
        plt.bar(bars, entry["data"], color=entry["color"], width=barWidth,
                edgecolor='grey', label=f'Target\n{entry["label"]}')

    # plt.bar(br1, target, color ='r', width = barWidth,
    #         edgecolor ='grey', label ='Target\nIstat 2022')
    # plt.bar(br2, python, color ='g', width = barWidth,
    #         edgecolor ='grey', label ='fitted\nPython')
    # plt.bar(br3, netlogo, color ='b', width = barWidth,
    #         edgecolor ='grey', label ='fitted\nNetLogo')

    # Adding Xticks
    plt.xlabel('Crosscategories', fontweight='bold', fontsize=15)
    plt.ylabel('Percentage', fontweight='bold', fontsize=15)
    plt.xticks([r + barWidth for r in range(size)],
               ['male<=50', 'female<=50', 'male51<=80', 'female51<=80', 'male=>81', 'female=>81'])

    plt.legend()
    if plotfile:
        plt.show()

    if dest_file:
        plt.savefig(dest_file)


# set height of bar
target = [0.2762, 0.2658, 0.1863, 0.2026, 0.0260, 0.0430]
python = [0.2648, 0.2772, 0.1900, 0.1989, 0.0337, 0.0353]
netlogo = [0.2648, 0.2772, 0.1900, 0.1989, 0.0337, 0.0353]
test = [0.2772, 0.2648,  0.1989, 0.1900, 0.0337, 0.0353]


# arrays = [target, python, netlogo]
# labels = ["Istat 2022", "Python", "NetLogo"]
# colors = ['r', 'g', 'b']

arrays = [target, python, netlogo, test]
labels = ["Istat 2022", "Python", "NetLogo", "test"]
colors = ['r', 'g', 'b', 'y']

with open('data.json', 'r') as f:
    data = json.load(f)

# compare(target, python, netlogo, plotfile=False, dest_file="out.png")
generic_compare(data, plotfile=False,
                dest_file="out_generic.png")



with open('data2.json', 'r') as f:
    data2 = json.load(f)

# compare(target, python, netlogo, plotfile=False, dest_file="out.png")
generic_compare(data2, plotfile=False,
                dest_file="out_generic2.png")

