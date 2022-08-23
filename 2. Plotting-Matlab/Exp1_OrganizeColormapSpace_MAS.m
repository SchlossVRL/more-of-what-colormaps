
%% CHECK OVERALL ACCURACY

% Load conditions to check accuracy
Faster1acc = [Exp1.Faster.LoadAcc];
Longer1acc = [Exp1.Longer.LoadAcc];

% calculate overall accruacy
Faster1propAcc = squeeze(mean(mean(Faster1acc,1),2));
Longer1propAcc = squeeze(mean(mean(Longer1acc,1),2));

% check if accuracy is > 90%
Faster1high = find(Faster1propAcc > .9);
Longer1high = find(Longer1propAcc > .9);

% Grab RT data from people who were greater that 90% accurate
Faster1.RT = Exp1.Faster.LoadRT(:,:,Faster1high);    
Longer1.RT = Exp1.Longer.LoadRT(:,:,Longer1high);    

% Grab accuracy data from people who were greater that 90% accurate
Faster1.Acc = Exp1.Faster.LoadAcc(:,:,Faster1high);    
Longer1.Acc = Exp1.Longer.LoadAcc(:,:,Longer1high);    

%% PRUNE RTs

[Faster1.AvgRTsubj] = PruneRTs_MAS(Faster1.RT, Faster1.Acc);
[Longer1.AvgRTsubj] = PruneRTs_MAS(Longer1.RT, Longer1.Acc);

%% Create .output values (during figure making process)
% UNCOMMENT HERE TO THE END TO CREATE OUTPUT FILES FOR SPSS

% [Faster1.output, Faster1.output2, Faster1.output4] = PlotColormaps_MAS( Faster1.AvgRTsubj, ' Faster', 'Blue', 'Hot', 1, 1000, 1600);
% [Longer1.output, Longer1.output2, Longer1.output4] = PlotColormaps_MAS( Longer1.AvgRTsubj, ' Longer', 'Blue', 'Hot', 11, 1000, 1600);


%% Create output for SPSS ANOVAs

%FULL DATA SET - Faster.output
% Faster1Cond = zeros(length(Faster1.output),1)
% Faster1.outputAll = [Faster1Cond, Faster1.output]
% Longer1Cond = ones(length(Longer1.output),1)
% Longer1.outputAll = [Longer1Cond, Longer1.output]
% 
% SPSS1_outAll = [Faster1.outputAll;  Longer1.outputAll]
% % order: (8 columns-  Blue-More#Hi-D+#, Blue-More#Hi-L+#, Blue-More#Lo-D+#, Blue-More#Lo-L+, Hot-More#Hi-D+#, Hot-More#Hi-L+#, Hot-More#Lo-D+#, Hot-More#Lo-L+))
% % Colorscale, then Legend Orientation, then encoded mapping
% 
% %header = {'Condition','Blue_tHi_Dm','Blue_tHi_Lm','Blue_tLo_Dm','Blue_tLo_Lm','Hot_tHi_Dm','Hot_tHi_Lm','Hot_tLo_Dm','Hot_tLo_Lm'};
% %SPSS_out = [header2; SPSS_out]
% 
% % dlmwrite('Exp1_SPSS_outAll.csv', SPSS1_outAll)

