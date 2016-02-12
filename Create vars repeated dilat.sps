*compute valence-specific N_trials accross arousal levels.
COMPUTE N_trials.N = N_trials.M.N + N_trials.S.N.
EXECUTE.
COMPUTE N_trials.P = N_trials.M.P + N_trials.S.P.
EXECUTE.

*pupil size for negative valence, average, face condition.
COMPUTE pupDil.N = ((Dilat_mean.M.N * N_trials.M.N) + (Dilat_mean.S.N * N_trials.S.N))  / N_trials.N.
EXECUTE.

*pupil size for positive valence, average, face condition.
COMPUTE pupDil.P = ((Dilat_mean.M.P * N_trials.M.P) + (Dilat_mean.S.P * N_trials.S.P))  / N_trials.P.
EXECUTE.

*valence effect, face condition.
COMPUTE valence = pupDil.N - pupDil.P.
EXECUTE.

*compute arousal-specific N_trials accross valence levels.
COMPUTE N_trials.M = N_trials.M.N + N_trials.M.P.
EXECUTE.
COMPUTE N_trials.S = N_trials.S.P + N_trials.S.N.
EXECUTE.

*pupil size for mild arousal, average, face condition.
COMPUTE pupDil.M = ((Dilat_mean.M.N * N_trials.M.N) + (Dilat_mean.M.P * N_trials.M.P))  / N_trials.M.
EXECUTE.

*pupil size for strong arousal, average, face condition.
COMPUTE pupDil.S = ((Dilat_mean.S.P * N_trials.S.P) + (Dilat_mean.S.N * N_trials.S.N))  / N_trials.S.
EXECUTE.

*arousal effect, face condition.
COMPUTE SvsM =pupDil.S - pupDil.M.
EXECUTE.






