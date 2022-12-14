% load in data & organize into a .mat file for RT & accuracy

%Set WD to the 1.Organizing-R folder
%cd /SchlossVRL/1.Organizing-R/Exp3-FasterLonger-Aliens-NoLabels

%Update the number of subjects 
FasterSubj = [1:30]; 
LongerSubj = [1:30];


%% Faster condition

%Read in the RT data
n = length(FasterSubj);
LoadRTFast = zeros(16,20,n);  %16 conditiion rows, 20 columns of data

for i = 1:n
     file = strcat(num2str(FasterSubj(i)),'-fast-rtdataNoLabel.csv'); %file names
     LoadRTFast(:,:,i) = dlmread(file, ',', 'G2..Z17');  %data portion in excel- excluding labels
end


%Read in the accuracy data
n = length(FasterSubj);
LoadAccFast = zeros(16,20,n);  %16 conditiion rows, 20 columns of data

for i = 1:n
     file = strcat(num2str(FasterSubj(i)),'-fast-accuracydataNoLabel.csv'); %file names
     LoadAccFast(:,:,i) = dlmread(file, ',', 'G2..Z17');  %data portion in excel- excluding labels
end



%% Longer condition

%Read in the RT data
n = length(LongerSubj);
LoadRTLong = zeros(16,20,n);  %16 conditiion rows, 20 columns of data

for i = 1:n
     file = strcat(num2str(LongerSubj(i)),'-long-rtdataNoLabel.csv'); %file names
     LoadRTLong(:,:,i) = dlmread(file, ',', 'G2..Z17');  %data portion in excel- excluding labels
end


%Read in the accuracy data
n = length(LongerSubj);
LoadAccLong = zeros(16,20,n);  %16 conditiion rows, 20 columns of data

for i = 1:n
     file = strcat(num2str(LongerSubj(i)),'-long-accuracydataNoLabel.csv'); %file names
     LoadAccLong(:,:,i) = dlmread(file, ',', 'G2..Z17');  %data portion in excel- excluding labels
end

%% Create .mat file 

%Change wd to the 2.Plotting-Matlab folder
%cd /SchlossVRL/2.Plotting-Matlab

%create structure for accuacy and RT data
Faster.LoadAcc = LoadAccFast;
Faster.LoadRT = LoadRTFast;

%create structure for accuacy and RT data
Longer.LoadAcc = LoadAccLong;
Longer.LoadRT = LoadRTLong;

Exp3.Longer = Longer;
Exp3.Faster = Faster;

%Save Exp3 as .mat file into this folder