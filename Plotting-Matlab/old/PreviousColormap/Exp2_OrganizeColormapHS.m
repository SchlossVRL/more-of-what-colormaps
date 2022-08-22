

%% CHECK OVERALL ACCURACY FOR INTERPRETING COLORMAPS

nHS = size(HS.LoadAcc,3);
AccCount = zeros(nHS,1);

for i = 1:nHS
    for row  = 1:32
        for col = 1:20
            if HS.LoadAcc(row,col,i) == 1
                AccCount(i,1) = AccCount(i,1)+1;
            end
        end
    end
end
Acc = AccCount/416; % 416 is total number of presented trials
    
% check if accuracy is > 90%
high = find(Acc > .9);

% Grab data for people who were greater that 90% accurate
HS.RT = HS.LoadRT(:,:,high);   % colormap task, RT 
HS.Acc = HS.LoadAcc(:,:,high); % colormap task, Accuracy    
HS.LocRT = HS.LoadHSlocRT(:,:,high);% hotspot location task, RT    
HS.Loc = HS.LoadHSloc(:,:,high);    % hotspot location task, Accuracy 


%% PRUNE RTs (+/- 2SD from mean for each subject)

[HS.MeanRT_HSmore, HS.MeanRT_HSboth] = PruneRTs_HS(HS.RT, HS.Acc);

%HS.MeanRT_HSmore has NaNs for trials not presented (if hotspot is less)
%Subject 13 had NAN for condition 28 because none of the 6 trials were valid
%(errors outlier RTs), so we replace that data point with the 
% grand mean of all their valid trials  
HS.MeanRT_HSboth(28,13) = 950.5674;

%% MAKE FIGURES


% BALANCED CUE IMAGES (hotspot presented equally as "more" and "less"). 
% HS.EqualOutput has 30 subj by 16 conditions. The 16 conditions are as
% follows: 1-8 is autumn color scale, 9-16 is viridus color scale
    % within each color scale 1-4 dark hotspot, 5-8 light hotspot
    % within each hot spot lightness 1-2 is "greater" hi, 3-4 is "greater" lo
    % within each "greater" position height, mapping is D+, l+
    % A_Dhs_Ghi_Dm, A_Dhs_Ghi_Lm, A_Dhs_Glo_Dm, A_Dhs_Glo_Lm, A_Lhs_Ghi_Dm, A_Lhs_Ghi_Lm, A_Lhs_Glo_Dm, A_:hs_Glo_Lm, 
    % V_Dhs_Ghi_Dm, V_Dhs_Ghi_Lm, V_Dhs_Glo_Dm, V_Dhs_Glo_Lm, V_Lhs_Ghi_Dm, V_Lhs_Ghi_Lm, V_Lhs_Glo_Dm, V_:hs_Glo_Lm 

[HS.EqualOutput] = PlotColormaps(HS.MeanRT_HSboth, 'HS', 'Autumn', 'Viridus', 22, 1050, 1300);
     
    HS_EqOut = [HS.EqualOutput];
    dlmwrite('Exp2_BalancedImg_out.csv', HS_EqOut)

% HOTSPOT MORE IMAGES (hotspot presented only as "more"
% Output has same structure as HS.EqualOutput, with NaNs for trials not
% presented
[HS.output] = PlotColormapsHS(HS.MeanRT_HSmore, 'HS', 'Autumn', 'Viridus', 2);
     
    HS_out = [HS.output(:, [1 3 6 8 9 11 14 16])]; %remove columns with NaNs because those trials were not presented for the HS more condition
    dlmwrite('Exp2_HSmore_out.csv', HS_out)



%% HOTSPOT LOCATION

n  = size(HS.Loc,3);

%sets up a matrix indicating which side had the hotspot (1=left, 2=right)
HScode = repmat([1 1 1 1   2 2 2 2   2 2 2 2  1 1 1 1 ]', 2, 20);
HSfound = zeros(32,20,n);

%codes if participants selected the side with the hotspot (1=yes, 0=no)
for i = 1:n
    HSfound(:,:,i) = HScode == HS.Loc(:,:,i); 
end

%average over colormap, hotspot side, and exact repetitons
%rows are image type and columns are subjects
HSfoundAvg = squeeze(mean(HSfound,1));

HSfoundImg = mean(HSfoundAvg,2);
HSfoundTotalProp = mean(mean(HSfoundAvg,2),1);

[HSLocRTSubj] = PruneRTs_HSLoc(HS.LocRT, HSfound);
PlotHSlocation(HSLocRTSubj, 'Exp2', 'Autumn', 'Viridis', 20000, 400, 600);


