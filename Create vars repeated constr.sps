*compute valence-specific N_trials accross arousal levels.
COMPUTE N_trials.N = N_trials.M.N + N_trials.S.N.
EXECUTE.
COMPUTE N_trials.P = N_trials.M.P + N_trials.S.P.
EXECUTE.

*pupil size for negative valence, average, face condition.
COMPUTE pupCtr.N = ((Constr_mean.M.N * N_trials.M.N) + (Constr_mean.S.N * N_trials.S.N))  / N_trials.N.
EXECUTE.

*pupil size for positive valence, average, face condition.
COMPUTE pupCtr.P = ((Constr_mean.M.P * N_trials.M.P) + (Constr_mean.S.P * N_trials.S.P))  / N_trials.P.
EXECUTE.

*valence effect, face condition.
COMPUTE valence = pupCtr.N - pupCtr.P.
EXECUTE.

*compute arousal-specific N_trials accross valence levels.
COMPUTE N_trials.M = N_trials.M.N + N_trials.M.P.
EXECUTE.
COMPUTE N_trials.S = N_trials.S.P + N_trials.S.N.
EXECUTE.

*pupil size for mild arousal, average, face condition.
COMPUTE pupCtr.M = ((Constr_mean.M.N * N_trials.M.N) + (Constr_mean.M.P * N_trials.M.P))  / N_trials.M.
EXECUTE.

*pupil size for strong arousal, average, face condition.
COMPUTE pupCtr.S = ((Constr_mean.S.P * N_trials.S.P) + (Constr_mean.S.N * N_trials.S.N))  / N_trials.S.
EXECUTE.

*arousal effect, face condition.
COMPUTE SvsM =pupCtr.S - pupCtr.M.
EXECUTE.






