
%% CHECK OVERALL ACCURACY

% Load conditions to check accuracy
Rankacc = [Exp5.Rank.LoadAcc];
Indexacc =[Exp5.Index.LoadAcc];

% calculate overall accruacy
RankpropAcc = squeeze(mean(mean(Rankacc,1),2));
IndexpropAcc = squeeze(mean(mean(Indexacc,1),2));

% check if accuracy is > 90%
Rankhigh = find(RankpropAcc > .9);
Indexhigh = find(IndexpropAcc > .9);

% Grab RT data from people who were greater that 90% accurate
Rank.RT = Exp5.Rank.LoadRT(:,:,Rankhigh);    
Index.RT = Exp5.Index.LoadRT(:,:,Indexhigh);    

% Grab accuracy data from people who were greater that 90% accurate
Rank.Acc = Exp5.Rank.LoadAcc(:,:,Rankhigh);    
Index.Acc = Exp5.Index.LoadAcc(:,:,Indexhigh);    

%% PRUNE RTs

[Rank.AvgRTsubj] = PruneRTs_MAS(Rank.RT, Rank.Acc);
[Index.AvgRTsubj] = PruneRTs_MAS(Index.RT, Index.Acc);

%% MAKE FIGURES FOR COLORMAP TASK
% % UNCOMMENT HERE TO THE END TO CREATE OUTPUT FILES FOR SPSS

% [Rank.output, Rank.output2, Rank.output4] = PlotColormapsRank_MAS( Rank.AvgRTsubj, ' Rank', 'Blue', 'Hot', 1, 1100, 1600);
%[Index.output, Index.output2, Index.output4] = PlotColormapsRank_MAS( Index.AvgRTsubj, ' Index', 'Blue', 'Hot', 11, 1100, 1600);

%% Create output for SPSS ANOVAs

%FULL DATA SET - Rank.output
%RankCond = zeros(length(Rank.output),1);
%Rank.outputAll = [RankCond, Rank.output];
% IndexCond = ones(length(Index.output),1);
% Index.outputAll = [IndexCond, Index.output];
% 
% SPSS5_outAll = [Rank.outputAll;  Index.outputAll]

% % order: (8 columns-  Blue-More#Hi-D+#, Blue-More#Hi-L+#, Blue-More#Lo-D+#, Blue-More#Lo-L+, Hot-More#Hi-D+#, Hot-More#Hi-L+#, Hot-More#Lo-D+#, Hot-More#Lo-L+))
% % Colorscale, then Legend Orientation, then encoded mapping
% %header = {'Condition','Blue_tHi_Dm','Blue_tHi_Lm','Blue_tLo_Dm','Blue_tLo_Lm','Hot_tHi_Dm','Hot_tHi_Lm','Hot_tLo_Dm','Hot_tLo_Lm'};
% %SPSS_out = [header2; SPSS_out]
% 
%  dlmwrite('Exp5_SPSS_outAll-dMoreConcept-v3.csv', SPSS5_outAll)
