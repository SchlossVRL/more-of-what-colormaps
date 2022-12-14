* Encoding: UTF-8.

* More of what: dissociating effects of conceptual and numeric mappings on interpreting colormap data visualizations
*Alexis Soto, Melissa A. Schoenlein, Karen B. Schloss

*------------------------------------------------------------
*FILES: 
*    Exp1_SPSS_outAll.csv
*    Exp2_SPSS_outAll.csv
*    Exp3_SPSS_outAll.csv
*    Exp4_SPSS_outAll.csv
*    Exp5_SPSS_outAll.csv
*------------------------------------------------------------


*All experiments: Full model
*mixed design ANOVA: 2 conditions (congruent vs. incongruent) x 2 encoded mappings (dark-more concept vs. light-more concept) x 2 color scales (Hot vs. Blue) x 2 legend orientation(more concept high vs. more concept low).
GLM Blue_tHi_Dm Blue_tHi_Lm Blue_tLo_Dm Blue_tLo_Lm Hot_tHi_Dm Hot_tHi_Lm Hot_tLo_Dm Hot_tLo_Lm BY
    Condition
  /WSFACTOR=ColorScale 2 Polynomial LegendOrientation 2 Polynomial EncodedMapping 2 Polynomial
  /METHOD=SSTYPE(3)
  /PLOT=PROFILE(LegendOrientation*EncodedMapping*Condition) TYPE=BAR ERRORBAR=CI MEANREFERENCE=NO
  /PRINT=DESCRIPTIVE ETASQ PARAMETER
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=ColorScale LegendOrientation EncodedMapping ColorScale*LegendOrientation
    ColorScale*EncodedMapping LegendOrientation*EncodedMapping
    ColorScale*LegendOrientation*EncodedMapping
  /DESIGN=Condition.


*------------------------------------------------------------

* Experiments 1, 3, 4, 5
*All: t-tests for comparing dark-more vs. light-more encoded mappings for each condition (congruent, incongruent) separately.
* Also gives t-tests for comparing high-more vs. low-more encoded mappings for each condition (congruent, incongruent) separately

COMPUTE DarkMore=Mean(Blue_tHi_Dm,Blue_tLo_Dm,Hot_tHi_Dm,Hot_tLo_Dm).
COMPUTE LightMore=Mean(Blue_tHi_Lm,Blue_tLo_Lm,Hot_tHi_Lm,Hot_tLo_Lm).
COMPUTE HiMore=Mean(Blue_tHi_Dm,Blue_tHi_Lm,Hot_tHi_Dm,Hot_tHi_Lm).
COMPUTE LoMore=Mean(Blue_tLo_Dm,Blue_tLo_Lm,Hot_tLo_Dm,Hot_tLo_Lm).
EXECUTE.

SORT CASES  BY Condition.
SPLIT FILE SEPARATE BY Condition.

T-TEST PAIRS=DarkMore HiMore WITH LightMore LoMore (PAIRED)
  /ES DISPLAY(TRUE) STANDARDIZER(SD)
  /CRITERIA=CI(.9500)
  /MISSING=ANALYSIS.


