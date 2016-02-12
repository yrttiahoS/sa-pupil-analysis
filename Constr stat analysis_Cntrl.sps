GET
  FILE='CtrlFaceNoise_constr_repeated.sav'.
DATASET NAME DataSet14 WINDOW=FRONT.

COMPUTE filter_$=(min(N_trials.N.face,N_trials.P.face,N_trials.N.noise,N_trials.P.noise) >= 3).
VARIABLE LABELS filter_$ 'min(N_trials.N.face,N_trials.P.face,N_trials.N.noise,N_trials.P.noise) >= 3 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.
  
DESCRIPTIVES VARIABLES=minTrials.face minTrials.noise valence.face valence.noise SvsM.face SvsM.noise 
  /STATISTICS=MEAN STDDEV MIN MAX.

NPAR TESTS 
  /WILCOXON=minTrials.face valence.face SvsM.face WITH minTrials.noise valence.noise SvsM.noise (PAIRED) 
  /MISSING ANALYSIS.

GRAPH 
  /ERRORBAR(STERROR 1)=valence.face valence.noise SvsM.face SvsM.noise 
  /MISSING=LISTWISE.

NPAR TESTS 
  /FRIEDMAN=N_trials.M.N.face    N_trials.M.P.face    N_trials.S.N.face    N_trials.S.P.face
                     N_trials.M.N.noise   N_trials.M.P.noise    N_trials.S.N.noise    N_trials.S.P.noise 
  /MISSING LISTWISE.

T-TEST 
  /TESTVAL=0 
  /MISSING=ANALYSIS 
  /VARIABLES=valence.face valence.noise SvsM.face SvsM.noise 
  /CRITERIA=CI(.95).

T-TEST 
  /TESTVAL=0 
  /MISSING=ANALYSIS 
  /VARIABLES=pupCtr.N.face pupCtr.P.face pupCtr.P.noise pupCtr.N.noise pupCtr.M.face pupCtr.S.face pupCtr.M.noise pupCtr.S.noise 
  /CRITERIA=CI(.95).





