extensions [csv]
globals[
  MALEunder50init FEMunder50init MALE50to80init FEM50to80init MALEover80init FEMover80init ; initial random values of sample
  MALEunder50 FEMunder50 MALE50to80 FEM50to80 MALEover80 FEMover80              ; fitted values of sample. Repeated just to keep record of initial values
  w_MALEunder50 w_FEMunder50 w_MALE50to80 w_FEM50to80 w_MALEover80 w_FEMover80  ; weights for each category
  under50  ; marginals age < 50
  from50to80 ; marginals age 50 to 80
  over80  ; marginals age over 80
  male ; marginals male
  female  ; marginals females
  TAE ; Total Absolute Error
  TGTjoinISTAT
  TGTageISTAT
  TGTgenderISTAT
]

to sample_extraction
  clear-all
  reset-ticks
  ifelse seed_comparison? [random-seed 52682][]
set MALEunder50init 1   ; initial values sample
set FEMunder50init 1
set MALE50to80init 1
set FEM50to80init  1
set MALEover80init  1
set FEMover80init 1

  set MALEunder50 MALEunder50init  ; Repeated just to keep record of initial values
set FEMunder50 FEMunder50init
set MALE50to80 MALE50to80init
set FEM50to80 FEM50to80init
set MALEover80 MALEover80init
set FEMover80  FEMover80init

sumFITmarginals
end

to update_weights
  while [TAE != 0] [
repeat 1 [
fitting_rows           ; the algorithm of IPF: until TAE is 0, the weights are calibrated for each iteration. Each iteration includes update by row and update by column
 fitting_columns
 output-print  word "under50: " under50 output-print word "from50to80: " from50to80 output-print word "over80: " over80 ; to report the values in each iteration (after columns also updated)
  output-print word "male: " male output-print word "female: " female output-print "iteration completed----\\"
  ]]
  update-plots
end



to fitting_rows

  set MALEunder50 (MALEunder50 * (TGTunder50 / under50))   ; fitting for columns: the value in the cell is multiplied by weights at that iteration
  set FEMunder50 (FEMunder50 * (TGTunder50 / under50))     ; weight = target marginal / fitted marginal
  set MALE50to80 (MALE50to80 * (TGT50to80 / from50to80))
  set FEM50to80 (FEM50to80 * (TGT50to80 / from50to80))
  set MALEover80 (MALEover80 * (TGTover80 / over80))
  set FEMover80 (FEMover80 * (TGTover80 / over80))

 sumFITmarginals     ; marginals are updated (at each step: rows will fit target, columns not)
 update-plots
end

to fitting_columns

  set MALEunder50 (MALEunder50 * (TGTmale / male))        ; fitting for columns (as above)
  set FEMunder50 (FEMunder50 * (TGTfemale / female))
  set MALE50to80 (MALE50to80 * (TGTmale / male))
  set FEM50to80 (FEM50to80 * (TGTfemale / female))
  set MALEover80 (MALEover80 * (TGTmale / male))
  set FEMover80 (FEMover80 * (TGTfemale / female))

 sumFITmarginals   ; marginals are updated (at each step: columns will fit target, columns not)
  update-plots

end

to sumFITmarginals
set under50  precision  (MALEunder50 + FEMunder50) 5
  set from50to80 precision (MALE50to80 + FEM50to80) 5
  set over80 precision ( MALEover80 +  FEMover80) 5
  set male precision (MALEunder50 + MALE50to80 +  MALEover80) 5
  set female precision (FEMunder50 + FEM50to80 + FEMover80) 5
  set TAE abs((TGTunder50 - under50) + (TGT50to80 - from50to80) + (TGTover80 - over80) + (TGTmale - male) + (TGTfemale - female))

set w_MALEunder50 (MALEunder50 / MALEunder50init) ; update weights
set w_FEMunder50 (FEMunder50 / FEMunder50init)
set w_MALE50to80 (MALE50to80 / MALE50to80init)
set w_FEM50to80 (FEM50to80 / FEM50to80init)
set w_MALEover80 (MALEover80 / MALEover80init)
set w_FEMover80 (FEMover80 / FEMover80init)

  end
