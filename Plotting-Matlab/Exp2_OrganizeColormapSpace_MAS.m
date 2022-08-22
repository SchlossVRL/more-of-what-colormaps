
%% CHECK OVERALL ACCURACY

% combine grid and concentric conditions to check accuracy
Sloweracc = [Exp2.Slower.LoadAcc];
Shorteracc =[Exp2.Shorter.LoadAcc];

% calculate overall accruacy
SlowerpropAcc = squeeze(mean(mean(Sloweracc,1),2));
ShorterpropAcc = squeeze(mean(mean(Shorteracc,1),2));

% check if accuracy is > 90%
Slowerhigh = find(SlowerpropAcc > .9);
Shorterhigh = find(ShorterpropAcc > .9);

% Grab RT data from people who were greater that 90% accurate
Slower.RT = Exp2.Slower.LoadRT(:,:,Slowerhigh);    
Shorter.RT = Exp2.Shorter.LoadRT(:,:,Shorterhigh);    

% Grab accuracy data from people who were greater that 90% accurate
Slower.Acc = Exp2.Slower.LoadAcc(:,:,Slowerhigh);    
Shorter.Acc = Exp2.Shorter.LoadAcc(:,:,Shorterhigh);    

%% PRUNE RTs

[Slower.AvgRTsubj] = PruneRTs_MAS(Slower.RT, Slower.Acc);
[Shorter.AvgRTsubj] = PruneRTs_MAS(Shorter.RT, Shorter.Acc);

%% MAKE FIGURES FOR COLORMAP TASK
% 
%  [Slower.output, Slower.output2, Slower.output4] = PlotColormaps_MAS( Slower.AvgRTsubj, ' Slower', 'Blue', 'Hot', 1, 1000, 1600);
%  [Shorter.output, Shorter.output2, Shorter.output4] = PlotColormaps_MAS( Shorter.AvgRTsubj, ' Shorter', 'Blue', 'Hot', 11, 1000, 1600);

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

% dlmwrite('Exp1_Scrambled_out.csv', Grid_out)
% dlmwrite('Exp1_Hotspot_out.csv', Conc_out)

%% Create output for SPSS ANOVAs

% %FULL DATA set
% SlowerCond = zeros(length(Slower.output),1);
% Slower.outputAll = [SlowerCond, Slower.output];
% ShorterCond = ones(length(Shorter.output),1);
% Shorter.outputAll = [ShorterCond, Shorter.output];
% 
% SPSS_outAll = [Slower.outputAll;  Shorter.outputAll];
% 
%  dlmwrite('Exp2_SPSS_outAll-dMoreConcept-v3.csv', SPSS_outAll);

%    
% %  %DATA AVERAGED OVER THE LEGEND TEXT
% SlowerCond2 = zeros(length(Slower.output2),1);
% Slower.outputNoLeg = [SlowerCond2, Slower.output2];
% ShorterCond2 = ones(length(Shorter.output2),1);
% Shorter.outputNoLeg = [ShorterCond2, Shorter.output2];
% 
% SPSS_outNoLeg = [Slower.outputNoLeg;  Shorter.outputNoLeg];
% 
%  dlmwrite('Exp2_SPSS_outNoLeg-dMoreQuant.csv', SPSS_outNoLeg);



%  %DATA AVERAGED OVER THE COLORSCALE- Slower.output4

% SlowerCond4 = zeros(length(Slower.output4),1);
% Slower.outputNoCS = [SlowerCond4, Slower.output4];
% ShorterCond4 = ones(length(Shorter.output4),1);
% Shorter.outputNoCS = [ShorterCond4, Shorter.output4];
% %order: (4 columns-  More#Hi-D+#, More#Hi-L+#, More#Lo-D+#, More#Lo-L+)
% % Legend Orientation, then encoded mapping
% 
% SPSS_outNoCS = [Slower.outputNoCS;  Shorter.outputNoCS]
% 
%  dlmwrite('Exp2_SPSS_outNoCS-dMoreQuant.csv', SPSS_outNoCS)
