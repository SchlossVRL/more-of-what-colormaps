% load in data & organize into a .mat file for RT & accuracy

%Set WD to the 1.Organizing-R folder
%cd /SchlossVRL/1.Organizing-R/Exp5-RankIndex-Health-Labels

%Update the number of subjects 
RankSubj = [1:30]; 
IndexSubj = [1:30];


%% Rank condition

%Read in the RT data
n = length(RankSubj);
LoadRTRank = zeros(16,20,n);  %16 conditiion rows, 20 columns of data

for i = 1:n
     file = strcat(num2str(RankSubj(i)),'-rank-Health-rtdata.csv'); %file names
     LoadRTRank(:,:,i) = dlmread(file, ',', 'G2..Z17');  %data portion in excel- excluding labels
end


%Read in the accuracy data
n = length(RankSubj);
LoadAccRank = zeros(16,20,n);  %16 condition rows, 20 columns of data

for i = 1:n
     file = strcat(num2str(RankSubj(i)),'-rank-Health-accuracydata.csv'); %file names
     LoadAccRank(:,:,i) = dlmread(file, ',', 'G2..Z17');  %data portion in excel- excluding labels
end



%% Index condition

%Read in the RT data
n = length(IndexSubj);
LoadRTIndex = zeros(16,20,n);  %16 conditiion rows, 20 columns of data

for i = 1:n
     file = strcat(num2str(IndexSubj(i)),'-index-Health-rtdata.csv'); %file names
     LoadRTIndex(:,:,i) = dlmread(file, ',', 'G2..Z17');  %data portion in excel- excluding labels
end


%Read in the accuracy data
n = length(IndexSubj);
LoadAccIndex = zeros(16,20,n);  %16 conditiion rows, 20 columns of data

for i = 1:n
     file = strcat(num2str(IndexSubj(i)),'-index-Health-accuracydata.csv'); %file names
     LoadAccIndex(:,:,i) = dlmread(file, ',', 'G2..Z17');  %data portion in excel- excluding labels
end

%% Create .mat file 

%Change wd to the 2.Plotting-Matlab folder
%cd /SchlossVRL/2.Plotting-Matlab

%create structure for accuacy and RT data
Rank.LoadAcc = LoadAccRank;
Rank.LoadRT = LoadRTRank;

%create structure for accuacy and RT data
Index.LoadAcc = LoadAccIndex;
Index.LoadRT = LoadRTIndex;

Exp5.Index = Index;
Exp5.Rank = Rank;

%Save Exp5 as .mat file into this folder