@#$#@#$#@
GRAPHICS-WINDOW
1412
524
1477
590
-1
-1
1.73
1
10
1
1
1
0
1
1
1
-16
16
-16
16
1
1
1
ticks
30.0

BUTTON
57
41
184
74
sample_extraction
sample_extraction\nsetup-plots
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
622
106
701
166
TGTunder50
3.189828E7
1
0
Number

INPUTBOX
624
174
700
234
TGT50to80
2.288711E7
1
0
Number

INPUTBOX
308
378
392
438
TGTmale
2.8749359E7
1
0
Number

INPUTBOX
395
379
485
439
TGTfemale
3.0101358E7
1
0
Number

INPUTBOX
621
239
700
299
TGTover80
4065327.0
1
0
Number

TEXTBOX
710
193
737
211
AGE
13
0.0
1

TEXTBOX
473
453
535
471
GENDER
13
0.0
1

BUTTON
31
519
145
552
fitting_rows
fitting_rows\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
303
113
394
158
MALEunder50
MALEunder50
5
1
11

MONITOR
507
125
601
170
FITTEDunder50
under50
5
1
11

MONITOR
398
112
483
157
FEMunder50
FEMunder50
5
1
11

MONITOR
304
162
389
207
MALE50to80
MALE50to80
5
1
11

MONITOR
395
162
485
207
FEM50to80
FEM50to80
5
1
11

MONITOR
506
178
602
223
FITTED50to80
from50to80
5
1
11

MONITOR
303
216
388
261
MALEover80
MALEover80
5
1
11

MONITOR
393
216
482
261
FEMover80
FEMover80
5
1
11

MONITOR
504
228
599
273
FITTEDover80
over80
5
1
11

MONITOR
305
303
388
348
FITTEDmale
male
5
1
11

MONITOR
395
302
485
347
FITTEDfemale
female
5
1
11

BUTTON
193
517
304
550
fitting_columns
fitting_columns\n  
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
609
406
687
451
TAE
TAE
5
1
11

BUTTON
490
515
604
548
update_weights
update_weights
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
633
303
707
348
sumcol
TGTunder50 + TGT50to80 + TGTover80
17
1
11

MONITOR
493
387
569
432
sumrow
TGTmale + TGTfemale
17
1
11

MONITOR
13
125
98
170
MALEunder50
MALEunder50init
5
1
11

MONITOR
105
126
190
171
FEMunder50
FEMunder50init
5
1
11

MONITOR
15
175
99
220
MALE50to80
MALE50to80init
5
1
11

MONITOR
106
174
191
219
FEM50to80
FEM50to80init
5
1
11

MONITOR
14
222
99
267
MALEover80
MALEover80init
5
1
11

MONITOR
106
222
192
267
FEMover80
FEMover80init
5
1
11

MONITOR
16
322
108
367
MALEunder50
w_MALEunder50
5
1
11

MONITOR
109
321
202
366
FEMunder50
w_FEMunder50
5
1
11

MONITOR
14
370
107
415
MALE50to80
w_MALE50to80
5
1
11

MONITOR
112
370
202
415
FEM50to80
w_FEM50to80
5
1
11

MONITOR
11
416
107
461
MALEover80
w_MALEover80
5
1
11

MONITOR
111
417
202
462
FEMover80
w_FEMover80
5
1
11

SWITCH
103
571
249
604
seed_comparison?
seed_comparison?
1
1
-1000

PLOT
985
11
1148
131
NIL
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "plot MALEunder50 / (male + female)" "plot MALEunder50 / (male + female)"

PLOT
985
137
1150
257
NIL
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "plot FEMunder50 / (male + female)" "plot FEMunder50 / (male + female)"

PLOT
1157
10
1319
130
NIL
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "plot MALE50to80 / (male + female)" "plot MALE50to80 / (male + female)"

PLOT
1156
135
1323
256
NIL
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "plot FEM50to80 / (male + female)" "plot FEM50to80 / (male + female)"

