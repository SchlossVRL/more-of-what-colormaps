% "Faster" is the condition referred to as "hotspot" in the paper
% "Longer" is the condition referred to as "scrambled" in the paper

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

%CGhigh = find(CGpropAcc > .9);

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
% 
% [FasterNoLab.output, FasterNoLab.output2, FasterNoLab.output4] = PlotColormaps_MAS( FasterNoLab.AvgRTsubj, ' Faster', 'Blue', 'Hot', 1, 1000, 1600);
% [LongerNoLab.output, LongerNoLab.output2, LongerNoLab.output4] = PlotColormaps_MAS( LongerNoLab.AvgRTsubj, ' Longer', 'Blue', 'Hot', 11, 1000, 1600);

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
%  dlmwrite('Exp3_SPSS_outAll-dMoreConcept-v3.csv', SPSSNoLab_outAll)

%  
% %DATA AVERAGED OVER THE LEGEND TEXT
% FasterNoLabCond2 = zeros(length(FasterNoLab.output2),1)
% FasterNoLab.outputNoLeg = [FasterNoLabCond2, FasterNoLab.output2]
% LongerNoLabCond2 = ones(length(LongerNoLab.output2),1)
% LongerNoLab.outputNoLeg = [LongerNoLabCond2, LongerNoLab.output2]
% 
% SPSSNoLab_outNoLeg = [FasterNoLab.outputNoLeg;  LongerNoLab.outputNoLeg]
% 
% %header = {'Condition','Blue_Dm','Blue_Lm','Hot_Dm','Hot_Lm'};
% %SPSS_out = [header2; SPSS_out]
%  dlmwrite('Exp3_SPSS_outNoLeg-dMoreQuant.csv', SPSSNoLab_outNoLeg)
% 
% 
%  %DATA AVERAGED OVER THE COLORSCALE- Faster.output4
% 
% FasterNoLabCond4 = zeros(length(FasterNoLab.output4),1);
% FasterNoLab.outputNoCS = [FasterNoLabCond4, FasterNoLab.output4];
% LongerNoLabCond4 = ones(length(LongerNoLab.output4),1);
% LongerNoLab.outputNoCS = [LongerNoLabCond4, LongerNoLab.output4];
% %order: (4 columns-  More#Hi-D+#, More#Hi-L+#, More#Lo-D+#, More#Lo-L+)
% % Legend Orientation, then encoded mapping
% 
% SPSSNoLab_outNoCS = [FasterNoLab.outputNoCS;  LongerNoLab.outputNoCS]
% 
%  dlmwrite('Exp3_SPSS_outNoCS-dMoreQuant.csv', SPSSNoLab_outNoCS)
