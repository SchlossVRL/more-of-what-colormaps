* Encoding: UTF-8.
* Encoding: .

  
  
  
  * EXPERIMENT 1 analysis run on the following data files:
      * Exp1_Hotspot.sav for hotspot configurations
      * Exp1_Scrambled.sav for scrambled hotspot configurations
  

    GLM A_Dhs_Ghi_Dm A_Dhs_Ghi_Lm A_Dhs_Glo_Dm A_Dhs_Glo_Lm A_Lhs_Ghi_Dm A_Lhs_Ghi_Lm A_Lhs_Glo_Dm
    A_Lhs_Glo_Lm V_Dhs_Ghi_Dm V_Dhs_Ghi_Lm V_Dhs_Glo_Dm V_Dhs_Glo_Lm V_Lhs_Ghi_Dm V_Lhs_Ghi_Lm
    V_Lhs_Glo_Dm V_Lhs_Glo_Lm BY Group
  /WSFACTOR=ColorScale 2 Polynomial HotspotLightness 2 Polynomial LegendTextPosition 2 Polynomial
    Mapping 2 Polynomial
  /METHOD=SSTYPE(3)
  /PRINT=ETASQ
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=ColorScale HotspotLightness LegendTextPosition Mapping ColorScale*HotspotLightness
    ColorScale*LegendTextPosition HotspotLightness*LegendTextPosition
    ColorScale*HotspotLightness*LegendTextPosition ColorScale*Mapping HotspotLightness*Mapping
    ColorScale*HotspotLightness*Mapping LegendTextPosition*Mapping
    ColorScale*LegendTextPosition*Mapping HotspotLightness*LegendTextPosition*Mapping
    ColorScale*HotspotLightness*LegendTextPosition*Mapping
  /DESIGN=Group.

  
  
  * EXPERIMENT 2 analysis run on the following data files:
      *Exp2_BalancedImg.sav for balanced cue images
      
GLM A_Dhs_Ghi_Dm A_Dhs_Ghi_Lm A_Dhs_Glo_Dm A_Dhs_Glo_Lm A_Lhs_Ghi_Dm A_Lhs_Ghi_Lm A_Lhs_Glo_Dm
    A_Lhs_Glo_Lm V_Dhs_Ghi_Dm V_Dhs_Ghi_Lm V_Dhs_Glo_Dm V_Dhs_Glo_Lm V_Lhs_Ghi_Dm V_Lhs_Ghi_Lm
    V_Lhs_Glo_Dm V_Lhs_Glo_Lm
  /WSFACTOR=ColorScale 2 Polynomial HotspotLightness 2 Polynomial LegendTextPosition 2 Polynomial
    Mapping 2 Polynomial
  /METHOD=SSTYPE(3)
  /PRINT=ETASQ
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=ColorScale HotspotLightness LegendTextPosition Mapping ColorScale*HotspotLightness
    ColorScale*LegendTextPosition HotspotLightness*LegendTextPosition
    ColorScale*HotspotLightness*LegendTextPosition ColorScale*Mapping HotspotLightness*Mapping
    ColorScale*HotspotLightness*Mapping LegendTextPosition*Mapping
    ColorScale*LegendTextPosition*Mapping HotspotLightness*LegendTextPosition*Mapping
    ColorScale*HotspotLightness*LegendTextPosition*Mapping.
  
    *Exp2_BalancedImg.sav Comparing encoded mappings within each hotspot lightness

GLM A_Dhs_Ghi_Dm A_Dhs_Ghi_Lm A_Dhs_Glo_Dm A_Dhs_Glo_Lm V_Dhs_Ghi_Dm V_Dhs_Ghi_Lm V_Dhs_Glo_Dm
    V_Dhs_Glo_Lm
  /WSFACTOR=ColorScale 2 Polynomial LegendTextPosition 2 Polynomial Mapping 2 Polynomial
  /METHOD=SSTYPE(3)
  /PRINT=ETASQ
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=ColorScale LegendTextPosition Mapping ColorScale*LegendTextPosition ColorScale*Mapping
    LegendTextPosition*Mapping ColorScale*LegendTextPosition*Mapping.
GLM A_Lhs_Ghi_Dm A_Lhs_Ghi_Lm A_Lhs_Glo_Dm A_Lhs_Glo_Lm V_Lhs_Ghi_Dm V_Lhs_Ghi_Lm V_Lhs_Glo_Dm
    V_Lhs_Glo_Lm
  /WSFACTOR=ColorScale 2 Polynomial LegendTextPosition 2 Polynomial Mapping 2 Polynomial
  /METHOD=SSTYPE(3)
  /PRINT=ETASQ
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=ColorScale LegendTextPosition Mapping ColorScale*LegendTextPosition ColorScale*Mapping
    LegendTextPosition*Mapping ColorScale*LegendTextPosition*Mapping.

    *Exp2_HSmore.sav for hotspot more images
    
