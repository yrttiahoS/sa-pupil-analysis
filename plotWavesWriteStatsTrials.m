%Script which plots pupil responses (i.e., time-diameter)
%and extracts statistics from these waves (e.g., mean, min, N)
%
%Uses data structures of "pupilAnalysis*.m" -functions
%Central data stucture is: "comb_pup_waves" (2D matrix: times-by-trials)
%Mapping of trials in "comb_pup_waves" to correct participants and stimuli
%is based on vectors "stimClass" and "filename" (1D matrix: trials)

%THE VERSION: plotWavesWriteStatsTrials is for trial-by-trial analyses

%set plotting on/off, boolean
plotting = 0;%1; %0;

%allStims = unique(stimClass);
%allSubs = unique(filename);

%find good data rows
goods = find(combination_column == 1);

%Make headers for output file
%stats = {'pupil_min', 'pupil_mean', 'trials'};
%conditions can be found from a vector
%conditions = unique(stimClass);

%initialize output matrix
outCell = {};


% % make header row
for i =1:length (csvheaders)
    outCell(1,end+1) = csvheaders(i);
end
outCell(1,end+1) = {'pupilValue'};

%Axes scale for plotting
%axis1 = [0 2000 -.8 .35]; % constriction response
axis1 = [0 7000 -.30000000000000004 .7]; %dialation response

%Esure that time range matches between analyses windows used here and in
%main function
% if plotMax > winMaxRow(goods(1))
%     plotMax = winMaxRow(goods(1)) + 10;
% end
    
%make plots dock into separate figure-tabs
set(0,'DefaultFigureWindowStyle','docked') 



%Data analysis trial by trial, loop through time-pupil responses (=waves)
for i=1:size(comb_pup_waves,2)% length(comb_pup_waves) 
    
        %PLOTTING and ANALYSIS COMMANDS
             
        select = intersect(i, goods);
        
        %Get split-half of trials
        %1st half
%         select = select(1:floor(length(select)/2));   
        %2nd half
%        select = select(floor( length(select)/2)+1:length(select));
        
        %sizeOfWave = size(wave)
        waves1 = comb_pup_waves(1:plotMax,select);
        if ~isempty(waves1)
            
            %winMinRow(goods(1))

            %get the dip in pupil size, 
            %search is bound within window "winMinRow to winMaxRow" , if ~useBaseline find reference value from the first sample of "wave"
            [mark, pupilValue] = findLightResponse(mean(waves1,2)', winMinRow(goods(1)), winMaxRow(goods(1)), useBaseline);
            if(plotting)
                figure
                plot(timeaxis(1:plotMax,1),  mean(waves1,2)')
                hold all
                plot(timeaxis(1:plotMax,1), mark')
                title([filename(select) '____'  trialid(select) '_trials:' num2str(trialnum(select)) ' min: ' num2str(pupilValue) ])
                axis(axis1);
            end
        end
            %OUTPUT STATISTICS COMMANDS
           % 'Stimulus',
            outCell{i+1, find(strcmp(csvheaders,'Stimulus'))} = cell2mat(trialid(i));
            % 'Filename', 
            outCell{i+1, find(strcmp(csvheaders,'Filename'))} = cell2mat(filename(i));
            % 'pupil win (ms)', 
            outCell{i+1, find(strcmp(csvheaders,'pupil win (ms)'))} = cell2mat(pupilWindow(i));
            % 'Trial number', 
            outCell{i+1, find(strcmp(csvheaders,'Trial number'))} = trialnum(i);
            % 'StimClass',  ...
            outCell{i+1, find(strcmp(csvheaders,'StimClass'))} = cell2mat(stimClass(i));
            % 'valid gaze r %',
            outCell{i+1, find(strcmp(csvheaders,'valid gaze r %'))} =  validityr(i);
            % 'valid gaze l %', 
            outCell{i+1, find(strcmp(csvheaders,'valid gaze l %'))} =  validityl(i);
            % 'longest non-valid baseline', 
            outCell{i+1, find(strcmp(csvheaders,'longest non-valid baseline'))} =  longest_nvBL(i);
            % 'longest non-valid pupil',  ...
            outCell{i+1, find(strcmp(csvheaders,'longest non-valid pupil'))} =  longest_nvPup(i);
            % 'inside AOI', 
            outCell{i+1, find(strcmp(csvheaders,'inside AOI'))} =  inside_aoi(i);
            % 'mean diameter', ...
            outCell{i+1, find(strcmp(csvheaders,'mean diameter'))} =  meanDiameter(i);
            % 'combination', 
            outCell{i+1, find(strcmp(csvheaders,'combination'))} =  combination_column(i);
            % 'combination2', 
            outCell{i+1, find(strcmp(csvheaders,'combination2'))} =  combination_column_2(i);
            % 'pupil no bl', 
            outCell{i+1, find(strcmp(csvheaders,'pupil no bl'))} =  meanDiameterNoBL(i);
            % 'aoi_violé'};
            outCell{i+1, find(strcmp(csvheaders,'aoi_violé'))} =  aoi_violation(i);
            % Insert extracted pupilValue here!
            try
                outCell{i+1, length(csvheaders)+1 } = pupilValue;
            catch err
            end
            % 
                    
        %end
end


% Write output data
xlswrite(outputfilename,outCell);  %xlswrite(['outCell_' outputVersion],outCell);