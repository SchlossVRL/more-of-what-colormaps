
%% CHECK OVERALL ACCURACY

% Load conditions to check accuracy
Faster1acc = [Exp1.Faster.LoadAcc];
Longer1acc =[Exp1.Longer.LoadAcc];

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

%% MAKE FIGURES FOR COLORMAP TASK
% 
% [Faster1.output, Faster1.output2, Faster1.output4] = PlotColormaps_MAS( Faster1.AvgRTsubj, ' Faster', 'Blue', 'Hot', 1, 1000, 1600);
% [Longer1.output, Longer1.output2, Longer1.output4] = PlotColormaps_MAS( Longer1.AvgRTsubj, ' Longer', 'Blue', 'Hot', 11, 1000, 1600);

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

%FULL DATA SET - Faster.output
% Faster1Cond = zeros(length(Faster1.output),1)
% Faster1.outputAll = [Faster1Cond, Faster1.output]
% Longer1Cond = ones(length(Longer1.output),1)
% Longer1.outputAll = [Longer1Cond, Longer1.output]
% 
% SPSS1_outAll = [Faster1.outputAll;  Longer1.outputAll]
% % order: (8 columns-  Blue-More#Hi-D+#, Blue-More#Hi-L+#, Blue-More#Lo-D+#, Blue-More#Lo-L+, Hot-More#Hi-D+#, Hot-More#Hi-L+#, Hot-More#Lo-D+#, Hot-More#Lo-L+))
% % Colorscale, then Legend Orientation, then encoded mapping
% %header = {'Condition','Blue_tHi_Dm','Blue_tHi_Lm','Blue_tLo_Dm','Blue_tLo_Lm','Hot_tHi_Dm','Hot_tHi_Lm','Hot_tLo_Dm','Hot_tLo_Lm'};
% %SPSS_out = [header2; SPSS_out]
% 
%  dlmwrite('Exp1_SPSS_outAll-dMoreConcept-v3.csv', SPSS1_outAll)
% 
% %  
%  %DATA AVERAGED OVER THE LEGEND TEXT - Faster.output2
% Faster1Cond2 = zeros(length(Faster1.output2),1)
% Faster1.outputNoLeg = [Faster1Cond2, Faster1.output2]
% Longer1Cond2 = ones(length(Longer1.output2),1)
% Longer1.outputNoLeg = [Longer1Cond2, Longer1.output2]
% 
% SPSS1_outNoLeg = [Faster1.outputNoLeg;  Longer1.outputNoLeg]
% % %order: (4 columns- Blue-D+#, Blue-L+#, Hot-D+#, Hot-L+)
% % Colorscale, then encoded mapping
% 
% %header2 = {'Condition','Blue_Dm','Blue_Lm','Hot_Dm','Hot_Lm'};
% %SPSS_outNoLeg = [header2; num2str(SPSS_outNoLeg)]
%  dlmwrite('Exp1_SPSS_outNoLeg-dMoreQuant.csv', SPSS1_outNoLeg)
% 
% 
%  %DATA AVERAGED OVER THE COLORSCALE- Faster.output4
% 
% Faster1Cond4 = zeros(length(Faster1.output4),1);
% Faster1.outputNoCS = [Faster1Cond4, Faster1.output4];
% Longer1Cond4 = ones(length(Longer1.output4),1);
% Longer1.outputNoCS = [Longer1Cond4, Longer1.output4];
% %order: (4 columns-  More#Hi-Dm, More#Hi-Lm, More#Lo-Dm, More#Lo-Lm)
% % Legend Orientation, then encoded mapping
% 
% SPSS1_outNoCS = [Faster1.outputNoCS;  Longer1.outputNoCS]
% 
%  dlmwrite('Exp1_SPSS_outNoCS-dMoreQuant.csv', SPSS1_outNoCS)