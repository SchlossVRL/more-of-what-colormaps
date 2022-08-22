
%% CHECK OVERALL ACCURACY

nHSSmall = size(HSSmall.LoadAcc,3);
AccCount = zeros(nHSSmall,1);

for i = 1:nHSSmall
    for row  = 1:32
        for col = 1:20
            if HSSmall.LoadAcc(row,col,i) == 1
                AccCount(i,1) = AccCount(i,1)+1;
            end
        end
    end
end
Acc = AccCount/416; % 416 is total number of presented trials
    
% check if accuracy is > 90%
high = find(Acc > .9);

% Grab data from people who were greater that 90% accurate
HSSmall.RT = HSSmall.LoadRT(:,:,high);    % colormap task, RT 
HSSmall.Acc = HSSmall.LoadAcc(:,:,high);  % colormap task, Accuracy   

HSSmall.LocRT = HSSmall.LoadHSlocRT(:,:,high);  % hotspot location task, RT 
HSSmall.Loc = HSSmall.LoadHSloc(:,:,high); % hotspot location accuracy, RT 
    %take out the first person because we don't have data from them
    HSSmall.LocRT = HSSmall.LocRT(:,:,2:30); 
    HSSmall.Loc = HSSmall.Loc(:,:,2:30); 
    


%% PRUNE RTs (+/- 2SD from mean for each subject)
 
[HSSmall.MeanRT_HSmore, HSSmall.MeanRT_HSboth] = PruneRTs_HS(HSSmall.RT, HSSmall.Acc);


%% MAKE FIGURES FOR COLORMAP TASK

% Balanced cue images
[HSSmall.EqualOutput] = PlotColormaps(HSSmall.MeanRT_HSboth, 'HHSmall','Hot', 'Viridis', 44, 1050, 1300);

    HSSmall_EqOut = [HSSmall.EqualOutput];
    dlmwrite('Exp4_BalancedImg_out.csv', HSSmall_EqOut)

% Hotspot more images
[HSSmall.output] = PlotColormapsHS(HSSmall.MeanRT_HSmore, 'HHSsmall', 'Hot', 'Viridis', 4);
 
    HSSmall_out = [HSSmall.output(:, [1 3 6 8 9 11 14 16])]; %remove columns with NaNs because those trials were not presented for the HS more condition
    dlmwrite('Exp4_HSmore_out.csv',  HSSmall_out)
 

  

%% HOTSPOT LOCATION

n  = size(HSSmall.Loc,3);

%sets up a matrix indicating which side had the hotspot (1=left, 2=right)
HScode = repmat([1 1 1 1   2 2 2 2   2 2 2 2  1 1 1 1 ]', 2, 20);
HSSmallfound = zeros(32,20,n);

%codes if participants selected the side with the hotspot (1=yes, 0=no)
for i = 1:n
    HSSmallfound(:,:,i) = HScode == HSSmall.Loc(:,:,i); 
end

%average over colormap, hotspot side, and exact repetitons
%rows are image type and columns are subjects
HSSmallfoundAvg = squeeze(mean(HSSmallfound,1));

HSSmallfoundImg = mean(HSSmallfoundAvg,2);
HSSmallfoundTotalProp = mean(mean(HSSmallfoundAvg,2),1);

[HSSmallLocRTSubj] = PruneRTs_HSLoc(HSSmall.LocRT, HSSmallfound);

PlotHSlocation(HSSmallLocRTSubj, 'Exp4', 'Hot', 'Viridis', 40000, 400, 600);






