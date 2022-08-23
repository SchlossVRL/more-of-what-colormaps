% load in data & organize into a .mat file for RT & accuracy

%Set WD to the 1.Organizing-R folder
%cd /SchlossVRL/1.Organizing-R/Exp2-SlowerShorter-Aliens-Labels

%Update the number of subjects 
SlowerSubj = [1:30]; 
ShorterSubj = [1:30];


%% Slower condition

%Read in the RT data
n = length(SlowerSubj);
LoadRTSlow = zeros(16,20,n);  %16 condition rows, 20 columns of data

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

%Change wd to the 2.Plotting-Matlab folder
%cd /SchlossVRL/2.Plotting-Matlab

%create structure for accuacy and RT data
Slower.LoadAcc = LoadAccSlow;
Slower.LoadRT = LoadRTSlow;

%create structure for accuacy and RT data
Shorter.LoadAcc = LoadAccShort;
Shorter.LoadRT = LoadRTShort;

Exp2.Slower = Slower;
Exp2.Shorter = Shorter;

%Save Exp2 as .mat file into this folder