PLOT
1327
10
1492
130
NIL
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "plot MALEover80 / (male + female)" "plot MALEover80 / (male + female)"

PLOT
1328
138
1493
258
NIL
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "plot FEMover80 / (male + female)" "plot FEMover80 / (male + female)"

TEXTBOX
40
298
190
316
Weights to each category
12
0.0
1

TEXTBOX
52
102
153
120
Original sample
12
0.0
1

TEXTBOX
387
518
482
547
COMPILE IPF\nuntil convergence
12
0.0
1

TEXTBOX
93
485
243
511
alternative to update weights: check each iteration
10
0.0
1

TEXTBOX
158
527
187
559
-->
12
0.0
1

TEXTBOX
114
551
208
569
↑____________|
12
0.0
1

TEXTBOX
587
388
707
410
Total Absolute Error
13
0.0
1

TEXTBOX
575
10
742
41
Include values for the target population (sumcol == sumrow!)\n
11
0.0
1

TEXTBOX
349
86
423
104
fitted values
13
0.0
1

TEXTBOX
506
102
601
120
fitted marginals
13
0.0
1

TEXTBOX
618
69
731
99
target marginals\n(known population)
12
0.0
1

TEXTBOX
605
65
626
357
I\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI
12
0.0
1

TEXTBOX
322
353
609
371
— — — — — — — — — — — — — — — — — — — 
12
0.0
1

TEXTBOX
495
71
510
289
I\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI
10
0.0
1

TEXTBOX
301
285
578
307
— — — — — — — — — — — — — — — — — — — 
9
0.0
1

OUTPUT
756
29
966
377
10

TEXTBOX
814
10
964
28
Update iterations
12
0.0
1

TEXTBOX
208
377
294
454
Include values for the target population (sumcol == sumrow!)
11
0.0
1

TEXTBOX
283
390
307
419
►
24
0.0
1

TEXTBOX
29
43
53
72
►
24
0.0
1

TEXTBOX
647
47
673
76
▼
24
0.0
1

TEXTBOX
484
477
529
506
▼
24
0.0
1

MONITOR
1058
10
1148
55
%MALEunder50
MALEunder50 / (male + female)
5
1
11

MONITOR
1065
136
1150
181
%FEMunder50
FEMunder50 / (male + female)
5
1
11

MONITOR
1221
11
1319
56
%MALE50to80
MALE50to80 / (male + female)
5
1
11

MONITOR
1232
135
1322
180
%FEM50to80
FEM50to80 / (male + female)
5
1
11

MONITOR
1395
10
1492
55
%MALEover80
MALEover80 / (male + female)
5
1
11

MONITOR
1405
138
1494
183
%FEMover80
FEMover80 / (male + female)
5
1
11

MONITOR
1412
342
1498
387
%TGTunder50
TGTunder50 / (TGTunder50 + TGT50to80 + TGTover80)
5
1
11

MONITOR
1413
391
1497
436
%TGT50to80
TGT50to80 / (TGTunder50 + TGT50to80 + TGTover80)
5
1
11

MONITOR
1416
438
1497
483
%TGTover80
TGTover80 / (TGTunder50 + TGT50to80 + TGTover80)
5
1
11

MONITOR
1069
548
1158
593
%TGTmale
TGTmale /  (TGTmale + TGTfemale)
5
1
11

MONITOR
1169
547
1252
592
%TGTfemale
TGTfemale / (TGTmale + TGTfemale)
5
1
11

MONITOR
1064
343
1154
388
%MALEunder50
MALEunder50 / (male + female)
5
1
11

MONITOR
1063
390
1153
435
%MALE50to80
MALE50to80 / (male + female)
5
1
11

MONITOR
1063
435
1153
480
%MALEover80
MALEover80 / (male + female)
5
1
11

MONITOR
1162
342
1247
387
%FEMunder50
FEMunder50 / (male + female)
5
1
11

MONITOR
1163
389
1247
434
%FEM50to80
FEM50to80 / (male + female)
5
1
11

