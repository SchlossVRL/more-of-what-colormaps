
%% CHECK OVERALL ACCURACY

% combine grid and concentric conditions to check accuracy
FasterNoLabacc = [Exp3.Faster.LoadAcc];
LongerNoLabacc =[Exp3.Longer.LoadAcc];

% calculate overall accruacy
FasterNoLabpropAcc = squeeze(mean(mean(FasterNoLabacc,1),2));
LongerNoLabpropAcc = squeeze(mean(mean(LongerNoLabacc,1),2));

% check if accuracy is > 90%
FasterNoLabhigh = find(FasterNoLabpropAcc > .9);
LongerNoLabhigh = find(LongerNoLabpropAcc > .9);

% Grab RT data from people who were greater that 90% accurate
FasterNoLab.RT = Exp3.Faster.LoadRT(:,:,FasterNoLabhigh);    
LongerNoLab.RT = Exp3.Longer.LoadRT(:,:,LongerNoLabhigh);    

% Grab accuracy data from people who were greater that 90% accurate
FasterNoLab.Acc = Exp3.Faster.LoadAcc(:,:,FasterNoLabhigh);    
LongerNoLab.Acc = Exp3.Longer.LoadAcc(:,:,LongerNoLabhigh);    


%% PRUNE RTs

[FasterNoLab.AvgRTsubj] = PruneRTs_MAS(FasterNoLab.RT, FasterNoLab.Acc);
[LongerNoLab.AvgRTsubj] = PruneRTs_MAS(LongerNoLab.RT, LongerNoLab.Acc);

 %% MAKE FIGURES FOR COLORMAP TASK
% % UNCOMMENT HERE TO THE END TO CREATE OUTPUT FILES FOR SPSS

% [FasterNoLab.output, FasterNoLab.output2, FasterNoLab.output4] = PlotColormaps_MAS( FasterNoLab.AvgRTsubj, ' Faster', 'Blue', 'Hot', 1, 1000, 1600);
% [LongerNoLab.output, LongerNoLab.output2, LongerNoLab.output4] = PlotColormaps_MAS( LongerNoLab.AvgRTsubj, ' Longer', 'Blue', 'Hot', 11, 1000, 1600);

%% Create output for SPSS ANOVAs
% % 
%FULL DATA SET
% FasterNoLabCond = zeros(length(FasterNoLab.output),1)
% FasterNoLab.outputAll = [FasterNoLabCond, FasterNoLab.output]
% LongerNoLabCond = ones(length(LongerNoLab.output),1)
% LongerNoLab.outputAll = [LongerNoLabCond, LongerNoLab.output]
% 
% SPSSNoLab_outAll = [FasterNoLab.outputAll;  LongerNoLab.outputAll]
% 
% %header = {'Condition','Blue_tHi_Dm','Blue_tHi_Lm','Blue_tLo_Dm','Blue_tLo_Lm','Hot_tHi_Dm','Hot_tHi_Lm','Hot_tLo_Dm','Hot_tLo_Lm'};
% %SPSS_out = [header2; SPSS_out]
% 
%  dlmwrite('Exp3_SPSS_outAll.csv', SPSSNoLab_outAll)

