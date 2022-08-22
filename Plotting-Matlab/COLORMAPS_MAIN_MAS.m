
%% Load in data
%COLORMAP WHAT
% within the 16 rows, 1-8 is 'blue', 9-16 is 'hot' color scale. 
    % within each color scale, 1-4 is dark on the left, 5-8 is dark on the right.
    % within each lighntess side, 1-2 the scale is oreinted so dark high, 3-4 is dark low 
    % within each scale orientation, 1 is target high, 2 is target low.    
% columns are repititons (with different images). 
% 3rd dimension is participants 

%% Load in Data
% DONT FORGET to save the Exp.mat file from the loadinDATA_MAS script!

    load Exp1.mat %Exp 1 - aliens faster/longer  w/ labels
    load Exp2.mat %Exp 2 - aliens slower/shorter w/ labels
    load Exp3.mat %Exp 3 - aliens faster/longer  NO labels
    load Exp4.mat %Exp 4 - soil   faster/longer  w/ labels
    load Exp5.mat %Exp 5 - health rank/index     w/ labels
    

%% Organize data
  Exp1_OrganizeColormapSpace_MAS
  Exp2_OrganizeColormapSpace_MAS
  Exp3_OrganizeColormapSpace_MAS
  Exp4_OrganizeColormapSpace_MAS
  Exp5_OrganizeColormapSpace_MAS

    % Functions needed
        % PruneRTs_MAS 
        % PlotColormaps_MAS


%% MAKE FIGURES FOR All the data (Run each experiment file first first)

%Plotting congruency condition X encoded mapping
PlotColormaps_MAS_CongrXMapping(Faster1.AvgRTsubj, Longer1.AvgRTsubj, Slower.AvgRTsubj,Shorter.AvgRTsubj, FasterNoLab.AvgRTsubj, LongerNoLab.AvgRTsubj, FasterSoil.AvgRTsubj,LongerSoil.AvgRTsubj, Rank.AvgRTsubj, Index.AvgRTsubj, ' Faster', ' Slower', ' Rank', 'Blue', 'Hot', 1111, 1100, 1600);

%Plotting congruency condition X legend text position
PlotColormaps_MAS_CongXLegend(Faster1.AvgRTsubj, Longer1.AvgRTsubj, Slower.AvgRTsubj,Shorter.AvgRTsubj, FasterNoLab.AvgRTsubj, LongerNoLab.AvgRTsubj, FasterSoil.AvgRTsubj,LongerSoil.AvgRTsubj, Rank.AvgRTsubj, Index.AvgRTsubj, ' Faster', ' Slower', ' Rank', 'Blue', 'Hot', 2222, 1100, 1600);


%Plotting all 5 experiments for all conditions (encoded mapping,
%legend orientation, congruency condition- avearged over color scale
PlotColormaps_MAS_All( Faster1.AvgRTsubj, Slower.AvgRTsubj, FasterNoLab.AvgRTsubj, FasterSoil.AvgRTsubj,Rank.AvgRTsubj, ' Faster', ' Slower', ' Rank', 'Blue', 'Hot', 1100, 1100, 1600);
PlotColormaps_MAS_All( Longer1.AvgRTsubj, Shorter.AvgRTsubj, LongerNoLab.AvgRTsubj, LongerSoil.AvgRTsubj,Index.AvgRTsubj,' Longer', ' Shorter', ' Index', 'Blue', 'Hot', 1110, 1100, 1600);

%%
%Plotting congruency condition X encoded mapping X legend text position X
%colorscale 
PlotColormaps_MAS_CongXMappingXLegendXScale( Faster1.AvgRTsubj, Slower.AvgRTsubj, FasterNoLab.AvgRTsubj, FasterSoil.AvgRTsubj,Rank.AvgRTsubj, ' Faster', ' Slower', ' Rank', 'Blue', 'Hot',3333, 1100, 1700);
PlotColormaps_MAS_CongXMappingXLegendXScale( Longer1.AvgRTsubj, Shorter.AvgRTsubj, LongerNoLab.AvgRTsubj, LongerSoil.AvgRTsubj,Index.AvgRTsubj,' Longer', ' Shorter', ' Index', 'Blue', 'Hot', 4444, 1100, 1700);


%% looking at single participants
%load Exp1Single.mat  %Single participants 
%Exp1 = Exp1Single

