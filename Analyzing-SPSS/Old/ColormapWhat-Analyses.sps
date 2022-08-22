* Encoding: UTF-8.

*------------------------------------------------------------
*FILES: 
*    Exp1_SPSS_FasterLonger_Aliens_Labels.csv
*    Exp2_SPSS_SlowerShorter_Aliens_Labels.csv
*    Exp3_SPSS_FasterLonger_Aliens_NoLabels.csv
*    Exp4_SPSS_FasterLonger_Soil_Labels.csv
*    Exp5_SPSS_RankIndex_Health_Labels.csv
*------------------------------------------------------------



*------------------------------------------------------------
*Averaged over color scale and legend
*------------------------------------------------------------

*mixed design ANOVA: 2 conditions (congruent vs. incongruent) x 2 encoded mappings (dark-more quantity vs. light-more quantity).
GLM Dm Lm BY Condition
  /WSFACTOR=EncodedMapping 2 Polynomial
  /METHOD=SSTYPE(3)
  /PRINT=DESCRIPTIVE ETASQ
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=EncodedMapping
  /DESIGN=Condition.




*------------------------------------------------------------
*Averaged over legend
*------------------------------------------------------------

*mixed design ANOVA: 2 conditions (congruent vs. incongruent) x 2 encoded mappings (dark-more quantity vs. light-more quantity) x 2 color scales (Hot vs. Blue).
GLM Blue_Dm Blue_Lm Hot_Dm Hot_LM BY Condition
  /WSFACTOR=ColorScale 2 Polynomial EncodedMapping 2 Polynomial
  /METHOD=SSTYPE(3)
  /PRINT=DESCRIPTIVE ETASQ
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=ColorScale EncodedMapping ColorScale*EncodedMapping
  /DESIGN=Condition.




*------------------------------------------------------------
*Full datasets - Supplementary materials
*------------------------------------------------------------

*mixed design ANOVA: 2 conditions (congruent vs. incongruent) x 2 encoded mappings (dark-more quantity vs. light-more quantity) x 2 color scales (Hot vs. Blue) x 2 legend orientation (target high vs. target low).
GLM Blue_tHi_Dm Blue_tHi_Lm Blue_tLo_Dm Blue_tLo_Lm Hot_tHi_Dm Hot_tHi_Lm Hot_tLo_Dm Hot_tLo_Lm BY
    Condition
  /WSFACTOR=ColorScale 2 Polynomial LegendOrientation 2 Polynomial EncodedMapping 2 Polynomial
  /METHOD=SSTYPE(3)
  /PRINT=DESCRIPTIVE ETASQ
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=ColorScale LegendOrientation EncodedMapping ColorScale*LegendOrientation
    ColorScale*EncodedMapping LegendOrientation*EncodedMapping
    ColorScale*LegendOrientation*EncodedMapping
  /DESIGN=Condition.