GLM A_Dhs_Ghi_Dm A_Dhs_Glo_Dm A_Lhs_Ghi_Lm A_Lhs_Glo_Lm V_Dhs_Ghi_Dm V_Dhs_Glo_Dm V_Lhs_Ghi_Lm
    V_Lhs_Glo_Lm
  /WSFACTOR=ColorScale 2 Polynomial Mapping 2 Polynomial LegendTextPosition 2 Polynomial
  /METHOD=SSTYPE(3)
  /PRINT=ETASQ
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=ColorScale Mapping LegendTextPosition ColorScale*Mapping ColorScale*LegendTextPosition
    Mapping*LegendTextPosition ColorScale*Mapping*LegendTextPosition.

  * EXPERIMENT 3 and 4 analysis run on the following data files:
      *Exp3_BalancedImg.sav for balanced cue images
      *Exp4_BalancedImg.sav for balanced cue images

GLM H_Dhs_Ghi_Dm H_Dhs_Ghi_Lm H_Dhs_Glo_Dm H_Dhs_Glo_Lm H_Lhs_Ghi_Dm H_Lhs_Ghi_Lm H_Lhs_Glo_Dm
    H_Lhs_Glo_Lm V_Dhs_Ghi_Dm V_Dhs_Ghi_Lm V_Dhs_Glo_Dm V_Dhs_Glo_Lm V_Lhs_Ghi_Dm V_Lhs_Ghi_Lm
    V_Lhs_Glo_Dm V_Lhs_Glo_Lm
  /WSFACTOR=ColorScale 2 Polynomial HotspotLightness 2 Polynomial LegendLTextPosition 2 Polynomial
    Mapping 2 Polynomial
  /METHOD=SSTYPE(3)
  /PRINT=ETASQ
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=ColorScale HotspotLightness LegendLTextPosition Mapping ColorScale*HotspotLightness
    ColorScale*LegendLTextPosition HotspotLightness*LegendLTextPosition
    ColorScale*HotspotLightness*LegendLTextPosition ColorScale*Mapping HotspotLightness*Mapping
    ColorScale*HotspotLightness*Mapping LegendLTextPosition*Mapping
    ColorScale*LegendLTextPosition*Mapping HotspotLightness*LegendLTextPosition*Mapping
    ColorScale*HotspotLightness*LegendLTextPosition*Mapping.

    *Exp3_BalancedImg.sav Comparing encoded mappings within each hotspot lightness
    *Exp4_BalancedImg.sav Comparing encoded mappings within each hotspot lightness

GLM H_Lhs_Ghi_Dm H_Lhs_Ghi_Lm H_Lhs_Glo_Dm H_Lhs_Glo_Lm V_Lhs_Ghi_Dm V_Lhs_Ghi_Lm V_Lhs_Glo_Dm
    V_Lhs_Glo_Lm
  /WSFACTOR=ColorScale 2 Polynomial LegendTextPosition 2 Polynomial Mapping 2 Polynomial
  /METHOD=SSTYPE(3)
  /PRINT=ETASQ
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=ColorScale LegendTextPosition Mapping ColorScale*LegendTextPosition ColorScale*Mapping
    LegendTextPosition*Mapping ColorScale*LegendTextPosition*Mapping.

   GLM H_Dhs_Ghi_Dm H_Dhs_Ghi_Lm H_Dhs_Glo_Dm H_Dhs_Glo_Lm V_Dhs_Ghi_Dm V_Dhs_Ghi_Lm V_Dhs_Glo_Dm
    V_Dhs_Glo_Lm
  /WSFACTOR=ColorScale 2 Polynomial LegendTextPosition 2 Polynomial Mapping 2 Polynomial
  /METHOD=SSTYPE(3)
  /PRINT=ETASQ
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=ColorScale LegendTextPosition Mapping ColorScale*LegendTextPosition ColorScale*Mapping
    LegendTextPosition*Mapping ColorScale*LegendTextPosition*Mapping.


    *Experiment 4 comparisons of encoding within light hotspots for Hot (H) and viridis (V) color scales (still using Exp4_BalancedImg.sav)
   
  GLM H_Lhs_Ghi_Dm H_Lhs_Ghi_Lm H_Lhs_Glo_Dm H_Lhs_Glo_Lm 
  /WSFACTOR=LegText 2 Polynomial Mapping 2 Polynomial 
  /METHOD=SSTYPE(3) 
  /PRINT=ETASQ 
  /CRITERIA=ALPHA(.05) 
  /WSDESIGN=LegText Mapping LegText*Mapping.

