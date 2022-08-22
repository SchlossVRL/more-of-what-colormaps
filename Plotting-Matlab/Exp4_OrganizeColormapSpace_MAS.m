% "Faster" is the condition referred to as "hotspot" in the paper
% "Longer" is the condition referred to as "scrambled" in the paper


%% CHECK OVERALL ACCURACY

% Load conditions to check accuracy
FasterSoilacc = [Exp4.Faster.LoadAcc];
LongerSoilacc =[Exp4.Longer.LoadAcc];

% calculate overall accruacy
FasterSoilpropAcc = squeeze(mean(mean(FasterSoilacc,1),2));
LongerSoilpropAcc = squeeze(mean(mean(LongerSoilacc,1),2));

% check if accuracy is > 90%
FasterSoilhigh = find(FasterSoilpropAcc > .9);
LongerSoilhigh = find(LongerSoilpropAcc > .9);

% Grab RT data from people who were greater that 90% accurate
FasterSoil.RT = Exp4.Faster.LoadRT(:,:,FasterSoilhigh);    
LongerSoil.RT = Exp4.Longer.LoadRT(:,:,LongerSoilhigh);    

% Grab accuracy data from people who were greater that 90% accurate
FasterSoil.Acc = Exp4.Faster.LoadAcc(:,:,FasterSoilhigh);    
LongerSoil.Acc = Exp4.Longer.LoadAcc(:,:,LongerSoilhigh);    

%% PRUNE RTs

[FasterSoil.AvgRTsubj] = PruneRTs_MAS(FasterSoil.RT, FasterSoil.Acc);
[LongerSoil.AvgRTsubj] = PruneRTs_MAS(LongerSoil.RT, LongerSoil.Acc);

%% MAKE FIGURES FOR COLORMAP TASK

% [FasterSoil.output, FasterSoil.output2, FasterSoil.output4] = PlotColormaps_MAS( FasterSoil.AvgRTsubj, ' Faster', 'Blue', 'Hot', 1, 1000, 1600);
% [LongerSoil.output, LongerSoil.output2, LongerSoil.output4] = PlotColormaps_MAS( LongerSoil.AvgRTsubj, ' Longer', 'Blue', 'Hot', 11, 1000, 1600);

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
% 
%FULL DATA SET
% FasterSoilCond = zeros(length(FasterSoil.output),1)
% FasterSoil.outputAll = [FasterSoilCond, FasterSoil.output]
% LongerSoilCond = ones(length(LongerSoil.output),1)
% LongerSoil.outputAll = [LongerSoilCond, LongerSoil.output]
% 
% SPSSSoil_outAll = [FasterSoil.outputAll;  LongerSoil.outputAll]
% 
% %header = {'Condition','Blue_tHi_Dm','Blue_tHi_Lm','Blue_tLo_Dm','Blue_tLo_Lm','Hot_tHi_Dm','Hot_tHi_Lm','Hot_tLo_Dm','Hot_tLo_Lm'};
% %SPSS_out = [header2; SPSS_out]
% 
%  dlmwrite('Exp4_SPSS_outAll-dMoreConcept-v3.csv', SPSSSoil_outAll)

%  
%  %DATA AVERAGED OVER THE LEGEND TEXT
% FasterSoilCond2 = zeros(length(FasterSoil.output2),1)
% FasterSoil.outputNoLeg = [FasterSoilCond2, FasterSoil.output2]
% LongerSoilCond2 = ones(length(LongerSoil.output2),1)
% LongerSoil.outputNoLeg = [LongerSoilCond2, LongerSoil.output2]
% 
% SPSSSoil_outNoLeg = [FasterSoil.outputNoLeg;  LongerSoil.outputNoLeg]
% 
% %header2 = {'Condition','Blue_Dm','Blue_Lm','Hot_Dm','Hot_Lm'};
% %SPSS_outNoLeg = [header2; num2str(SPSS_outNoLeg)]
%  dlmwrite('Exp4_SPSS_outNoLeg-dMoreQuant.csv', SPSSSoil_outNoLeg)
% 
% 
%  %DATA AVERAGED OVER THE COLORSCALE- Faster.output4
% 
% FasterSoilCond4 = zeros(length(FasterSoil.output4),1);
% FasterSoil.outputNoCS = [FasterSoilCond4, FasterSoil.output4];
% LongerSoilCond4 = ones(length(LongerSoil.output4),1);
% LongerSoil.outputNoCS = [LongerSoilCond4, LongerSoil.output4];
% %order: (4 columns-  More#Hi-D+#, More#Hi-L+#, More#Lo-D+#, More#Lo-L+)
% % Legend Orientation, then encoded mapping
% 
% SPSSSoil_outNoCS = [FasterSoil.outputNoCS;  LongerSoil.outputNoCS]
% 
%  dlmwrite('Exp4_SPSS_outNoCS-dMoreQuant.csv', SPSSSoil_outNoCS)
