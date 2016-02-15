# sa-pupil-analysis
Matlab code and SPSS syntax for the analysis of pupil data presented in article: "Pupillary responses to infant facial expressions". Data is available at Zenodo, Yrttiaho, Santeri et al.. (2016). Dateset for article: Pupillary responses to infant facial expressions. Zenodo. 10.5281/zenodo.45989
Pupil analysis documentation

This documentation lists all steps, data folders, and files needed for the analysis of pupil data. In scripts/syntax please ensure that the filepaths match your local directories/folders. To this end, set working directory in SPSS with command ‘cd’ to the folder containing your pupil analysis files:

example: cd 'D:\superfolder\subfolder\pupil analysis'.

You may also include all code/syntax and data in this same folder. The necesssary data folders are: SA gazefiles anonymized A, SA gazefiles anonymized B, SA anonCTRL face, SA anonCTRL noise, which can be downloaded from Zenodo. The Matlab code and SPSS syntax can be downloaded from GitHub and should include the ‘igazelib’ library for pupil/gaze analyses included in folder: ‘igazelib081b’.

Active viewing experiment 

Anonymized data file are in folder: ‘SA gazefiles anonymized A’

Analysis steps for active viewing experiment, pupil constriction
1. run script: pupilAnalysis_Eprime3.m
	*select data folder: ‘SA gazefiles anonymized A’
	*script produces output: EprimeConstriction.xls
2.  import EprimeConstriction.xls to spss using syntax: Restructure data_constr_Eprime.sps
*syntax produces files: Eprime_constr_accept.sav, Eprime_constr_aggr.sav, Eprime_constr_repeated.sav
3. create new vars to Eprime_constr_repeated.sav with syntax: Create vars repeated constr.sps
4. run statistical analysis with syntax: Constr stat analysis_Eprime.sps

Analysis steps for active viewing experiment, pupil dilation
1. run script: pupilAnalysis_Eprime2.m
	*select data folder: ‘SA gazefiles anonymized A’
	*script produces output: EprimeDilation.xls
2.  import EprimeDilation.xls to spss using syntax: Restructure data_dilat_Eprime.sps
*syntax produces files: Eprime_dilation_accept.sav, Eprime_dilation_aggr.sav, Eprime_dilat_repeated.sav
3. create new vars to Eprime_dilat_repeated.sav with syntax: Create vars repeated dilat.sps
4. run statistical analysis with syntax: Dilat stat analysis_Eprime.sps
 
Passive viewing experiment	

Anonymized data file are in folder: ‘SA gazefiles anonymized B’

Analysis steps for passive viewing experiment, pupil constriction

1. run script: pupilAnalysis_Matlab.m
	*select data folder: ‘SA gazefiles anonymized B’
	*script produces output: MatlabConstriction.xls

2.  import MatlabConstriction.xls to spss using syntax: Restructure data_constr_Matlab.sps

*syntax produces files: Matlab_constr_accept.sav, Matlab_constr_aggr.sav, Matlab_constr_repeated.sav

3. create new vars to Matlab_constr_repeated.sav with syntax: Create vars repeated constr.sps

4. run statistical analysis with syntax: Constr stat analysis_Matlabs.sps


Analysis steps for passive viewing condition, pupil dilation

1. run script: pupilAnalysis_Matlab2.m

	*select data folder: SA gazefiles anonymizedB

	*script produces output: MatlabDilation.xls

2.  import MatlabDilation.xls to spss using syntax: Restructure data_dilat_Matlab.sps

*syntax produces files: Matlab_dilation_accept.sav, Matlab_dilation_aggr.sav, Matlab_dilat_repeated.sav


3. create new vars to Matlab_dilat_repeated.sav with syntax: Create vars repeated dilat.sps

4. run statistical analysis with syntax: Dilat stat analysis_ Matlab.sps


Comparison between the passive and active viewing experiments

1. SPSS datafile: MatlabEprime_dilat_repeated.sav

	*this is merged (“add cases”) from Matlab_dilat_repeated.sav and Eprime_dilat_repeated.sav

2. run statistical analysis with syntax: Dilat_MatlabEprime.sps


Control experiment

1. run scripts to analyze gaze data from folders:

	1.1 script/function: pupilAnalysisCtrlFace.m,	data folder: SA anonCTRL face

	1.2 script/function: pupilAnalysisCtrlFace2.m,	data folder: SA anonCTRL face

	1.3 script/function: pupilAnalysisCtrlNoise.m,	data folder: SA anonCTRL noise

	1.4 script/function: pupilAnalysisCtrlNoise2.m,	data folder: SA anonCTRL noise

*scripts produce outputs: CtrlConstrictionFace.xls, CtrlDilationFace.xls, CtrlConstrictionNoise.xls, and CtrlDilationNoise.xls

2. Import to SPSS and restructure data using syntax files:

	2.1 Restructure_constr_Ctrl_Face.sps, Create vars repeated constr.sps

	2.2 Restructure_dilat_Ctrl_Face.sps, Create vars repeated dilat.sps

	2.3 Restructure_constr_Ctrl_Noise.sps, Create vars repeated constr.sps

	2.4 Restructure_dilat_Ctrl_Face.sps, Create vars repeated dilat.sps

3. Merge data (“add variables”) from face and control conditons with syntax:

	3.1 Merge conditions FaceNoise_constr.sps

	3.2 Merge conditions FaceNoise_dilat.sps

4. Analyze data with statistical tests with syntax:

	4.1 Constr stat analysis_Cntrl.sps

	4.2 Dilat stat analysis_Cntrl.sps