MONITOR
1164
435
1245
480
%FEMover80
FEMover80 / (male + female)
5
1
11

TEXTBOX
1019
313
1284
331
>>>> shown as percentage <<<<
15
0.0
1

TEXTBOX
1261
339
1276
479
I\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI
10
0.0
1

TEXTBOX
1048
477
1275
495
— — — — — — — — — — — — — — — — — — — — — — 
10
0.0
1

TEXTBOX
1008
361
1058
411
synthetic population
10
0.0
1

TEXTBOX
1417
322
1500
340
target marginals
10
0.0
1

TEXTBOX
1391
337
1406
534
I\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI\nI
10
0.0
1

TEXTBOX
1048
535
1425
553
— — — — — — — — — — — — — — — — — — — — — — — — — — —
10
0.0
1

MONITOR
1274
344
1377
389
%FITTEDunder50
under50 / (\nMALEunder50 + FEMunder50 + MALE50to80 + FEM50to80 + MALEover80 + FEMover80)
5
1
11

MONITOR
1273
392
1377
437
%FITTED50to80
from50to80 / (\nMALEunder50 + FEMunder50 + MALE50to80 + FEM50to80 + MALEover80 + FEMover80)
5
1
11

MONITOR
1272
438
1383
483
%FITTEDover80
over80 / (\nMALEunder50 + FEMunder50 + MALE50to80 + FEM50to80 + MALEover80 + FEMover80)
5
1
11

MONITOR
1065
494
1156
539
%FITTEDmale
male / (\nMALEunder50 + FEMunder50 + MALE50to80 + FEM50to80 + MALEover80 + FEMover80)
5
1
11

MONITOR
1164
491
1257
536
%FITTEDfemale
female / (\nMALEunder50 + FEMunder50 + MALE50to80 + FEM50to80 + MALEover80 + FEMover80)
5
1
11

TEXTBOX
1290
322
1366
340
fitted marginals
10
0.0
1

MONITOR
747
490
827
535
TGTmale<50
16254113 / 58850717
5
1
11

MONITOR
916
486
992
531
TGTmale>80
1532990 / 58850717
5
1
11

MONITOR
829
489
908
534
TGTmale5080
10962256 / 58850717
5
1
11

MONITOR
747
537
827
582
TGTfem<50
15644167 / 58850717
5
1
11

MONITOR
913
534
987
579
TGTfem>80
2532337 / 58850717
5
1
11

MONITOR
829
536
909
581
TGTfem5080
11924854 / 58850717
5
1
11

TEXTBOX
780
471
930
489
% joint category target ISTAT
10
0.0
1

BUTTON
742
431
825
464
TGT_joint
set TGTjoinISTAT csv:from-file \"C:/Users/rocpa/OneDrive/Desktop/ROME_CNR/WP5/dfcrossed_istat.csv\"\nshow TGTjoinISTAT
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
827
431
908
464
TGT_age
set TGTageISTAT csv:from-file \"C:/Users/rocpa/OneDrive/Desktop/ROME_CNR/WP5/dfage_istat.csv\"\nshow TGTageISTAT
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
911
432
991
465
TGT_gen
set TGTgenderISTAT csv:from-file \"C:/Users/rocpa/OneDrive/Desktop/ROME_CNR/WP5/dfgen_istat.csv\"\nshow TGTgenderISTAT
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
727
410
1027
428
--------------------------TGT ISTAT data -----------------------
10
0.0
1

TEXTBOX
720
420
735
576
|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n
10
0.0
1

TEXTBOX
1005
418
1020
574
|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n
10
0.0
1

@#$#@#$#@
## WHAT IS IT?

The model formalizes the Iterative Proportional Fitting (IPF), a technique used for synthetic reconstruction, used to derive the properties of agents from the known marginal distribution of a target population. 
The model provides weights to adapt to an artificial population, so to be representative of the target population. In the specific case, the raw number for each category are reported.
In the bottom right corner, results are converted into percentage for each joint category to approximate to the real population. The percentages can be used to initialize a synthetic population of any other size.

