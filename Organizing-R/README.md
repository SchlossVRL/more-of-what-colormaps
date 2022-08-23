# More of what: dissociating effects of conceptual and numeric mappings on interpreting colormap data visualizations

_Alexis Soto, Melissa A. Schoenlein, Karen B. Schloss_



## FOLDER: Organizing-R

### Data files

`Exp1.csv`, `Exp2.csv`, `Exp3.csv`, `Exp4.csv`, `Exp5.csv`: store the individual trial data from the colormaps task


### Analysis and plotting file

`ColormapWhat-dataProcessing.R`: R script for cleaning and organizing raw data. Takes files above as inputs. Creates a csv file for each participant that gets stored in the respective subfolder

### Subfolders
Each subfolder stores the output of the ColormapWhat-dataProcessing.R code - two files for each participant, one for their accuracy and one for their response times. These files are used as input into the Plotting-Matlab-files. 


---


## Columns in the Exp#.csv data files contain: 
`prim_subject` unique participant ID & unique row 

`subjectID` unique participant ID

`conditionProto` condition participant was randomly assigned (incongruent = 0, congruent = 1) (Exp5 is flipped, see R code)

`trial_type` plugin used to present experiment (from jspysch)

`trial_index` which unique trial in the experiment (lower numbers correspond to trials seen earlier in the experiment)

`rt` response time

`responses` codes responses for color vision questions

`question_order` codes for instruction practice trials (instr) vs. experiment trials (exp), and whether it was a trial vs. feedback (-feed)

`stimulus` either text string (for instructions trials) or the legend numbers presented during a trial

`key_press` participant's response (left arrow key = 37, right arrow key = 39)

`correct` if participant's response was correct (correct = 1; incorrect = blank)

`prompt` if particpant answered incorrectly on the preceeding trial, the word "WRONG" appears

`stimLeft` colormap image presented 

`stimRight` legend color scale image presented

`targetSide` correct response (left correct = 0, right correct = 1)

`colorScale` which colorscale was presented (ColorBrewerBlue = 0, Hot = 1)

`darkSide` which side was dark (left dark = 0, right dark = 1)

`darkLegendOrient`which part of legend colorscale was dark (low dark = 0, high dark = 1)

`colormap` which of the 20 unique colormaps was presented (0-19), from different underlying data

`targetOrient` location of target on legend (target high = 0, target low = 1)





## Columns in the subfolders csv data files (created by running the R script) contain: 

`subjectID` unique participant ID

`conditionProtoStr` condition name participant was randomly assigned 

`colorScaleStr` which colorscale was presented (Blue, Hot)

`darkSideStr` which side was dark (dark-left, darkirght)

`darkLegendOrientStr`which part of legend colorscale was dark (dark-high, dark-low)

`targetOrientStr` location of target on legend (target-high, target-low)

For rtdata, `rt.0, rt.1,..., rt.19` column for response time for that particular colormap (0-19) 

For accuracydata, `correct.0, correct.1,..., correct.19` column for whether trial was correct for that particular colormap (0-19) (correct = 1, incorrect = 0)

