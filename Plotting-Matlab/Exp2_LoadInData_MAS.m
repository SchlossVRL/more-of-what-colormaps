% load in data into a .mat file for RT & accuracy

%Exp1_ColormapSpace-What.mat 

%Set WD - update to your device
%cd /Users/melan/Dropbox/Research/Experiments/ColormapWhat/Analyses/SlowerShorterData %Melissa
cd /Users/alexissoto/Dropbox/ColormapWhat/Analyses/SlowerShorterData %Lexi

%Update the number of subjects 
SlowerSubj = [1:30]; 
ShorterSubj = [1:30];


%% Slower condition
%Read in the RT data
n = length(SlowerSubj);
LoadRTSlow = zeros(16,20,n);  %16 conditiion rows, 20 columns of data

for i = 1:n
     file = strcat(num2str(SlowerSubj(i)),'-Slow-rtdata.csv'); %file names
     LoadRTSlow(:,:,i) = dlmread(file, ',', 'G2..Z17');  %data portion in excel- excluding labels
end


%Read in the accuracy data
n = length(SlowerSubj);
LoadAccSlow = zeros(16,20,n);  %16 conditiion rows, 20 columns of data

for i = 1:n
     file = strcat(num2str(SlowerSubj(i)),'-Slow-accuracydata.csv'); %file names
     LoadAccSlow(:,:,i) = dlmread(file, ',', 'G2..Z17');  %data portion in excel- excluding labels
end



%% Shorter condition
%Read in the RT data
n = length(ShorterSubj);
LoadRTShort = zeros(16,20,n);  %16 conditiion rows, 20 columns of data

for i = 1:n
     file = strcat(num2str(ShorterSubj(i)),'-Short-rtdata.csv'); %file names
     LoadRTShort(:,:,i) = dlmread(file, ',', 'G2..Z17');  %data portion in excel- excluding labels
end


%Read in the accuracy data
n = length(ShorterSubj);
LoadAccShort = zeros(16,20,n);  %16 conditiion rows, 20 columns of data

for i = 1:n
     file = strcat(num2str(ShorterSubj(i)),'-Short-accuracydata.csv'); %file names
     LoadAccShort(:,:,i) = dlmread(file, ',', 'G2..Z17');  %data portion in excel- excluding labels
end

%% Create .mat file 

%cd /Users/melan/Dropbox/Research/Experiments/ColormapWhat/Analyses/AnalyzingExperimentData/OrganzingPloting(Matlab)%Melissa
cd /Users/alexissoto/Dropbox/ColormapWhat/Analyses/AnalyzingExperimentData/OrganzingPloting(Matlab)%Lexi

%create structure for accuacy and RT data
Slower.LoadAcc = LoadAccSlow
Slower.LoadRT = LoadRTSlow


%create structure for accuacy and RT data
Shorter.LoadAcc = LoadAccShort
Shorter.LoadRT = LoadRTShort

Exp2.Slower = Slower
Exp2.Shorter = Shorter

%Save Exp2 as .mat file into this folder