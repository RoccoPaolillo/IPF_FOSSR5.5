# -*- coding: utf-8 -*-
"""
Created on Tue Nov 14 09:43:48 2023

@author: rocpa
"""

import numpy as np
import pandas as pd
import matplotlib
import csv
import os

# upload csv dataframe #####

# to import csv
wd = ''
os.chdir(wd)
df = pd.read_csv("original_dataset2023agegen.csv",
                 header=None, delimiter = ",")
array = df.to_numpy()    

# to filter aggregated at national level ("Italia" region)
filter_arr = []

for element in array[:,3]:
  # if the element is higher than 42, set the value to True, otherwise False:
  if element == 'Italia':
    filter_arr.append(True)
  else:
    filter_arr.append(False)

array = array[filter_arr]

# to filter out totals age

filter_arr2 = []

for element in array[:,9]:
  if element != 'Totale':
    filter_arr2.append(True)
  else:
    filter_arr2.append(False)

array = array[filter_arr2]

# to filter out totals gender
filter_arr3 = []

for element in array[:,7]:

  if element != 'Totale':
    filter_arr3.append(True)
  else:
    filter_arr3.append(False)

array = array[filter_arr3]

# to filter columns needed based on location (gender, age, observation)
array = array[:,(7,9,13)]
array[:,2] = array[:,2].astype(float) # to read observation as number (upload as csv)

# to filter subset of male population
filter_arrm = []

for element in array[:,0]:
  # if the element is higher than 42, set the value to True, otherwise False:
  if element == 'Maschi':
    filter_arrm.append(True)
  else:
    filter_arrm.append(False)

array_m = array[filter_arrm]

array_m[0:51,:]  # marginals males
array_m[51:81,:]
array_m[81:101,:]

# to filter subset of female population

filter_arrf = []

for element in array[:,0]:
  if element == 'Femmine':
    filter_arrf.append(True)
  else:
    filter_arrf.append(False)

array_f = array[filter_arrf]

array_f[0:51,:]   # marginal femals
array_f[51:81,:]
array_f[81:101,:]

# set target marginals
TGTunder50 = array_m[0:51,2].sum() + array_f[0:51,2].sum()
TGT51to80 = array_m[51:81,2].sum() + array_f[51:81,2].sum()
TGTover80 = array_m[81:101,2].sum() + array_f[81:101,2].sum()
TGTmale = array_m[0:51,2].sum() + array_m[51:81,2].sum() + array_m[81:101,2].sum()
TGTfemale = array_f[0:51,2].sum() + array_f[51:81,2].sum() + array_f[81:101,2].sum()

T = np.array([
    [array_m[0:51,2].sum(),array_f[0:51,2].sum()],
    [array_m[51:81,2].sum(),array_f[51:81,2].sum()],
    [array_m[81:101,2].sum(),array_f[81:101,2].sum()]
    ])


####### algorithm IPF computation

# artificial population (each cross-category (unknown) cell has weight 1)
# array: axis 0 row, axis 1 column, numerification starts at 0
X = np.array([
    [1,1],
    [1,1],
    [1,1]
])

u = np.array([TGTunder50, TGT51to80, TGTover80]) # row target (age)
v = np.array([TGTmale, TGTfemale]) # col target (gender)


# IPF algorithm
# run by row first then column

def ipf_update(M, u, v):
    r_sums = M.sum(axis=1) # axis 1 and shape 1 = columns. Sum on axis 1 is equal to sum of elements of the row
    N = np.array([[M[r,c] * u[r] / r_sums[r] for c in range(M.shape[1])]
                  for r in range(M.shape[0])])

    c_sums = N.sum(axis=0) # axis 0 and shape 0 = row. Sum on axis 0 is equal to sum of elements of the columns
    O = np.array([[N[r, c] * v[c] / c_sums[c] for c in range(N.shape[1])]
                  for r in range(N.shape[0])])

    d_u = np.linalg.norm(u - O.sum(axis=1), 2)   # l2-norm as validation measure (vectorial difference between target and fitter values)
    d_v = np.linalg.norm(v - O.sum(axis=0), 2)

    return O, d_u, d_v

M = X.copy() # to set the dataset to run the IPF algorithm over

# compute algorithm
for _ in range(10):
    M, d_u, d_v = ipf_update(M, u, v)
    print(f'd_u = {d_u:.5f}, d_v = {d_v:.5f}')
    if d_u <= 0.0001 and d_v <= 0.0001:          # algorithm stops if the distance below threshold
        break

M

M.sum(axis=0) # sum marginal columns
M.sum(axis=1) # sum marginal rows

M.sum() # sum total marginals

# compute percentages

def percsample(T):
    P = np.array([[T[r,c]  / T.sum() for c in range(T.shape[1])]
                  for r in range(T.shape[0])])
    return  P

# percentage fitted
Fp = percsample(M) 
Fp.sum(axis=0) # sum marginal columns
Fp.sum(axis=1) # sum marginal rows
Fp.sum()

# to add names row and columns
Fpdf = pd.DataFrame(Fp, columns=['male','female'], index=['leq50','51to80','over80']) 


# percentage target for comparison validation
Tp = percsample(T) 
Tp.sum(axis=0) # sum marginal columns
Tp.sum(axis=1) # sum marginal rows
Tp.sum()

#  output csv (names columns and rows not appearing, to adjust format encoding in excel)


Fpdf.to_csv('percent_fitted.csv',sep = ",")


# ipf code block adapted from https://datascience.oneoffcoder.com/
