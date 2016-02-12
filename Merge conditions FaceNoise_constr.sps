*syntax for merging files.

*load face condition.
GET
  FILE='CtrlFace_constr_repeated.sav'.
DATASET NAME DataSet20 WINDOW=FRONT.

*rename var names to contain "face".
RENAME VARIABLES (Constr_mean.M.N Constr_mean.M.P Constr_mean.S.N Constr_mean.S.P N_trials.M.N N_trials.M.P
N_trials.S.N N_trials.S.P minTrials N_trials.N N_trials.P pupCtr.N pupCtr.P valence N_trials.M N_trials.S pupCtr.M pupCtr.S SvsM =
Constr_mean.M.N.face Constr_mean.M.P.face Constr_mean.S.N.face Constr_mean.S.P.face N_trials.M.N.face N_trials.M.P.face
N_trials.S.N.face N_trials.S.P.face minTrials.face N_trials.N.face N_trials.P.face pupCtr.N.face pupCtr.P.face valence.face N_trials.M.face
 N_trials.S.face pupCtr.M.face pupCtr.S.face SvsM.face).

*save renamed.
SAVE OUTFILE='CtrlFace_constr_repeated.sav'.

*load noise condition.
GET
  FILE='CtrlNoise_constr_repeated.sav'.
DATASET NAME DataSet21 WINDOW=FRONT.

*rename var names to contain "noise".
RENAME VARIABLES (Constr_mean.M.N Constr_mean.M.P Constr_mean.S.N Constr_mean.S.P N_trials.M.N N_trials.M.P
N_trials.S.N N_trials.S.P minTrials N_trials.N N_trials.P pupCtr.N pupCtr.P valence N_trials.M N_trials.S pupCtr.M pupCtr.S SvsM =
Constr_mean.M.N.noise Constr_mean.M.P.noise Constr_mean.S.N.noise Constr_mean.S.P.noise N_trials.M.N.noise N_trials.M.P.noise
N_trials.S.N.noise N_trials.S.P.noise minTrials.noise N_trials.N.noise N_trials.P.noise pupCtr.N.noise pupCtr.P.noise valence.noise N_trials.M.noise
 N_trials.S.noise pupCtr.M.noise pupCtr.S.noise SvsM.noise).

*save renamed.
SAVE OUTFILE='CtrlNoise_constr_repeated.sav'.

*merge files.
DATASET ACTIVATE DataSet20.
STAR JOIN
  /SELECT t0.Constr_mean.M.N.face, t0.Constr_mean.M.P.face, t0.Constr_mean.S.N.face, 
    t0.Constr_mean.S.P.face, t0.N_trials.M.N.face, t0.N_trials.M.P.face, t0.N_trials.S.N.face, 
    t0.N_trials.S.P.face, t0.minTrials.face, t0.N_trials.N.face, t0.N_trials.P.face, t0.pupCtr.N.face, 
    t0.pupCtr.P.face, t0.valence.face, t0.N_trials.M.face, t0.N_trials.S.face, t0.pupCtr.M.face, 
    t0.pupCtr.S.face, t0.SvsM.face, t1.Constr_mean.M.N.noise, t1.Constr_mean.M.P.noise, 
    t1.Constr_mean.S.N.noise, t1.Constr_mean.S.P.noise, t1.N_trials.M.N.noise, t1.N_trials.M.P.noise, 
    t1.N_trials.S.N.noise, t1.N_trials.S.P.noise, t1.minTrials.noise, t1.N_trials.N.noise, 
    t1.N_trials.P.noise, t1.pupCtr.N.noise, t1.pupCtr.P.noise, t1.valence.noise, t1.N_trials.M.noise, 
    t1.N_trials.S.noise, t1.pupCtr.M.noise, t1.pupCtr.S.noise, t1.SvsM.noise
  /FROM * AS t0
  /JOIN 'DataSet21' AS t1
    ON t0.IDsubj=t1.IDsubj
  /OUTFILE FILE=*.

SAVE OUTFILE='CtrlFaceNoise_constr_repeated.sav'.


