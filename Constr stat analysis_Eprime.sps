GET
  FILE='Eprime_constr_repeated.sav'.
DATASET NAME DataSet13 WINDOW=FRONT.

COMPUTE filter_$=(min(N_trials.N, N_trials.P) >= 3 ). 
VARIABLE LABELS filter_$ 'min(N_trials.N, N_trials.P) >= 3  (FILTER)'. 
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'. 
FORMATS filter_$ (f1.0). 
FILTER BY filter_$. 
EXECUTE.
 
DESCRIPTIVES VARIABLES=minTrials valence SvsM N_trials.N N_trials.P N_trials.M N_trials.S
  /STATISTICS=MEAN STDDEV MIN MAX.

GRAPH 
  /ERRORBAR(STERROR 1)=valence SvsM
  /MISSING=LISTWISE.

NPAR TESTS 
  /FRIEDMAN=N_trials.M.N    N_trials.M.P    N_trials.S.N    N_trials.S.P
  /MISSING LISTWISE.

T-TEST 
  /TESTVAL=0 
  /MISSING=ANALYSIS 
  /VARIABLES=valence SvsM  
  /CRITERIA=CI(.95).

T-TEST 
  /TESTVAL=0 
  /MISSING=ANALYSIS 
  /VARIABLES=pupCtr.N pupCtr.P   pupCtr.M pupCtr.S   
  /CRITERIA=CI(.95).

**************

COMPUTE filter_$=(minTrials >= 3 ). 
VARIABLE LABELS filter_$ 'minTrials >= 3  (FILTER)'. 
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'. 
FORMATS filter_$ (f1.0). 
FILTER BY filter_$. 
EXECUTE.

GLM Constr_mean.M.N Constr_mean.M.P Constr_mean.S.N Constr_mean.S.P 
  /WSFACTOR=arousal 2 Polynomial vale 2 Polynomial 
  /METHOD=SSTYPE(3) 
  /PLOT=PROFILE(arousal*vale) 
  /CRITERIA=ALPHA(.05) 
  /WSDESIGN=arousal vale arousal*vale.
 