## LITERATURE CONTEXT

Synthetic populations aim at integrating various database sources to build architectures as much realistic to a target population (Adiga et al., 2015; review by Chapuis, Taillandier & Drogoul, 2022). The challenge is to integrate multiple characteristics of the agents and reproduce the joint distributions of such characteristics in the target population of interest. Yameogo et al. (2021) identify 3 main categories of techniques that address the issue: 

- COMBINATORIAL OPTIMIZATION (CO): used when the joint distributions are known and can be directly implemented, scaling the target population to the synthetic society
- SYNTHETIC RECONSTRUCTION (SR): used when the joint distributions are not known, but the marginal distributions in the population are known. The goal of the technique is to estimate weights for each category of artificial agents' joint attributes from the marginal distribution of the population.
- STATISTICAL LEARNING: new and less used: estimate the joint probabilities from regression models.

However, CO and SR are the two main streams of techniques recognized in literature (Chapuis, Taillandier & Drogoul, 2022; Jiang et al., 2022). SR is the choice when integrating surveys and want to assure they are representative of a known population. Much literature stems from geography studies (Lovelace et al., 2015), taking marginal distributions from census track as target population and integrate with surveys. 

Our work stands in the SR cluster, since best fit to provide a service able to integrate various data sources where attributes of synthetic agents are not known. The final goal is to have an abm able to integrate data from various sources (1), identify target values from a real population (2), estimate weights and initialize a synthetic population (3).

IPF is the archetypal technique in SR (Lovelace et al., 2015; Chapuis, Taillandier & Drogoul, 2022), equivalent to raking in survey statistics.

## HOW IT WORKS

IPF takes the data from a sample into a contingency table, the goal is to estimate weights for each cell (joint distribution) so that the fitted marginals computed become equivalent to the known marginals in the population. For each cell, the weight computed is the ratio of marginal distribution known in the population (target) by the fitted marginal distribution of the sample at each iteration. An iteration is the computation of weights by row (step 1, variable 1) and then columns (step 2, variable 2). The process is repeated a number of iterations until a benchmark is met. 

Each cell at iteration 0 (i.e. the original sample) has weight 1 and equal weight 1.

TAE (Total Absolute Error) is one internal validation measure to the IPF algorithm. It is the absolute difference between known target marginal value and fitted marginal value. It should be close to zero, i.e. the values are similar.

TGT_age, TGT_age, TGT_joint: empirical data that serve as target, both marginal and join distribution. Data are the age and gender of the Italian national population at 2023 retrieved at ISTAT, recoded separately (see R code): https://esploradati.istat.it/databrowser/#/it/dw/categories/IT1,POP,1.0/POP_POPULATION/DCIS_POPRES1/IT1,22_289_DF_DCIS_POPRES1_2,1.0 

Marginal values in the TGT target boxes are already calibrated

## HOW TO USE IT

For the sake of exposition, a scenario here is presented where 2 variables are taken into account (AGE and GENDER). A random sample is extracted that will be used for the initialization of a synthetic population. The observer can impose manually the marginal distributions of a hypothetical population to use as target. The goal of the model is to compute the weights of each category using IPF, so that the sample is representative of the population.

1) SAMPLE_EXTRACTION: set up a random sample
2) Set manually the target marginal values of each variable in the population (blue boxes TGT). The sum of columns must be equal to the some of the rows!
3) UPDATE_WEIGHTS: to run the IPF

Alternatively, the algorithm can be broken down manually running at each step first by rows (FITTING_ROWS button) and then by columns (FITTING_COLUMNS button). The chooser SEED_COMPARISON is to set a seed in the code to have same conditions to compare between FITTING_ROWS+COLUMN_ROWS and UPDATE_WEIGHTS

## THINGS TO NOTICE

In the contingency table, the updated value of each cell (joint distribution) is displayed, multiplying the cell by its weight.
In the output, the marginal fitted values at each iteration (using UPDATE_WEIGHTS)
In the corner, the actual weights estimated at each step. 
In the plots, the value of each joint category is updated: it serves to compare what initial distributions would be implemented based solely on data from the original sample and how they would change once weights are calibrated.

