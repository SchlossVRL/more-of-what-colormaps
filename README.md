# More of what: dissociating effects of conceptual and numeric mappings on interpreting colormap data visualizations

_Alexis Soto, Melissa A. Schoenlein, Karen B. Schloss_

Abstract

More to come! 

---

## FOLDER: 1. Organizing-R

### Data files

`Exp1.csv`, `Exp2.csv`, `Exp3.csv`, `Exp4.csv`, `Exp5.csv`: store the individual trial data from the colormaps task


### Analysis file

`ColormapWhat-dataProcessing.R`: R script for cleaning and organizing raw data. Takes files above as inputs. Creates a csv file for each participant that gets stored in the respective subfolder

### Subfolders
Each subfolder stores the output of the ColormapWhat-dataProcessing.R code - two files for each participant, one for their accuracy and one for their response times. These files are used as input into the Exp#_LoadInData_MAS.m files. 



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



## FOLDER: 3. Analyzing-SPSS

`Exp1_SPSS_outAll.csv`, `Exp2_SPSS_outAll.csv`, `Exp3_SPSS_outAll.csv`,`Exp4_SPSS_outAll.csv`,`Exp5_SPSS_outAll.csv`: store response time data output from the Exp#_OrganizeColormapSpace_MAS.m files. Used for analyzing data. 


### Analysis file

`ColormapWhat-Analyses.sps` SPSS script file to run analyses. Uses above csv files as input 



## FOLDER: Stimuli-colormaps

Stores experiment colormap stimuli and legend colorscale stimuli
