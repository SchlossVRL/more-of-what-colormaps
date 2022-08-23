
%%  More of what: dissociating effects of conceptual and numeric mappings on interpreting colormap data visualizations
% Alexis Soto, Melissa A. Schoenlein, Karen B. Schloss

%% 1. Load in data individual subject data

% Run the Exp#_LoadInData_MAS.m file for each experiment
 %For each experiment, save the Exp#.mat file that is created


%% 2. Load in experiment averaged data

%COLORMAP WHAT
%Within the 16 rows, rows 1-8 is 'blue', 9-16 is 'hot' color scale. 
    % within each color scale, rows 1-4 is dark on the left, 5-8 is dark on the right.
    % within each lighntess side, rows 1-2 the scale is oreinted so dark high, 3-4 is dark low 
    % within each scale orientation, row 1 is target high, 2 is target low.    
% Columns are repititons (with different images). 
% 3rd dimension is participants 

    load Exp1.mat %Exp 1 - aliens faster/longer  w/ labels
    load Exp2.mat %Exp 2 - aliens slower/shorter w/ labels
    load Exp3.mat %Exp 3 - aliens faster/longer  NO labels
    load Exp4.mat %Exp 4 - soil   faster/longer  w/ labels
    load Exp5.mat %Exp 5 - health rank/index     w/ labels
    

%% 3. Organize data

  %Run the Exp#_OrganizeColormapSpace_MAS file for each experiment 
  %Requires PruneRTs_MAS.m function
        
  Exp1_OrganizeColormapSpace_MAS
  Exp2_OrganizeColormapSpace_MAS
  Exp3_OrganizeColormapSpace_MAS
  Exp4_OrganizeColormapSpace_MAS
  Exp5_OrganizeColormapSpace_MAS

   
%% 4. Make figures 

%Plotting congruency condition X lightness encoded mapping
PlotColormaps_MAS_CongXMapping(Faster1.AvgRTsubj, Longer1.AvgRTsubj, Slower.AvgRTsubj,Shorter.AvgRTsubj, FasterNoLab.AvgRTsubj, LongerNoLab.AvgRTsubj, FasterSoil.AvgRTsubj,LongerSoil.AvgRTsubj, Rank.AvgRTsubj, Index.AvgRTsubj, ' Faster', ' Slower', ' Rank', 'Blue', 'Hot', 1111, 1100, 1600);

%Plotting congruency condition X legend text position
PlotColormaps_MAS_CongXLegend(Faster1.AvgRTsubj, Longer1.AvgRTsubj, Slower.AvgRTsubj,Shorter.AvgRTsubj, FasterNoLab.AvgRTsubj, LongerNoLab.AvgRTsubj, FasterSoil.AvgRTsubj,LongerSoil.AvgRTsubj, Rank.AvgRTsubj, Index.AvgRTsubj, ' Faster', ' Slower', ' Rank', 'Blue', 'Hot', 2222, 1100, 1600);

%Plotting lightness encoded mapping X legend orientation X congruency condition (averaged over color scale)
PlotColormaps_MAS_CongXMappingXLegend( Faster1.AvgRTsubj, Slower.AvgRTsubj, FasterNoLab.AvgRTsubj, FasterSoil.AvgRTsubj,Rank.AvgRTsubj, ' Faster', ' Slower', ' Rank', 'Blue', 'Hot', 1100, 1100, 1600);
PlotColormaps_MAS_CongXMappingXLegend( Longer1.AvgRTsubj, Shorter.AvgRTsubj, LongerNoLab.AvgRTsubj, LongerSoil.AvgRTsubj,Index.AvgRTsubj,' Longer', ' Shorter', ' Index', 'Blue', 'Hot', 1110, 1100, 1600);

%Plotting fully expanded: congruency condition X lightness encoded mapping X legend text position X colorscale (In Supplemental Material)
PlotColormaps_MAS_CongXMappingXLegendXScale( Faster1.AvgRTsubj, Slower.AvgRTsubj, FasterNoLab.AvgRTsubj, FasterSoil.AvgRTsubj,Rank.AvgRTsubj, ' Faster', ' Slower', ' Rank', 'Blue', 'Hot',3333, 1100, 1700);
PlotColormaps_MAS_CongXMappingXLegendXScale( Longer1.AvgRTsubj, Shorter.AvgRTsubj, LongerNoLab.AvgRTsubj, LongerSoil.AvgRTsubj,Index.AvgRTsubj,' Longer', ' Shorter', ' Index', 'Blue', 'Hot', 4444, 1100, 1700);