## THINGS TO CORRECT /  NEXT STEPS

* Used precision values with 5 decimals to avoid "integerization" (Lovelace et al., 2015): not having precise correspondence between fitted marginals and known marginals, so that the iteration would continues for extremely low values of TAE (truncation)

* Allocating (Yamaego et al, 2021), connected to integerization: the values obtained have decimals, which might be nonsense in some cases with initialization (e.g. the category has 0.6 agents). They can be rounded then.

* Limits of IPF (next steps, what is new): 
	- enable the simulation to be used for nested data: the IPF uses one layer of population, generally individuals. This is addressed as two-layered population issue, e.g. combining data on individuals (level 1) and households (level 2), not knowing the actual intersection between the levels. A general trend is to run IPF for the two layers independently, or compute probabilities for one layer knowing the characteristics of the other (see Gargiulo et al., 2010, modeling individuals from known distributions of households). More recently, the Hierarchical Iterative Proportional Fitting has been developed to treat jointly the two layers (Yamaeogo et al 2021, Müller & Axhausen (2011) for a first implementation)
	- "curse of multidimensionality" (mention in Chapuis et al., 2022): IPF uses two variables at the time, which is not the case with multiple source of data and research infrastructure. The model should be able to reproduce as many joint characteristics as possible. An alternative might be to repeat IPF for each combination 2x2 of variables,  and then reiterate until weights fit each possible combination, but this is slow and  unpracticable. I want to see if others have addressed this. Farooq et al (2013) should have addressed it, taking Markov Chain Monte Carlo (MCMC) as alternative to IPF to address multiple dimensions at the time. I have to study this.
	- initialize with real data, ideally CESSDA,RISIS,SHARE, both to test and to address data incongruity and automated techniques (Chapuis et al. 2022): variables are at different scales (e.g. age continuous, gender binary), incompleteness (a level of variable in the sample or in the population is missing, so the marginal sum is equal to 0 and IPF cannot be run). An overview of techniques and how to implement automatically in the initialization of abm.
	- recommendation to look at SHARE, think of it web-based (FP)

## REFERENCES

Adiga, A., Agashe, A., Arifuzzaman, S., Barrett, C. L., Beckman, R. J., Bisset, K. R., ... & Xie, D. (2015). Generating a synthetic population of the United States. Network Dynamics and Simulation Science Laboratory, Tech. Rep. NDSSL, 15-009.

Chapuis, K., Taillandier, P., & Drogoul, A. (2022). Generation of synthetic populations in social simulations: a review of methods and practices. Journal of Artificial Societies and Social Simulation, 25(2).

Farooq, B., Bierlaire, M., Hurtubia, R., & Flötteröd, G. (2013). Simulation based population synthesis. Transportation Research Part B: Methodological, 58, 243-263.

Gargiulo, F., Ternes, S., Huet, S., & Deffuant, G. (2010). An iterative approach for generating statistically realistic populations of households. PloS one, 5(1), e8828.

Jiang, N., Crooks, A. T., Kavak, H., Burger, A., & Kennedy, W. G. (2022). A method to create a synthetic population with social networks for geographically-explicit agent-based models. Computational Urban Science, 2(1), 7.

Lovelace, R., Birkin, M., Ballas, D., & Van Leeuwen, E. (2015). Evaluating the performance of iterative proportional fitting for spatial microsimulation: new tests for an established technique. Journal of Artificial Societies and Social Simulation, 18(2).

Müller, K., & Axhausen, K. W. (2011). Hierarchical IPF: Generating a synthetic population for Switzerland. ERSA 2011.

Yameogo, B. F., Vandanjon, P. O., Gastineau, P., & Hankach, P. (2021). Generating a two-layered synthetic population for French municipalities: Results and evaluation of four synthetic reconstruction methods. JASSS-Journal of Artificial Societies and Social Simulation, 24, 27p.

## CREDITS AND REFERENCES

Rocco Paolillo
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@