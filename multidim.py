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



# 2 classes demography
TGT0_50 = 3527336 #  array_m[51:81,2].sum() + array_f[51:81,2].sum()
TGT50_100 = 2805688
TGTmale = 3073047 #  array_m[0:51,2].sum() + array_m[51:81,2].sum() + array_m[81:101,2].sum()
TGTfemale = 3259977 #  array_f[0:51,2].sum() + array_f[51:81,2].sum() + array_f[81:101,2].sum()


u = np.array([TGT0_50, TGT50_100]) # row target (age)
v = np.array([TGTmale, TGTfemale]) # col target (gender)

X = np.array([
    [1,1],
    [1,1]
])

M = X.copy() # to set the dataset to run the IPF algorithm over
M

Xdem = np.array([
    [1711610,1815726],
    [1361437,1444251]
])

M = Xdem.copy() # to set the dataset to run the IPF algorithm over
M

TGT0_50HPT = 66998
TGT50_100HPT = 1126447
TGTmaleHPT = 573530
TGTfemHPT = 619915

TGT0_50HF = 2597
TGT50_100HF = 91329
TGTmaleHF = 48272
TGTfemHF = 45654


u =  np.array([TGT0_50HF,TGT50_100HF]) # row hpt <=30, hpt 30-60, hpt > 60
v = np.array([TGTmaleHPT,TGTfemHPT]) # man wiyh hpt, fem with hpt

# 3 categories demography ###
TGT0_30 =  1745215 #  array_m[51:81,2].sum() + array_f[51:81,2].sum()
TGT30_60 = 2832088
TGT60_100 = 1755721
TGTmale = 3073047 #  array_m[0:51,2].sum() + array_m[51:81,2].sum() + array_m[81:101,2].sum()
TGTfemale = 3259977 #  array_f[0:51,2].sum() + array_f[51:81,2].sum() + array_f[81:101,2].sum()


u = np.array([TGT0_30, TGT30_60,TGT60_100]) # row target (age)
v = np.array([TGTmale, TGTfemale]) # col target (gender)

X = np.array([
    [1,1],
    [1,1],
    [1,1]
])

M = X.copy() # to set the dataset to run the IPF algorithm over
M

Xdem = np.array([
    [1,1],
    [1,1],
    [1,1]
])

M = Xdem.copy() # to set the dataset to run the IPF algorithm over
M

TGT0_30M = 907152
TGT30_60M = 1393659
TGT60_100M = 772236
TGTmaleHPT = 573530
TGTmaleNOHPT = 2499517

u =  np.array([TGT0_30M,TGT30_60M,TGT60_100M]) # row hpt <=30, hpt 30-60, hpt > 60
v = np.array([TGTmaleHPT,TGTmaleNOHPT]) # man wiyh hpt, fem with hpt





# IPF algorithm
# run by row first then column

def ipf_update(M, u, v):
    r_sums = M.sum(axis=1) # axis 1 and shape 1 = columns. Sum on axis 1 is equal to sum of elements of the row
    N = np.round(np.array([[ M[r,c] * u[r] / r_sums[r] for c in range(M.shape[1])]
                  for r in range(M.shape[0])]))

    c_sums = N.sum(axis=0) # axis 0 and shape 0 = row. Sum on axis 0 is equal to sum of elements of the columns
    O = np.round(np.array([[ N[r, c] * v[c] / c_sums[c] for c in range(N.shape[1])]
                  for r in range(N.shape[0])]))

    d_u = np.linalg.norm(u - O.sum(axis=1), 2)   # l2-norm as validation measure (vectorial difference between target and fitter values)
    d_v = np.linalg.norm(v - O.sum(axis=0), 2)

    return O, d_u, d_v

M = X.copy() # to set the dataset to run the IPF algorithm over
M

M = Xdem.copy() # to set the dataset to run the IPF algorithm over
M

# compute algorithm
for _ in range(200):
    M, d_u, d_v = ipf_update(M, u, v)
    print(f'd_u = {d_u:.5f}, d_v = {d_v:.5f}')
    if d_u <= 0.00001 and d_v <= 0.00001:          # algorithm stops if the distance below threshold
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
Fp
Fp.sum(axis=0) # sum marginal columns
Fp.sum(axis=1) # sum marginal rows
Fp.sum()

# to add names row and columns
Fpdf = pd.DataFrame(Fp, columns=['male','female'], index=['leq50','over50']) 


# percentage target for comparison validation
Tp = percsample(T) 
Tp.sum(axis=0) # sum marginal columns
Tp.sum(axis=1) # sum marginal rows
Tp.sum()

#  output csv (names columns and rows not appearing, to adjust format encoding in excel)


Fpdf.to_csv('percent_fitted.csv',sep = ",")


# ipf code block adapted from https://datascience.oneoffcoder.com/
