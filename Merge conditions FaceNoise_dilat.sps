*syntax for merging files.

*load face condition.
GET
  FILE='CtrlFace_dilat_repeated.sav'.
DATASET NAME DataSet20 WINDOW=FRONT.

*rename var names to contain "face".
RENAME VARIABLES (Dilat_mean.M.N Dilat_mean.M.P Dilat_mean.S.N Dilat_mean.S.P N_trials.M.N N_trials.M.P
N_trials.S.N N_trials.S.P minTrials N_trials.N N_trials.P pupDil.N pupDil.P valence N_trials.M N_trials.S pupDil.M pupDil.S SvsM =
Dilat_mean.M.N.face Dilat_mean.M.P.face Dilat_mean.S.N.face Dilat_mean.S.P.face N_trials.M.N.face N_trials.M.P.face
N_trials.S.N.face N_trials.S.P.face minTrials.face N_trials.N.face N_trials.P.face pupDil.N.face pupDil.P.face valence.face N_trials.M.face
 N_trials.S.face pupDil.M.face pupDil.S.face SvsM.face).

*save renamed.
SAVE OUTFILE='CtrlFace_dilat_repeated.sav'.

*load noise condition.
GET
  FILE='CtrlNoise_dilat_repeated.sav'.
DATASET NAME DataSet21 WINDOW=FRONT.

*rename var names to contain "noise".
RENAME VARIABLES (Dilat_mean.M.N Dilat_mean.M.P Dilat_mean.S.N Dilat_mean.S.P N_trials.M.N N_trials.M.P
N_trials.S.N N_trials.S.P minTrials N_trials.N N_trials.P pupDil.N pupDil.P valence N_trials.M N_trials.S pupDil.M pupDil.S SvsM =
Dilat_mean.M.N.noise Dilat_mean.M.P.noise Dilat_mean.S.N.noise Dilat_mean.S.P.noise N_trials.M.N.noise N_trials.M.P.noise
N_trials.S.N.noise N_trials.S.P.noise minTrials.noise N_trials.N.noise N_trials.P.noise pupDil.N.noise pupDil.P.noise valence.noise N_trials.M.noise
 N_trials.S.noise pupDil.M.noise pupDil.S.noise SvsM.noise).

*save renamed.
SAVE OUTFILE='CtrlNoise_dilat_repeated.sav'.

*merge files.
DATASET ACTIVATE DataSet20.
STAR JOIN
  /SELECT t0.Dilat_mean.M.N.face, t0.Dilat_mean.M.P.face, t0.Dilat_mean.S.N.face, 
    t0.Dilat_mean.S.P.face, t0.N_trials.M.N.face, t0.N_trials.M.P.face, t0.N_trials.S.N.face, 
    t0.N_trials.S.P.face, t0.minTrials.face, t0.N_trials.N.face, t0.N_trials.P.face, t0.pupDil.N.face, 
    t0.pupDil.P.face, t0.valence.face, t0.N_trials.M.face, t0.N_trials.S.face, t0.pupDil.M.face, 
    t0.pupDil.S.face, t0.SvsM.face, t1.Dilat_mean.M.N.noise, t1.Dilat_mean.M.P.noise, 
    t1.Dilat_mean.S.N.noise, t1.Dilat_mean.S.P.noise, t1.N_trials.M.N.noise, t1.N_trials.M.P.noise, 
    t1.N_trials.S.N.noise, t1.N_trials.S.P.noise, t1.minTrials.noise, t1.N_trials.N.noise, 
    t1.N_trials.P.noise, t1.pupDil.N.noise, t1.pupDil.P.noise, t1.valence.noise, t1.N_trials.M.noise, 
    t1.N_trials.S.noise, t1.pupDil.M.noise, t1.pupDil.S.noise, t1.SvsM.noise
  /FROM * AS t0
  /JOIN 'DataSet21' AS t1
    ON t0.IDsubj=t1.IDsubj
  /OUTFILE FILE=*.

SAVE OUTFILE='CtrlFaceNoise_dilat_repeated.sav'.


