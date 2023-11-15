# -*- coding: utf-8 -*-
"""
Created on Tue Nov 14 09:43:48 2023

@author: rocpa
"""

import numpy as np
import pandas as pd
import matplotlib
import csv

# with open('C:/Users/rocpa/OneDrive/Desktop/ROME_CNR/WP5/WP5_FOSSR-main/WP5_FOSSR-main/testcsv.csv', newline='') as csvfile:
#    spamreader = csv.reader(csvfile, delimiter=';', quotechar='|')
#    for row in spamreader:
#        print(', '.join(row))


with open('C:/Users/rocpa/OneDrive/Desktop/ROME_CNR/WP5/WP5_FOSSR-main/WP5_FOSSR-main/testcsv.csv', newline='') as csvfile:
    spamreader = csv.reader(csvfile, delimiter=';', quotechar='|')
    for row in spamreader:
        print(', '.join(row))

np.loadtxt('C:/Users/rocpa/OneDrive/Desktop/ROME_CNR/WP5/WP5_FOSSR-main/WP5_FOSSR-main/test1.csv',delimiter = ";",skiprows = 1)


with open('C:/Users/rocpa/OneDrive/Desktop/ROME_CNR/WP5/WP5_FOSSR-main/WP5_FOSSR-main/test1.csv') as f:
    spamreader = csv.reader(f, delimiter=';')
    reader = csv.reader(f)
    lst = list(reader)
    print(lst)
    
array = np.array(lst)
print(array)    
    
df = pd.read_csv('C:/Users/rocpa/OneDrive/Desktop/ROME_CNR/WP5/WP5_FOSSR-main/WP5_FOSSR-main/original_dataset2023agegen.csv',
                 header=None, delimiter = ",")
array = df.to_numpy()    

filter_arr = []

for element in array[:,3]:
  # if the element is higher than 42, set the value to True, otherwise False:
  if element == 'Italia':
    filter_arr.append(True)
  else:
    filter_arr.append(False)

array = array[filter_arr]

filter_arr2 = []

for element in array[:,9]:
  # if the element is higher than 42, set the value to True, otherwise False:
  if element != 'Totale':
    filter_arr2.append(True)
  else:
    filter_arr2.append(False)

array = array[filter_arr2]

filter_arr3 = []

for element in array[:,7]:
  # if the element is higher than 42, set the value to True, otherwise False:
  if element != 'Totale':
    filter_arr3.append(True)
  else:
    filter_arr3.append(False)

array = array[filter_arr3]

array = array[:,(7,9,13)]
array[:,2] = array[:,2].astype(float)

filter_arrm = []

for element in array[:,0]:
  # if the element is higher than 42, set the value to True, otherwise False:
  if element == 'Maschi':
    filter_arrm.append(True)
  else:
    filter_arrm.append(False)

array_m = array[filter_arrm]

array_m[0:51,:]
array_m[51:81,:]
array_m[81:101,:]

filter_arrf = []

for element in array[:,0]:
  # if the element is higher than 42, set the value to True, otherwise False:
  if element == 'Femmine':
    filter_arrf.append(True)
  else:
    filter_arrf.append(False)

array_f = array[filter_arrf]

array_f[0:51,:]
array_f[51:81,:]
array_f[81:101,:]


TGTunder50 = array_m[0:51,2].sum() + array_f[0:51,2].sum()
TGT51to80 = array_m[51:81,2].sum() + array_f[51:81,2].sum()
TGTover80 = array_m[81:101,2].sum() + array_f[81:101,2].sum()
TGTmale = array_m[0:51,2].sum() + array_m[51:81,2].sum() + array_m[81:101,2].sum()
TGTfemale = array_f[0:51,2].sum() + array_f[51:81,2].sum() + array_f[81:101,2].sum()


# array: axis 0 row, axis 1 column, numerification starts at 0
 
X = np.array([
    [1,1],
    [1,1],
    [1,1]
])

u = np.array([TGTunder50, TGT51to80, TGTover80]) # row target
v = np.array([TGTmale, TGTfemale]) # col target

# row
print(f'observed: {X.sum(axis=1)}')
print(f'target: {u}')

# columns
print(f'observed: {X.sum(axis=0)}')
print(f'target: {v}')

def ipf_update(M, u, v):
    r_sums = M.sum(axis=1)
    N = np.array([[M[r,c] * u[r] / r_sums[r] for c in range(M.shape[1])]
                  for r in range(M.shape[0])])

    c_sums = N.sum(axis=0)
    O = np.array([[N[r, c] * v[c] / c_sums[c] for c in range(N.shape[1])]
                  for r in range(N.shape[0])])

    d_u = np.linalg.norm(u - O.sum(axis=1), 2)
    d_v = np.linalg.norm(v - O.sum(axis=0), 2)

    return O, d_u, d_v

M = X.copy()

for _ in range(10):
    M, d_u, d_v = ipf_update(M, u, v)
    print(f'd_u = {d_u:.5f}, d_v = {d_v:.5f}')
    if d_u <= 0.0001 and d_v <= 0.0001:
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

N = percsample(M)
N.sum(axis=0) # sum marginal columns
N.sum(axis=1) # sum marginal rows
N.sum()



