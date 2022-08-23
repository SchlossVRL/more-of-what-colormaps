# More of what: dissociating effects of conceptual and numeric mappings on interpreting colormap data visualizations

_Alexis Soto, Melissa A. Schoenlein, Karen B. Schloss_


## FOLDER: 2. Plotting-Matlab

### Data files

`Exp1.mat`, `Exp2.mat`, `Exp3.mat`, `Exp4.mat`, `Exp5.mat`: store processed data from Exp#_LoadInData_MAS.m files. Used as input into Exp#_OrganizeColormapSpace_MAS.m files


### Analysis and plotting files

`COLORMAPS_MAIN_MAS.m`: main MATLAB script that calls sub-files/functions to process and plot data

`Exp1_LoadInData_MAS.m`, `Exp2_LoadInData_MAS.m`, `Exp3_LoadInData_MAS.m`, `Exp4_LoadInData_MAS.m`, `Exp5_LoadInData_MAS.m`: processes individual experiment trial data created from the ColormapWhat-dataProcessing.R code. 

`Exp1_OrganizeColormapSpace_MAS.m`, `Exp2_OrganizeColormapSpace_MAS.m`,`Exp3_OrganizeColormapSpace_MAS.m`,`Exp4_OrganizeColormapSpace_MAS.m`,`Exp5_OrganizeColormapSpace_MAS.m`: Create .csv files used for SPSS analyses (currently commented out)

`PruneRTs_MAS.m`: processes RT data for each partiicpant. Identifies and excludes trials in which particpant's RT was +-2 SD from their mean 

`PlotColormaps_MAS_CongXLegend.m`: plots congruency condition X legend orientation (averaged over lightness encoded mapping and color scale)

`PlotColormaps_MAS_CongXMapping.m`:  plots congruency condition X lightness encoded mapping (averaged over congruency and color scale)

`PlotColormaps_MAS_CongXMappingXLegend.m`: plots congruency condition X lightness encoded mapping X legend orientation (averaged over color scale)

`PlotColormaps_MAS_CongXMappingXLegendXScale.m`: plots congruency condition X lightness encoded mapping X legend orientation X color scale


`PlotColormaps_MAS.m`: creates some plots, but primarily used for organizing data to create output files used for SPSS (need to uncomment some text in the Exp#_OrganizeColormapSpace_MAS.m files)

`PlotColormapsRank_MAS.m`: creates some plots, but primarily used for organizing data to create output files used for SPSS (need to uncomment some text in the Exp5_OrganizeColormapSpace_MAS.m files)


---

## Format of the exp#.mat files: 

1x1 struct with 2 fields (congruent, incongruent)
In each of those fields, there are 2 sub-fields (LoadACC, LoadRT)

LoadACC (16x20x30) & LoadRT (16x20x30):  16 colormap/legend/colorscales X 20 repitions X # of participants

    Within the 16 rows, rows 1-8 is 'blue', 9-16 is 'hot' color scale. 
        Within each color scale, rows 1-4 is dark on the left, 5-8 is dark on the right.
        Within each lighntess side, rows 1-2 the scale is oreinted so dark high, 3-4 is dark low 
        Within each scale orientation, row 1 is target high, 2 is target low. 
    Columns are repitions (with different images)
    3rd Dimension is participants

