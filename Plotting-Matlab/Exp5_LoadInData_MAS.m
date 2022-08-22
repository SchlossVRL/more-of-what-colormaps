% load in data into a .mat file for RT & accuracy

%Exp1_ColormapSpace-What.mat 

%Set WD - update to your device
%cd /Users/melan/Dropbox/Research/Experiments/ColormapWhat/Analyses/RankIndex-Health-labels %Melissa
cd /Users/alexissoto/Dropbox/ColormapWhat/Analyses/RankIndex-Health-labels %Lexi

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

%cd /Users/melan/Dropbox/Research/Experiments/ColormapWhat/Analyses/AnalyzingExperimentData/OrganzingPloting(Matlab)%Melissa
cd /Users/alexissoto/Dropbox/ColormapWhat/Analyses/AnalyzingExperimentData/OrganzingPloting(Matlab)%Lexi

%create structure for accuacy and RT data
Rank.LoadAcc = LoadAccRank
Rank.LoadRT = LoadRTRank


%create structure for accuacy and RT data
Index.LoadAcc = LoadAccIndex
Index.LoadRT = LoadRTIndex

Exp5.Index = Index
Exp5.Rank = Rank

%Save Exp5 as .mat file into this folder