
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
% 
% [Rank.output, Rank.output2, Rank.output4] = PlotColormapsRank_MAS( Rank.AvgRTsubj, ' Rank', 'Blue', 'Hot', 1, 1100, 1600);
% [Index.output, Index.output2, Index.output4] = PlotColormapsRank_MAS( Index.AvgRTsubj, ' Index', 'Blue', 'Hot', 11, 1100, 1600);

%%
%[Faster.output] = SinglePlotColormaps_MAS( Faster.AvgRTsubj, ' Faster', 'Blue', 'Hot', 1, 700, 1200);
%[Longer.output] = SinglePlotColormaps_MAS( Longer.AvgRTsubj, ' Longer', 'Blue', 'Hot', 11,700, 1400);


%[Grid.output_CG] = PlotColormaps( Grid.AvgRTsubj_CG, 'Grid (2nd)', 'Autumn', 'Viridis', 11,800, 1300);
%[Conc.output_GC] = PlotColormaps( Conc.AvgRTsubj_GC, 'Conc. (2nd)', 'Autumn', 'Viridis', 111, 800, 1300);
%[Conc.output_CG] = PlotColormaps( Conc.AvgRTsubj_CG, 'Conc. (1st)', 'Autumn', 'Viridis', 1111, 800, 1300);

%including data from both blocks in a single figure
%PlotColormaps_MAS([Faster.AvgRTsubj, Longer.AvgRTsubj], 'Faster & Longer', 'Autumn', 'Viridis', 101, 950, 1100);
%PlotColormaps([Longer.AvgRTsubj_GC, Conc.AvgRTsubj_CG], 'Conc (both)', 'Autumn', 'Viridis', 1011, 950, 1100);

%Grid_out = [Grid.output_GC; Grid.output_CG]; %60 subjects x 16 conditions
%Conc_out = [Conc.output_CG; Conc.output_GC]; %60 subjects x 16 conditions

%% Create output for SPSS ANOVAs

%FULL DATA SET - Rank.output
% RankCond = zeros(length(Rank.output),1);  %MELISSA WHY SUBTRACT ONE? 
% Rank.outputAll = [RankCond, Rank.output];
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

%  
%  %DATA AVERAGED OVER THE LEGEND TEXT - Rank.output2
% RankCond2 = zeros(length(Rank.output2),1)
% Rank.outputNoLeg = [RankCond2, Rank.output2]
% IndexCond2 = ones(length(Index.output2),1)
% Index.outputNoLeg = [IndexCond2, Index.output2]
% 
% SPSS5_outNoLeg = [Rank.outputNoLeg;  Index.outputNoLeg]
% % %order: (4 columns- Blue-D+#, Blue-L+#, Hot-D+#, Hot-L+)
% % Colorscale, then encoded mapping
% 
% %header2 = {'Condition','Blue_Dm','Blue_Lm','Hot_Dm','Hot_Lm'};
% %SPSS_outNoLeg = [header2; num2str(SPSS_outNoLeg)]
%  dlmwrite('Exp5_SPSS_outNoLeg-dMoreQuant.csv', SPSS5_outNoLeg)
% 
% 
%  %DATA AVERAGED OVER THE COLORSCALE- Rank.output4
% 
% RankCond4 = zeros(length(Rank.output4),1);
% Rank.outputNoCS = [RankCond4, Rank.output4];
% IndexCond4 = ones(length(Index.output4),1);
% Index.outputNoCS = [IndexCond4, Index.output4];
% %order: (4 columns-  More#Hi-D+#, More#Hi-L+#, More#Lo-D+#, More#Lo-L+)
% % Legend Orientation, then encoded mapping
% 
% SPSS5_outNoCS = [Rank.outputNoCS;  Index.outputNoCS]
% 
%  dlmwrite('Exp5_SPSS_outNoCS-dMoreQuant.csv', SPSS5_outNoCS)