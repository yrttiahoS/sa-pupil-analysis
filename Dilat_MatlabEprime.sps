GET 
  FILE='MatlabEprime_dilat_repeated.sav'. 
DATASET NAME DataSet9 WINDOW=FRONT.

COMPUTE filter_$=min(N_trials.N, N_trials.P) >= 3 . 
VARIABLE LABELS filter_$ 'min(N_trials.N, N_trials.P) >= 3  (FILTER)'. 
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'. 
FORMATS filter_$ (f1.0). 
FILTER BY filter_$. 
EXECUTE. 

UNIANOVA valence BY Eprime 
  /METHOD=SSTYPE(3) 
  /INTERCEPT=INCLUDE 
  /PLOT=PROFILE(Eprime) 
  /EMMEANS=TABLES(Eprime) 
  /PRINT=ETASQ 
  /CRITERIA=ALPHA(.05) 
  /DESIGN=Eprime.