GLM V_Lhs_Ghi_Dm V_Lhs_Ghi_Lm V_Lhs_Glo_Dm V_Lhs_Glo_Lm 
  /WSFACTOR=LegText 2 Polynomial Mapping 2 Polynomial 
  /METHOD=SSTYPE(3) 
  /PRINT=ETASQ 
  /CRITERIA=ALPHA(.05) 
  /WSDESIGN=LegText Mapping LegText*Mapping.


  * EXPERIMENT 3 and 4 analysis run on the following data files:
    *Exp3_HSmore.sav for hotspot more images
    *Exp4_HSmore.sav for hotspot more images

GLM H_Dhs_Ghi_Dm H_Dhs_Glo_Dm H_Lhs_Ghi_Lm H_Lhs_Glo_Lm V_Dhs_Ghi_Dm V_Dhs_Glo_Dm V_Lhs_Ghi_Lm
    V_Lhs_Glo_Lm
  /WSFACTOR=ColorScale 2 Polynomial Mapping 2 Polynomial LegendTextPosition 2 Polynomial
  /METHOD=SSTYPE(3)
  /PRINT=ETASQ
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=ColorScale Mapping LegendTextPosition ColorScale*Mapping ColorScale*LegendTextPosition
    Mapping*LegendTextPosition ColorScale*Mapping*LegendTextPosition.

*EXPERIMENT 2-4 Hotspot Localization analysis run on the following data files:
    *HotspotLocationRT.sav
    *EXPERIMENT 2 Hotspot Localization

SPLIT FILE LAYERED BY Exp2v3.
GLM AutHotDark2v3 AutHotLight2v3 ViridisDark2v3 ViridisLight2v3
  /WSFACTOR=ColorScale 2 Polynomial HotspotLightness 2 Polynomial
  /METHOD=SSTYPE(3)
  /PRINT=ETASQ
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=ColorScale HotspotLightness ColorScale*HotspotLightness.

  GLM AutHotDark2v3 AutHotLight2v3 
  /WSFACTOR=ColorScale 2 Polynomial 
  /METHOD=SSTYPE(3) 
  /PRINT=ETASQ 
  /CRITERIA=ALPHA(.05) 
  /WSDESIGN=ColorScale.

  GLM ViridisDark2v3 ViridisLight2v3 
  /WSFACTOR=ColorScale 2 Polynomial 
  /METHOD=SSTYPE(3) 
  /PRINT=ETASQ 
  /CRITERIA=ALPHA(.05) 
  /WSDESIGN=ColorScale.

    *EXPERIMENT 3 Hotspot Localization

SPLIT FILE OFF.
GLM AutHotDark2v3 AutHotLight2v3 ViridisDark2v3 ViridisLight2v3 BY Exp2v3
  /WSFACTOR=ColorScale 2 Polynomial HotspotLightness 2 Polynomial
  /METHOD=SSTYPE(3)
  /PRINT=ETASQ
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=ColorScale HotspotLightness ColorScale*HotspotLightness
  /DESIGN=Exp2v3.
 GLM AutHotDark2v3 AutHotLight2v3 BY Exp2v3
  /WSFACTOR=HotspotLightness 2 Polynomial
  /METHOD=SSTYPE(3)
  /PRINT=ETASQ
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=HotspotLightness
  /DESIGN=Exp2v3.
 GLM ViridisDark2v3 ViridisLight2v3 BY Exp2v3
  /WSFACTOR=HotspotLightness 2 Polynomial
  /METHOD=SSTYPE(3)
  /PRINT=ETASQ
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=HotspotLightness
  /DESIGN=Exp2v3.
UNIANOVA AutHotDark2v3 BY Exp2v3
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /PRINT ETASQ
  /CRITERIA=ALPHA(.05)
  /DESIGN=Exp2v3.
  UNIANOVA AutHotLight2v3 BY Exp2v3
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /PRINT ETASQ
  /CRITERIA=ALPHA(.05)
  /DESIGN=Exp2v3.



    *EXPERIMENT 4 Hotspot Localization

SPLIT FILE OFF.
GLM HotDark3v4 HotLight3v4 VirDark3v4 VirLight3v4 BY Exp3v4 
  /WSFACTOR=ColorScale 2 Polynomial HotspotLightness 2 Polynomial 
  /METHOD=SSTYPE(3) 
  /CRITERIA=ALPHA(.05) 
  /WSDESIGN=ColorScale HotspotLightness ColorScale*HotspotLightness 
  /DESIGN=Exp3v4.



