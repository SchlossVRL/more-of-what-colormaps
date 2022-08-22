

%% CHECK OVERALL ACCURACY

nHHS = size(HHS.LoadAcc,3);
AccCount = zeros(nHHS,1);

for i = 1:nHHS
    for row  = 1:32
        for col = 1:20
            if HHS.LoadAcc(row,col,i) == 1
                AccCount(i,1) = AccCount(i,1)+1;
            end
        end
    end
end
Acc = AccCount/416; % 416 is total number of presented trials
    
% check if accuracy is > 90%
high = find(Acc > .9);

% Grab data from people who were greater that 90% accurate
HHS.RT = HHS.LoadRT(:,:,high);   %Colormap task, RT
HHS.Acc = HHS.LoadAcc(:,:,high); %Colormap task, Accuracy   

HHS.LocRT = HHS.LoadHSlocRT(:,:,high); %Hotspot location task, RT   
HHS.Loc = HHS.LoadHSloc(:,:,high);  %Hotspot location task, Accuracy    



%% PRUNE RTs (+/- 2SD from mean for each subject)
[HHS.MeanRT_HSmore, HHS.MeanRT_HSboth] = PruneRTs_HS(HHS.RT, HHS.Acc);

%% MAKE FIGURES FOR COLORMAP TASK

% Balanced cue images 
[HHS.EqualOutput] = PlotColormaps(HHS.MeanRT_HSboth, 'HHS', 'Hot', 'Viridis', 33, 1050, 1300);

    HHS_EqOut = [HHS.EqualOutput];
    dlmwrite('Exp3_BalancedImg_out.csv', HHS_EqOut)

% Hotspot more images
[HHS.output] = PlotColormapsHS(HHS.MeanRT_HSmore, 'HHS', 'Hot', 'Viridis', 3);
 
    HHS_out = [HHS.output(:, [1 3 6 8 9 11 14 16])]; %remove columns with NaNs because those trials were not presented for the HS more condition
    dlmwrite('Exp3_HSmore_out.csv', HHS_out)

   
    
    
%% HOTSPOT LOCATION

n  = size(HHS.Loc,3);

%sets up a matrix indicating which side had the hotspot (1=left, 2=right)
HScode = repmat([1 1 1 1   2 2 2 2   2 2 2 2  1 1 1 1 ]', 2, 20);
HHSfound = zeros(32,20,n);

%codes if participants selected the side with the hotspot (1=yes, 0=no)
for i = 1:n
    HHSfound(:,:,i) = HScode == HHS.Loc(:,:,i); 
end

%average over colormap, hotspot side, and exact repetitons
%rows are image type and columns are subjects
HHSfoundAvg = squeeze(mean(HHSfound,1));

HHSfoundImg = mean(HHSfoundAvg,2);
HHSfoundTotalProp = mean(mean(HHSfoundAvg,2),1);

[HHSLocRTSubj] = PruneRTs_HSLoc(HHS.LocRT, HHSfound);
PlotHSlocation(HHSLocRTSubj, 'Exp3', 'Hot', 'Viridis', 30000, 400, 600);

