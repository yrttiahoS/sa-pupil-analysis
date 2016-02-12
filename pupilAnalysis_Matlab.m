function pupilAnalysis_Matlab
%Function disengagementAnalysis
%
% Analyze file for disengagement-paradigm. Parameters are defined at the
% beginning of the script.

% Modified: 

%add path to igazelib library (use the latest version)
addpath(genpath([pwd '\' 'igazelib081b']));	

%% parameters here
datatype = 'capetownMATLAB'; %'tet300'; %'capetown';%'capetown';% 'capetownMATLAB'; % %boston, tampere, att
stimCodes = []; %can be used replace missing/erraneus values in gazedata (capetown)
ending = '.gazedata'; %.gazedata 
visualizeData = 0; % 0, 1
savevisualization = 0; % 0, 1
saveMATs = 1; %bool for saving workspace vars to .mat files, also calls func: plotWavesWriteStatsTrials

%folder = [pwd filesep 'SA gazefiles\'];
folder = [uigetdir() '\'];%'C:\Users\infant\Documents\MATLAB\igazelib\MATLAB experiment SANFR\SAMother\';%'C:\Users\infant\Documents\MATLAB\igazelib\data - RGB control experiment\';%
% folder = [uigetdir() '\'];
accepted_validities = [0 1];
medianfilterlen = 7; % datapoints
longest_nonvalid_tresh =  30000000; %(ms)
minGoodStreak = 50; %ms
inside_aoi_tresh = 0.0;% 0;
reject_aoi_violation = 0;

smallestTrialNum = 2; %limit n of first trials from each participant
% these values limit the period of time:
%start of time window for mean pupil diameter, ms %300;%200;% 2000; 
min_pup_time = 300;%4000;%%300; % 
%end of time window for mean pupil diameter, ms; DONT USE VALUES > %5000!!!!!, %1200;1000; %5000;
max_pup_time = 1200;%5000;%1000; % ;1200; %1000 MUST BE MAX 1000 for 'FaceBorder' flash
%start of time window for BASELINE mean pupil diameter, ms 1000; Must be at least one frame! %500;% 500; 
bl_length = 300;
%end of time window for BASELINE mean pupil diameter, ms %-100;%100;%0;%
max_bl_time = 0;
useBaseline = 1;
minTrialDuration = max_pup_time + 1500; %ms
minPrestimulusDuration = 1500;
uplimit = 4000; %ms, NOT CONTINGENT UPON ANY STIMULUS REALLY!!! 

%Output filename
if max_pup_time > 4000
    outputfilename = 'MatlabDilation';
else
    outputfilename = 'MatlabConstriction';
end



%faceTag indicates the onset row of face stimulus
faceTagForOkStimCodeData = 'Face';%'FaceBorder'; %'Face'; %if the event-of-interest (eoi) is post-face flash: use 'FaceBorder'. 'Face' is the face-eoi.
%in some files wrong tags were used, the below variable is fo'correctn
faceTagForMissingStimCodeData = 'Target';

% define aoi-container
aoi = containers.Map;
aoi('center') = [0.3 0.7 0.1 0.9];
aoi('right') = [0.7 1 0.1 0.9];
aoi('left') = [0 0.3 0.1 0.9];
aoi('facecoord') = [0.335 0.665 0.185 0.815];
aoi('imgright') = [0.9 1 0.3 0.7];
aoi('imgleft') = [0 0.1 0.3 0.7];
% [xstart xend ystart yend] 0..1

no_operation = 0.00; % if the visualization animation is too fast, increase this value

% get all the files with .gazedata extension
files = findGazeFilesInFolder(folder, ending);


%pupil response waves from all trials
comb_pup_waves = 0;
plotMax = 420; %420 * sampling interval = 420 * 16.667 ms = 7000 ms
if strcmp(datatype,'capetownMATLAB')
    plotMax = 480; % 8000 ms
elseif strcmp(datatype,'tet300')
    plotMax = 2400; % 2400 samples * (3.3 ms) =  8000 ms
end

% round counter
rc = 1;
%ffilt is for selecting files in folder
%ffilt=[10;11;12;13;14;15;16;17;18;19;20;21;22;23;24;25;26;27;28;29;30;31;32;33;34;35;36;37;38;39;40;41;42;43;44;45;46;47;48;49;50;77;78;79;80;81;82;83;84;85;86;87;88;89;90;91;92;93;94;];
% ffilt=[10];
ffilt=[1; 2; 7; 8; 9; 10; 11; 12; 13; 15; 17; 18; 19; 20; 21; 22; 24; 25; 26; 28; 29; 30; 31; 32; 34; 35; 40; 41; 42; 43; 44; 45; 46; 48; 49; 50; 51; 60; 61; 63; 64; 65; 66; 67; 68; 70; 71; 72; 73; 74; 75; 76; 77; 78; 79; 81; 82; 83; 84; 86; 87; 88; 90; 91; 92; 93; 94; 95; 96; 97; 98; 99; 101; 102; 103; 105; 106; 107; 108; 109; 110; 111; 112; 113; 115; 117; 118];

%% calculate analysis (each file, one by one)
for j=1:length(files)%ffilt'% %ffilt'% 1:2%[13 30 ] %
%     for j=1:1%length(files):length(files)
    
    if strcmp(datatype, 'capetown')
        files{j}
        [DATA, HEADERS] = loadGazeFile(files{j});
        stimCodes = load('stimulus_codes.mat');
    elseif strcmp(datatype, 'capetownMATLAB')
        [DATA, HEADERS] = loadGazeFileHeader(files{j}, [folder 'headers.txt']);
        [fol nam ext] = fileparts(files{j}); [nam ext]
    elseif strcmp(datatype, 'boston')
        [DATA, HEADERS] = loadGazeFileBoston(files{j});
    elseif strcmp(datatype, 'tet300')
        [DATA, HEADERS] = loadGazeFile300(files{j});
    elseif strcmp(datatype, 'att')
        'Error: Check Disengaement analysis script'
    end
    
    headers = HEADERS;    
    % find COLUMN NUMBERS to know what to operate
    xgazel = findColumnNumber(headers, 'XGazePosLeftEye');
    ygazel = findColumnNumber(headers, 'YGazePosLeftEye');
    xgazer = findColumnNumber(headers, 'XGazePosRightEye');
    ygazer = findColumnNumber(headers, 'YGazePosRightEye');
    valr = findColumnNumber(headers, 'ValidityRightEye');
    vall = findColumnNumber(headers, 'ValidityLeftEye');
    ud1 = findColumnNumber(headers, 'UserDefined_1');
    pupil_l = findColumnNumber(headers, 'DiameterPupilLeftEye');
    pupil_r = findColumnNumber(headers, 'DiameterPupilRightEye');
    targetc = findColumnNumber(headers, 'Target');
    ttime = findColumnNumber(headers,'TETTime');
    stimcol = findColumnNumber(HEADERS, 'Stim');
    trialcol = findColumnNumber(headers, 'TrialId');
    
    %check if valid stimulus codes are in data
    [DATA, codeValidity] = makeStimcol(cell2mat(files(j)), DATA, stimCodes, stimcol, trialcol);
    
    %writeGazedata2(HEADERS, DATA, files{j}, 'C:\Users\infant\Documents\MATLAB\igazelib\SA gazefiles anonymizedM', 0, 0);  outputfilename = 'Etest2';
    
    %if non-valid file is found, use also different tag-column for stim-tag
    if codeValidity == 0
        faceTag = faceTagForMissingStimCodeData;
    else
        faceTag = faceTagForOkStimCodeData;
    end
        
    % datamatrix is equal in column (probably the last row is corrupted)
    % if not -> remove last row
    if ~testDataConsistency(DATA)
        rowcount = rowCount(DATA);
        DATA = clipFirstRows(DATA, rowcount-1);
    end
    
    % clip data to separate clips according to change in column "TrialId"
    clipdata = clipDataWhenChangeInCol(DATA, findColumnNumber(HEADERS, 'TrialId'));
    clipcount = length(clipdata);

    
    %% for each clip, do
    for i=1:clipcount
        i        
        whole_data = clipdata{i};
        
       
                
        %copy original headers
        headers = HEADERS;    
                
        % combine x and y -coordinates on both eyes to one 'combined'
        % coordinate for x and y (if one eye is good, use that, otherwise
        % mean of both eyes)
        [combinedx, ~] = combineEyes(whole_data, xgazer, xgazel, valr, vall, accepted_validities);
        [combinedy, newcombined] = combineEyes(whole_data, ygazer, ygazel, valr, vall, accepted_validities);
        [combined_pup, ~] = combineEyes(whole_data, pupil_r, pupil_l, valr, vall, accepted_validities);
        
        % add these new columns to data-structure
        [whole_data, headers] = addNewColumn(whole_data, headers, combinedx, 'CombinedX');
        [whole_data, headers] = addNewColumn(whole_data, headers, combinedy, 'CombinedY');
        [whole_data, headers] = addNewColumn(whole_data, headers, newcombined, 'CombinedValidity');
        [whole_data, headers] = addNewColumn(whole_data, headers, combined_pup, 'CombinedPup');
        
        % new columns numbers
        combx = findColumnNumber(headers, 'CombinedX');
        comby = findColumnNumber(headers, 'CombinedY');
        comb_pup = findColumnNumber(headers, 'CombinedPup');
        
        combval = findColumnNumber(headers, 'CombinedValidity');
        
        % interpolate (even though some of the data is probably bad, interpolate all, just
        % mark the validity information in other columns)
        whole_data = interpolateTrue(whole_data, comb_pup, combval , accepted_validities); %valr
        whole_data = medianFilterData(whole_data, medianfilterlen, comby);
        whole_data = medianFilterData(whole_data, medianfilterlen, combx);
        whole_data = medianFilterData(whole_data, medianfilterlen, comb_pup);
        
        % rows containing Prestimulus, Face or Target
        whole_data = getRowsContainingValue(whole_data, ud1, {'Prestimulus', 'Face', 'Target', 'FaceBorder'});
        
        
        % clip the data some more, first milliseconds and only rows
        data_0_relimit = clipFirstMilliSeconds(whole_data, headers, uplimit);
        
        % cut the data to "start" after when target appears to the screen
        % data_target_relimit = getRowsContainingValue(data_0_relimit, ud1, 'Target');
        % data_target_diselimit = clipFirstMilliSeconds(data_target_relimit, headers, max_dise_time);

        % disengagement to side aoi?
%        target_aoi = getValue(data_target_diselimit, 1, targetc);
        target_aoi = 'left';%getValue(whole_data, 1, targetc);
%        first_time_in_sideaoi_row = gazeInAOIRow(data_target_diselimit, combx, comby, aoi(target_aoi), 'first'); % data

        udcolumn = getColumn(whole_data, ud1);        %udcolumn = getColumn(data_0_relimit, ud1);
        targetrow = find(strcmp(udcolumn, 'Target'), 1,'first');

        facerow = find(strcmp(udcolumn, faceTag), 1,'first');
        face_onset_time = whole_data{1, ttime}(facerow,1) - whole_data{1, ttime}(1,1);
        
        %crop pupil window :clipFirstMilliSeconds sets the last timepoint included 
        [pupil_period_data, winMaxTime, winMaxRow(rc)] = clipFirstMilliSeconds(whole_data, headers, face_onset_time + max_pup_time);
        %pupil_period_data = clipLastRows(pupil_period_data, facerow);
        %            clipLastMilliSeconds sets the first timepoint included
        [pupil_period_data, winMinRow(rc)] = clipLastMilliSeconds(pupil_period_data, headers, face_onset_time + min_pup_time);
        
        pupilWindow{rc} = [num2str(face_onset_time + min_pup_time) ' - ' num2str(winMaxTime)];
        fRow(rc) = facerow;
        
          
        %pupil_period_data = whole_data;
        
        %crop pupil data
        bl_period_data = clipFirstMilliSeconds(whole_data, headers, face_onset_time + max_bl_time);
        [bl_period_data, bl_onset_row] = clipLastMilliSeconds(bl_period_data, headers, face_onset_time + max_bl_time - bl_length);
        
        analyze_period_data = whole_data; 
        
        % calculate some metrics of gaze validity
%         [longest_nvr(rc)] = longestNonValidSection(analyze_period_data, valr, ttime, accepted_validities);
%         [longest_nvl(rc)] = longestNonValidSection(analyze_period_data, vall, ttime, accepted_validities);
        [longest_nvPup(rc)] = longestNonValidSection2(pupil_period_data, combval, ttime, accepted_validities, minGoodStreak);
        [longest_nvBL(rc)] = longestNonValidSection2(bl_period_data, combval, ttime, accepted_validities, minGoodStreak);
        [validityr(rc), validityl(rc)] = validGazePercentage(pupil_period_data, headers, accepted_validities);
        
        % data_before_disengagement = clipFirstMilliSeconds(data, HEADERS, first_time_in_sideaoi_row);   
        inside_aoi_bl = gazeInAOIPercentage(bl_period_data, combx, comby, ttime, aoi('center')); 
        inside_aoi_pupil = gazeInAOIPercentage(pupil_period_data, combx, comby, ttime, aoi('center')); 
        inside_aoi(rc) = min(inside_aoi_bl, inside_aoi_pupil); %inside_aoi_pupil;
        %inside_aoi(rc) = gazeInAOIPercentage(analyze_period_data, combx, comby, ttime, aoi('center')); % data_before_disengagement
        
        meanDiameter(rc) = diameterMean(pupil_period_data, comb_pup) - diameterMean(bl_period_data, comb_pup);
        meanDiameterNoBL(rc) = diameterMean(pupil_period_data, comb_pup);
        
        aoi_violation(rc) = AOIBorderViolationDuringNonValidSection(pupil_period_data, combx, comby, combval, aoi('center'), accepted_validities);

        % gather information to the csv-file(s)
        [a, b, c] = fileparts(files{j});
        filename{rc} = [b c];
        trialid{rc} = getValue(whole_data, 1, findColumnNumber(headers, 'Stim'));
        stimClass{rc} = parseEmotion(trialid{rc}); %this classifies stimuli to few categories
        trialnum(rc) = getValue(whole_data, 1, findColumnNumber(headers, 'TrialId'));
        target{rc} = target_aoi;
        
       
       %comb_pup_waves(1:size(whole_data{comb_pup},1),rc) = getValue(whole_data, 1:size(whole_data{comb_pup},1), comb_pup);
        
      %Storage of waves has now (21.1.2014) set to depend on data validity
      
      %Check that trial duration is sufifcient
       TETTime = whole_data{findColumnNumber(HEADERS, 'TETTime')};
       TETTime(length(TETTime)) - TETTime(1);
       tooShortTrial = TETTime(length(TETTime)) - TETTime(1) < minTrialDuration  || face_onset_time < minPrestimulusDuration;
       
      
       if longest_nvPup(rc) > longest_nonvalid_tresh || inside_aoi(rc) < inside_aoi_tresh || tooShortTrial ||  aoi_violation(rc)*reject_aoi_violation == 1
                % violation of conditions
                combination_column(rc) = -1;
                combination_column_2(rc) = NaN;
                re_time(rc) = -1;
                csaccp(rc) = -1;
                
                comb_pup_waves(1:size(whole_data{comb_pup},1),rc) = NaN(size(whole_data{comb_pup},1),1);
       else
                combination_column(rc) = 1;
                combination_column_2(rc) = meanDiameter(rc);
                comb_pup_waves(1:size(whole_data{comb_pup},1),rc) = getValue(whole_data, 1:size(whole_data{comb_pup},1), comb_pup) - diameterMean(bl_period_data, comb_pup);
                
       end

     drawus = [];
%         
        
        if visualizeData == 1 && combination_column(rc) ~= -2;
%             hfig = plotGazeAnimation(data_0_relimit, headers, [folder b '_' num2str(trialnum(rc)) '.png'], no_operation, ...
%                                     accepted_validities, savevisualization, {{[pwd filesep 'images' filesep trialid{rc}], aoi('facecoord'), 1, 10000}, ...
%                                     {[pwd filesep 'images' filesep 'target1.bmp'], aoi(['img' target_aoi]), targetrow, 10000}}, ...
%                                     {aoi('center'), aoi('right'), aoi('left')}, drawus);
%             hfig = plotPupilAnimation(whole_data, headers, [comb_pup comb_pup combval ttime], [folder b '_' num2str(rc) '_' num2str(trialnum(rc)) '.png'], no_operation, ...
%                                     accepted_validities, savevisualization, {{[pwd filesep 'images' filesep trialid{rc}], aoi('facecoord'), 1, 10000}, ...
%                                     {[pwd filesep 'images' filesep 'target1.bmp'], aoi(['img' target_aoi]), targetrow, 10000}}, ...
%                                     {aoi('center'), aoi('right'), aoi('left')}, [], 'Optional information here');
            %hfig = plotGazeAnimation(whole_data, headers, [combx comby combval ttime], [folder b '_' num2str(rc) '_' num2str(trialnum(rc)) '.png'], no_operation, ...
            hfig = plotPupilAnimation(whole_data, headers, [pupil_l pupil_r combval ttime comb_pup], [folder num2str(~isnan(combination_column_2(rc))) '_'  b '_'  num2str(trialnum(rc)) '.png'], no_operation, ...
                                    accepted_validities, savevisualization, {{[pwd filesep 'images' filesep 'NoStim3.png'], aoi('facecoord'), 1, 10000}, ...
                                    {[pwd filesep 'images' filesep 'target1.bmp'], aoi(['img' target_aoi]), targetrow, 10000}}, ...
                                    {aoi('center'), aoi('right'), aoi('left')}, [],  [num2str(combination_column_2(rc)) ',  ' num2str(100*inside_aoi(rc)) '%', 'tooShortTrial: ', num2str(tooShortTrial) ]  ); %num2str(rc) '_'      

            close(hfig);
        end        
        
        rc = rc + 1;

    end
end

%% generate trial-by-trial output-file

csvheaders = {'Filename', 'pupil win (ms)', 'Trial number', 'Stimulus', 'StimClass',  ...
    'valid gaze r %', 'valid gaze l %', 'longest non-valid baseline', 'longest non-valid pupil',  ...
    'inside AOI', 'mean diameter', ...
     'combination', 'combination2', 'pupil no bl', 'aoi_violé'};
c = num2str(clock);
outputVersion = c(1:70); 
outputVersion = strrep(outputVersion, '             ', '-');
outputVersion = strrep(outputVersion, '      ', '');
output_name =  ['Pupil_results_' outputVersion '.csv'];
 
%saveCsvFile([folder 'disengagement_results.csv'], csvheaders, filename, trialnum, trialid, target, ...
% saveCsvFile([folder output_name], csvheaders, filename,  pupilWindow, trialnum, trialid, stimClass, ...
%      validityr, validityl, longest_nvBL, ...
%     longest_nvPup,  inside_aoi, meanDiameter, combination_column, combination_column_2, meanDiameterNoBL, aoi_violation);




%% generate combined output-file
% structure:
% one hash-table indexed by stimulus-id's
%   -> each stim contains a hash-table indexed by filenames


% Initialize hash-tables. Each stim has an own hash-table for vector of values 
% in range min_dise+1 -> max_dise-1 and number of max_dise. Keys are filenames.
uniqfiles = unique(filename);
uniqstim = unique(stimClass); %uniqstim = unique(trialid);

c_pupils = containers.Map;
c_max_dises = containers.Map;
c_res = containers.Map;
c_max_res = containers.Map;
c_csaccpindex = containers.Map;
c_trials = containers.Map;
c_pupil_2 = containers.Map;

for i=1:length(uniqstim)
    c_pupils(uniqstim{i}) = containers.Map;
    c_max_dises(uniqstim{i}) = containers.Map;
    c_res(uniqstim{i}) = containers.Map;
    c_max_res(uniqstim{i}) = containers.Map;
    c_csaccpindex(uniqstim{i}) = containers.Map;
    c_trials(uniqstim{i}) = containers.Map;
    c_pupil_2(uniqstim{i}) = containers.Map;
    
    % initialize hash-tables with filekeys to have empty matrix or zero
    for j=1:length(uniqfiles)

%         'temphandle_dise.keys get uniqstim'
%         temphandle_dise
%         temphandle_dise.keys
        temphandle_pupil = c_pupils(uniqstim{i}); 
        temphandle_max_dise = c_max_dises(uniqstim{i});
        temphandle_re = c_res(uniqstim{i});
        temphandle_max_re = c_max_res(uniqstim{i});
        temphandle_csaccpindex = c_csaccpindex(uniqstim{i});
        temphandle_trials = c_trials(uniqstim{i});
        temphandle_pupil_2 = c_pupil_2(uniqstim{i}); 
        
        current_file = uniqfiles{j};

        temphandle_pupil(current_file) = [];
        temphandle_pupil_2(current_file) = [];
        
%         'temphandle_pupil.keys get []'
%         temphandle_pupil.keys
%         c_pupils.keys
        
        temphandle_max_dise(current_file) = 0;
        temphandle_re(current_file) = [];
        temphandle_max_re(current_file) = 0;
        temphandle_csaccpindex(current_file) = [];
        temphandle_trials(current_file) = [];
    end
end

% fill the hash tables
for i=1:rc-1    
    temphandle_pupil = c_pupils(stimClass{i});%temphandle_pupil = c_pupils(trialid{i});
    temphandle_pupil_2 = c_pupil_2(stimClass{i});
%     'temphandle_pupil.keys get stimClass'
%     temphandle_pupil.keys
%     temphandle_pupil('IntercareMotherNew-10-1.gazedata')  
  
    temphandle_max_dise = c_max_dises(stimClass{i});%temphandle_max_dise = c_max_dises(trialid{i});
    
    temphandle_re = c_res(stimClass{i});%temphandle_re = c_res(trialid{i});
    temphandle_max_re = c_max_res(stimClass{i});%temphandle_max_re = c_max_res(trialid{i});
    
    temphandle_csaccpindex = c_csaccpindex(stimClass{i});%temphandle_csaccpindex = c_csaccpindex(trialid{i});
    temphandle_trials = c_trials(stimClass{i});
    
    current_file = filename{i};
    %filename{i};
    
    % disepart
%     if min_dise_time > combination_column(i)
%         do_re_engagement = 0;
%     elseif combination_column(i) < max_dise_time
%          temphandle_pupil(current_file) = [temphandle_pupil(current_file) meanDiameter(i)];
%         do_re_engagement = 1;
%     elseif combination_column(i) == max_dise_time
%         temphandle_max_dise(current_file) = temphandle_max_dise(current_file) + 1;
%         do_re_engagement = 1;
%     end
%     
    temphandle_pupil(current_file) = [temphandle_pupil(current_file) meanDiameter(i)];
    temphandle_pupil_2(current_file) = [temphandle_pupil_2(current_file) combination_column_2(i)];%meanDiameter(i)];
    
%     'temphandle_pupil.keys concat pupilDiameter'
%         temphandle_pupil.keys
%         temphandle_pupil('IntercareMotherNew-10-1.gazedata')  
%         'c_pupils.keys'
%         c_pupils.keys
%         'c_pupils(MN)'
%         c_pupils('MN')
                
    temphandle_trials(current_file) = [temphandle_trials(current_file) combination_column(i)];
    % might be disengagements that are out of disengagement area, remove
    % from
    
end

% generate combination file
fid = fopen([folder 'Pupil_combined_results_' outputVersion '.csv'], 'w');
fprintf(fid, 'sep=,\n');
fprintf(fid, 'filename');

for i=1:length(uniqstim)
   %fprintf(fid, [',' uniqstim{i} '_dise,numval_dise, numval_max_dise(' num2str(max_dise_time) '),re, numval_re, numval_no_re, csaccpindex']);
   %fprintf(fid, [',' 'stim,' 'pupil,trials, pupil_ok' ]); %, numval_max_dise(' num2str(max_dise_time) '),re, numval_re, numval_no_re, csaccpindex']);
   fprintf(fid, [',' [uniqstim{i} 'pupil'] ',' , [uniqstim{i} 'pupil_ok' ] ',' ,[uniqstim{i} 'trials'] ]);
end

%%%%%%%%%%
%fprintf(fid, ',disengagement_speed,disengagement_prob, index');
%%%%%%%%%%

fprintf(fid, '\n');

for i=1:length(uniqfiles)
    %fprintf(fid, uniqfiles{i});
    
    alldise = [];
    stimcount = 0;
    
    fprintf(fid,  uniqfiles{i});
    
    for j=1:length(uniqstim)
        hashtable_pupil = c_pupils(uniqstim{j});
        hashtable_pupil_2 = c_pupil_2(uniqstim{j});
        
%         'hashtabel_dise.keys get c_pupils'
%         hashtable_pupil.keys
%         hashtable_pupil('IntercareMotherNew-10-1.gazedata')

        hashtable_max_dise = c_max_dises(uniqstim{j});
        
        hashtable_re = c_res(uniqstim{j});
        hashtable_re_max = c_max_res(uniqstim{j});
        
        hashtable_csaccpindex = c_csaccpindex(uniqstim{j});
        hashtable_trials = c_trials(uniqstim{j});
        
        %%%%%%%%%%%%%%%
        alldise = [alldise hashtable_pupil(uniqfiles{i})];
        stimcount = stimcount + hashtable_max_dise(uniqfiles{i}) + length(hashtable_pupil(uniqfiles{i}));
        %%%%%%%%%%%%%%%
        
        
        pupil_2 = hashtable_pupil_2(uniqfiles{i});
        
        %SHOULD PRINT: filename, stim, pupil, trials, pupil_ok (from good
        %trials)
%         fprintf(fid, [ uniqfiles{i} ',' uniqstim{j} ',' num2str(mean(hashtable_pupil(uniqfiles{i}))) ',' ...
%             num2str(sum(hashtable_trials(uniqfiles{i})==1)) ',' num2str(mean(pupil_2(find(~isnan(pupil_2))))) ]); 
%         ',' num2str(hashtable_max_dise(uniqfiles{i})) ','... %num2str(length(hashtable_pupil(uniqfiles{i})))
% %             num2str(mean(hashtable_re(uniqfiles{i}))) ',' num2str(length(hashtable_re(uniqfiles{i}))) ','...
% %             num2str(hashtable_re_max(uniqfiles{i})) ',' num2str(mean(hashtable_csaccpindex(uniqfiles{i})))
%         
         %fprintf(fid, '\n');  %',' uniqfiles{i}
        
        fprintf(fid, [ ',' num2str(mean(hashtable_pupil(uniqfiles{i}))) ',' num2str(mean(pupil_2(find(~isnan(pupil_2))))) ',' ...
            num2str(sum(hashtable_trials(uniqfiles{i})==1))  ]);
    end
    
    %%%%%%%%%%%%%%%
    %fprintf(fid, [',höpöphöpöhpöhphöhp' num2str(mean(alldise)) ',' num2str(length(alldise)/stimcount)]);
    %%%%%%%%%%%%%%%
    
    
    fprintf(fid, '\n');
end

fclose(fid);
%% 
% comb_pup_waves;
% size(mean(comb_pup_waves,2))

%PLOT AVERAGE PUPIL RESPONSE
%1. get time axis with: getValue(DATA, row, column) 
timeaxis = 0;
timeaxis = getValue(whole_data, 1:size(whole_data{comb_pup},1), ttime) - getValue(whole_data,1, ttime);
%size(timeaxis')
%   size(mean(comb_pup_waves(1:plotMax,1),2)')
%2. plot pupil diameter against time
% plot(timeaxis(1:plotMax,1)',  mean(comb_pup_waves(1:plotMax,:),2)');
% 'comb_pup_waves'
% size(comb_pup_waves)


%Make Stimulus-specific curves
wavesSN = []; %zeros(1,plotMax);
wavesMN = []; %zeros(1,plotMax);
wavesSP = []; %zeros(1,plotMax);
wavesMP = []; %zeros(1,plotMax);
wavesTrigger = [];

for i = 1:rc-1
    
    if combination_column(i) == 1 && trialnum(i) >= smallestTrialNum
        
       wavesTrigger(end+1,1:plotMax) = zeros(1,plotMax);
       wavesTrigger(size(wavesTrigger,1), fRow(i)) = 1;
    
%     %stimClass{i} =
        switch stimClass{i}
            case 'SN'
                wavesSN(end+1,1:plotMax) = comb_pup_waves(1:plotMax,i)'; %wavesSN(end+sign(i-1),1:plotMax) = comb_pup_waves(1:plotMax,i)';
                %'SN found'
            case 'MN'
                wavesMN(end+1,1:plotMax) = comb_pup_waves(1:plotMax,i)';
            case 'SP'
                wavesSP(end+1,1:plotMax) = comb_pup_waves(1:plotMax,i)';
            case 'MP'
                wavesMP(end+1,1:plotMax) = comb_pup_waves(1:plotMax,i)';
            otherwise
                'ERRROR IN CLASSIFICATION!!'
                continue
        end
    end
end        
%     plot(timeaxis(1:plotMax,1)',  comb_pup_waves(1:plotMax,i)')
% 'mean(wavesSN)'
% mean(wavesSN) 
% 'mean(wavesSN(bl_onset_row:facerow),2)'
% mean(wavesSN(bl_onset_row:facerow),2)
% 'mean(wavesSN(1:plotMax),2)'
% mean(wavesSN(1:plotMax),2)



%PLOT stimulus-specific pupil responses, BASELINE-corrected
try
    plot(timeaxis(1:plotMax,1)',  mean(wavesMN,1) );%- mean(wavesMN(1:50)))  %mean(wavesMN(bl_onset_row:facerow)))
    hold all
    plot(timeaxis(1:plotMax,1)',  mean(wavesMP,1) );%- mean(wavesMP(1:50)))  %mean(wavesMP(bl_onset_row:facerow)))
    plot(timeaxis(1:plotMax,1)',  mean(wavesSN,1) );% - mean(wavesSN(1:50)) ) %mean(wavesSN(bl_onset_row:facerow)) 
    plot(timeaxis(1:plotMax,1)',  mean(wavesSP,1) );%- mean(wavesSP(1:50)))  %mean(wavesSP(bl_onset_row:facerow)))

    plot(timeaxis(1:plotMax,1)',  mean(wavesTrigger) );%- mean(wavesMP(1:50)))  %mean(wavesMP(bl_onset_row:facerow)))
    %hleg1 = legend('SN','MN', 'SP', 'MP', 'trig');
    hleg1 = legend('MN','MP', 'SN', 'SP', 'trig');

    'MN'
    mean(mean(wavesMN(:,121:241 ),2))
    'MP'
    mean(mean(wavesMP(:,121:241 ),2))
    'SN'
    mean(mean(wavesSN(:,121:241 ),2))
    'SP'
    mean(mean(wavesSP(:,121:241 ),2))
    
catch
    'Some data may be missing. Cannot plot...'
end

% 

if saveMATs == 1
%    save (['allPupilData_' outputVersion '.mat']) 
    plotWavesWriteStatsTrials
end

amu=0;

% end
% plot(mean(wavesSN))
% 'size(wavesSN)'
 %size(wavesSN)
% 'size( mean(wavesSN) )'
%size( mean(wavesSN) )

%mean(wavesSN)


%PLOT ALL CURVES
% for i = i:rc-1
%     plot(timeaxis(1:plotMax,1)',  comb_pup_waves(1:plotMax,i)')

%     hold all
% end
    
    
