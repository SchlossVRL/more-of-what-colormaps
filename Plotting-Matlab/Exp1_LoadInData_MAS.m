% load in data into a .mat file for RT & accuracy

%Exp1_ColormapSpace-What.mat 

%Set WD - update to your device
%cd /Users/melan/Dropbox/Research/Experiments/ColormapWhat/Analyses/FasterLongerData %Melissa
cd /Users/alexissoto/Dropbox/ColormapWhat/Analyses/FasterLongerData %Lexi

%Update the number of subjects 
FasterSubj = [1:31]; 
LongerSubj = [1:30];


%% Faster condition
%Read in the RT data
n = length(FasterSubj);
LoadRTFast = zeros(16,20,n);  %16 conditiion rows, 20 columns of data

for i = 1:n
     file = strcat(num2str(FasterSubj(i)),'-fast-rtdata.csv'); %file names
     LoadRTFast(:,:,i) = dlmread(file, ',', 'G2..Z17');  %data portion in excel- excluding labels
end


%Read in the accuracy data
n = length(FasterSubj);
LoadAccFast = zeros(16,20,n);  %16 conditiion rows, 20 columns of data

for i = 1:n
     file = strcat(num2str(FasterSubj(i)),'-fast-accuracydata.csv'); %file names
     LoadAccFast(:,:,i) = dlmread(file, ',', 'G2..Z17');  %data portion in excel- excluding labels
end



%% Longer condition
%Read in the RT data
n = length(LongerSubj);
LoadRTLong = zeros(16,20,n);  %16 conditiion rows, 20 columns of data

for i = 1:n
     file = strcat(num2str(LongerSubj(i)),'-long-rtdata.csv'); %file names
     LoadRTLong(:,:,i) = dlmread(file, ',', 'G2..Z17');  %data portion in excel- excluding labels
end


%Read in the accuracy data
n = length(LongerSubj);
LoadAccLong = zeros(16,20,n);  %16 conditiion rows, 20 columns of data

for i = 1:n
     file = strcat(num2str(LongerSubj(i)),'-long-accuracydata.csv'); %file names
     LoadAccLong(:,:,i) = dlmread(file, ',', 'G2..Z17');  %data portion in excel- excluding labels
end

%% Create .mat file 

%cd /Users/melan/Dropbox/Research/Experiments/ColormapWhat/Analyses/AnalyzingExperimentData/OrganzingPloting(Matlab)%Melissa
cd /Users/alexissoto/Dropbox/ColormapWhat/Analyses/AnalyzingExperimentData/OrganzingPloting(Matlab)%Lexi

%create structure for accuacy and RT data
Faster.LoadAcc = LoadAccFast
Faster.LoadRT = LoadRTFast


%create structure for accuacy and RT data
Longer.LoadAcc = LoadAccLong
Longer.LoadRT = LoadRTLong

Exp1.Longer = Longer
Exp1.Faster = Faster

%Save Exp1Pilot as .mat file into this folder