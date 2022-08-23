
######################################################################################################################
### More of what: Dissociating effects of conceptual and numeric mappings on interpreting colormap data visualizations
###
###                                             Data processing
###
###                              Alexis Soto, Melissa A. Schoenlein, Karen B. Schloss
######################################################################################################################



# load in packages --------------------------------------------------------

library(psych)
library(dplyr)
library(lmSupport)
library(stringr)
library(ggplot2)
library(reshape2)
library(lme4)
library(psych)
library(car)
library(lmerTest)




# EXPERIMENT 1: faster/longer-aliens-labels -------------------------------

#Load in SONA data
d <- read.csv("Exp1.csv") 
varDescribe(d)


# VARIABLES

#subjectID = id to be used for analyses
#conditionProto: target faster = 0, target longer = 1; 
#rt = Response time
#question_order: instruction practice trials vs. experiment trials

#colorscale: ColorBrewerBlue = 0; Hot = 1; 
#colormap: 0-19 (different underyling datasets)
#darkSide: dark on left = 0; on right = 1; 
#darkLegOrient: dark low = 0; dark high = 1 (in legend colorscale)
#targetOrient: target high = 0; target low (on legend)
#targetSide: correct response left = 0; right = 1

#darkMoreQuantity (dark more = 1, light more = 0): for longer condition: if targetSide == darkside (dark on left, target on right, meaning left is larger number)
# for faster condition: if targetSide != darkSide (dark on left, target on right, meaning left is larger numbers, aka slower). 
#darkMoreConcept (dark more = 1, light more = 0): if targetSide == darkSide  (dark on left, target on right, meaning left is concept)





# Color vision check --------------------------------------------------------------------

#Change response to character
d$responses = as.character(d$responses)

# Check for colorblindness
dColorblind <- filter(d, str_detect(d$responses, "colorDifficulty")) 
dColorblind$colorblind <- ifelse(str_detect(dColorblind$responses, "Yes"), 1,0 )
dColorblind = dColorblind[dColorblind$colorblind == 1,]
dColorblind$subjectID
dontuseColorblind <- data.frame(subjectID = dColorblind$subjectID) 


#Remove subjects reporting "Yes" to both/either colorblindness question
d = anti_join(d, dontuseColorblind )
#Removes  8 people



# Demographics ---------------------------------------------------------------------

#AGE

#Filter to age rows 
dAge <-  filter(d, str_detect(d$responses, "Age"))

#Get the age values from the string response
dAge$Age <- str_sub(dAge$responses,9, 10) 
keep = c("subjectID", "Age")
Age <- dAge[keep]

#Merge with main data
d <- merge(d,Age,by = "subjectID") 


#GENDER 

#Filter to age rows 
dGender <-  filter(d, str_detect(d$responses, "Gender"))

#Get the age values from the string response
dGender$Gender <- str_sub(dGender$responses,23,26) 
keep = c("subjectID", "Gender")
Gender <- dGender[keep]


#Merge with main data
d <- merge(d,Gender, by = "subjectID") 




# Filter to colormap trials --------------------------------------------------------------------


#Filter to relevant rows & columns
dC <- d[d$trial_type == "image-keyboard-responseMAS-colormaps",] 
dC <- dC[dC$key_press != 0,]
dC[is.na(dC)] = 0


#Exclude practice trials
dC <- dC[dC$question_order == "exp",] #change to == "exp"


#Add additional columns
dC$darkMoreQuantity = ifelse(dC$conditionProto == 1 & dC$targetSide == dC$darkSide, 1,
                             ifelse(dC$conditionProto == 0 & dC$targetSide != dC$darkSide, 1, 0))
dC$darkMoreConcept = ifelse(dC$targetSide == dC$darkSide, 1, 0)
dC$conditionProtoStr =  varRecode(dC$conditionProto, c(0,1), c("faster", "longer"))
dC$colorScaleStr = varRecode(dC$colorScale, c(0,1), c("Blue", "Hot"))
dC$darkMoreConceptStr = varRecode(dC$darkMoreConcept, c(0,1), c("light +", "dark +"))
dC$darkMoreQuantityStr = varRecode(dC$darkMoreQuantity, c(0,1), c("light +", "dark +"))
dC$darkSideStr = varRecode(dC$darkSide, c(0,1), c("dark-left", "dark-right"))
dC$darkLegendOrientStr = varRecode(dC$darkLegendOrient, c(0,1), c("dark-low", "dark-high"))
dC$targetOrientStr = varRecode(dC$targetOrient, c(0,1), c("target-high", "target-low"))
dC$targetSideStr = varRecode(dC$targetSide, c(0,1), c("target-left", "target-right"))
dC$quantOrient = ifelse(dC$conditionProto == 1 & dC$targetOrientStr == "target-high", "quant hi", 
                        ifelse(dC$conditionProto == 0 & dC$targetOrientStr == "target-low", "quant hi", "quant lo"))


# Exclude participants with < 90% accuracy ---------------------------------

#Count number of correct responses (total possible = 320)
BadAcc = aggregate(dC$correct, by = list(dC$subjectID), FUN = sum)
BadAcc = BadAcc[BadAcc$x <=288,]
BadAcc

dontuseAcc <- data.frame(subjectID = BadAcc$Group.1) 

#Remove participants with accuracy 90% ()
dC = anti_join(dC, dontuseAcc)
#Removes 16 people


dC1 = dC



# Demographics for included participants ----------------------------------

dDemo = dC[dC$trial_index == 71,]

dDemo$AgeN = as.numeric(dDemo$Age)
aveAge = mean(dDemo$AgeN)
stAge = sd(dDemo$AgeN)

numFemales <- sum(ifelse(str_detect(dDemo$Gender, "F"), 1,
                     ifelse(str_detect(dDemo$Gender, "f"),1,0)))


# Reshape the data for matlab  -------------------------------------------------------

#Subset dataframe to relevant columns- for Response Time
keep = c("subjectID", "conditionProtoStr", "rt", "colorScaleStr", "darkSideStr", "darkLegendOrientStr", "targetOrientStr", "colormap")
dW = dC1[keep]
dW = dW[with(dW, order(colorScaleStr,darkSideStr,darkLegendOrientStr,targetOrientStr, colormap)),]

#reshape so that each column is a colormap
dW2 = reshape(dW, timevar = 'colormap', idvar = c('subjectID', "conditionProtoStr", "colorScaleStr", "darkSideStr", "darkLegendOrientStr", "targetOrientStr"), direction = 'wide')
dW2 = dW2[with(dW2, order(conditionProtoStr)),]

#subset to faster/longer conditions- RT
dW2Fast = dW2[dW2$conditionProtoStr == "faster",]
dW2Long = dW2[dW2$conditionProtoStr == "longer",]


#Subset dataframe to relevant columns- Accuracy data
keep = c("subjectID", "conditionProtoStr", "correct", "colorScaleStr", "darkSideStr", "darkLegendOrientStr", "targetOrientStr", "colormap")
dWb= dC1[keep]
dWb = dWb[with(dWb, order(colorScaleStr,darkSideStr,darkLegendOrientStr,targetOrientStr, colormap)),]

#reshape so that each column is a colormap
dW2b = reshape(dWb, timevar = 'colormap', idvar = c('subjectID', "conditionProtoStr", "colorScaleStr", "darkSideStr", "darkLegendOrientStr", "targetOrientStr"), direction = 'wide')


#subset to faster/longer conditions-Acc
dW2bFast = dW2b[dW2b$conditionProtoStr == "faster",]
dW2bLong = dW2b[dW2b$conditionProtoStr == "longer",]


#get the subject IDs
subjectsFast = unique(dW2Fast$subjectID)
nFast = length(subjectsFast)
output <- vector("list", nFast)
output2 <- vector("list", nFast)


#get the subject IDs
subjectsLong = unique(dW2Long$subjectID)
nLong = length(subjectsLong)
output <- vector("list", nLong)
output2 <- vector("list", nLong)


#Change wd for saving individual subject data
#("C:\SchlossVRL\more-of-what-colormaps\Organizing-R\Exp1-FasterLonger-Aliens-Labels")


#loop through each subject ID and create a csv file for each one - faster
for (i in 1:nFast){
  print(subjectsFast[i])
  output[[i]]<- dW2Fast[dW2Fast$subjectID == subjectsFast[i],]
  #write.csv(data.frame(output[[i]]), file = paste0(i, "-fast-rtdata.csv"), row.names = FALSE)
  output2[[i]]<- dW2bFast[dW2bFast$subjectID == subjectsFast[i],]
 # write.csv(data.frame(output2[[i]]), file = paste0(i, "-fast-accuracydata.csv"), row.names = FALSE)
  
  
}


#loop through each subject ID and create a csv file for each one - longer
for (i in 1:nLong){
  print(subjectsLong[i])
  output[[i]]<- dW2Long[dW2Long$subjectID == subjectsLong[i],]
  #write.csv(data.frame(output[[i]]), file = paste0(i, "-long-rtdata.csv"), row.names = FALSE)
  output2[[i]]<- dW2bLong[dW2bLong$subjectID == subjectsLong[i],]
 # write.csv(data.frame(output2[[i]]), file = paste0(i, "-long-accuracydata.csv"), row.names = FALSE)
  
}



# EXPERIMENT 2: shorter/slower-aliens-labels ------------------------------


#Load in SONA data
d <- read.csv("Exp2.csv") #Update me with name given when exporting from mySQL. 
varDescribe(d)

#VARIABLES 

#subjectID = id to be used for analyses
#conditionProto: target slower = 0, target shorter = 1; 
#rt = Response time
#question_order: instruction practice trials vs. experiment trials

#colorscale: ColorBrewerBlue = 0; Hot = 1; 
#colormap: 0-19 (different underyling datasets)
#darkSide: dark on left = 0; on right = 1; 
#darkLegOrient: dark low = 0; dark high = 1 (in legend colorscale)
#targetOrient: target high = 0; target low (on legend)
#targetSide: correct response left = 0; right = 1;

#darkMoreQuantity (dark more = 1, light more = 0): for Shorter condition: if targetSide != darkside (dark on left, target on right, meaning left is larger number- D+)
# for slower condition: if targetSide == darkSide (dark on left, target left, larger numbers, aka slower). 
#darkMoreConcept (dark more = 1, light more = 0): if targetSide != darkSide  (dark on left, target right, meaning more of concept on left)


# Color vision check --------------------------------------------------------------------

#Change response to character
d$responses = as.character(d$responses)

# Check for colorblindness
dColorblind <- filter(d, str_detect(d$responses, "colorDifficulty")) 
dColorblind$colorblind <- ifelse(str_detect(dColorblind$responses, "Yes"), 1,0 )
dColorblind = dColorblind[dColorblind$colorblind == 1,]
dColorblind$subjectID
dontuseColorblind <- data.frame(subjectID = dColorblind$subjectID) 


#Remove subjects reporting "Yes" to both/either colorblindness question
d = anti_join(d, dontuseColorblind )
#Removes  7 people



# Demographics ---------------------------------------------------------------------

#AGE

#Filter to age rows 
dAge <-  filter(d, str_detect(d$responses, "Age"))

#Get the age values from the string response
dAge$Age <- str_sub(dAge$responses,9, 10) 
keep = c("subjectID", "Age")
Age <- dAge[keep]

#Merge with main data
d <- merge(d,Age,by = "subjectID") 


#GENDER 

#Filter to age rows 
dGender <-  filter(d, str_detect(d$responses, "Gender"))

#Get the age values from the string response
dGender$Gender <- str_sub(dGender$responses,23,26) 
keep = c("subjectID", "Gender")
Gender <- dGender[keep]


#Merge with main data
d <- merge(d,Gender, by = "subjectID") 



# Filter to colormap trials --------------------------------------------------------------------


#Filter to relevant rows & columns
dC <- d[d$trial_type == "image-keyboard-responseMAS-colormaps",] 
dC <- dC[dC$key_press != 0,]
dC[is.na(dC)] = 0


#Exclude practice trials
dC <- dC[dC$question_order == "exp",] 



#Add additional columns
dC$darkMoreQuantity = ifelse(dC$conditionProto == 1 & dC$targetSide != dC$darkSide, 1,  #these are all just flipped from the faster/longer ==
                             ifelse(dC$conditionProto == 0 & dC$targetSide == dC$darkSide, 1, 0)) # =!
dC$darkMoreConcept = ifelse(dC$targetSide != dC$darkSide, 1, 0) # == 
dC$darkMoreConceptStr = varRecode(dC$darkMoreConcept, c(0,1), c("light +", "dark +"))
dC$darkMoreQuantityStr = varRecode(dC$darkMoreQuantity, c(0,1), c("light +", "dark +"))
dC$conditionProtoStr =  varRecode(dC$conditionProto, c(0,1), c("slower", "shorter"))
dC$colorScaleStr = varRecode(dC$colorScale, c(0,1), c("Blue", "Hot"))
dC$darkSideStr = varRecode(dC$darkSide, c(0,1), c("dark-left", "dark-right"))
dC$darkLegendOrientStr = varRecode(dC$darkLegendOrient, c(0,1), c("dark-low", "dark-high"))
dC$targetOrientStr = varRecode(dC$targetOrient, c(0,1), c("target-high", "target-low"))
dC$targetSideStr = varRecode(dC$targetSide, c(0,1), c("target-left", "target-right"))
dC$quantOrient = ifelse(dC$conditionProto == 1 & dC$targetOrientStr == "target-high", "quant lo", #shorter
                        ifelse(dC$conditionProto == 0 & dC$targetOrientStr == "target-low", "quant lo", "quant hi"))
dC$conceptOrient = ifelse(dC$targetOrientStr == "target-high", "concept lo", 
                          ifelse(dC$targetOrientStr == "target-low", "concept hi", "no"))


# Exclude participants with < 90% accuracy ---------------------------------

#Count number of correct responses (total possible = 320)
BadAcc = aggregate(dC$correct, by = list(dC$subjectID), FUN = sum)
BadAcc = BadAcc[BadAcc$x <288,]
BadAcc

dontuseAcc <- data.frame(subjectID = BadAcc$Group.1) 

#Remove participants with accuracy 90% ()
dC = anti_join(dC, dontuseAcc)
#Removes 25 people


dC1 = dC

# Demographics for included participants ----------------------------------

dDemo = dC[dC$trial_index == 71,]

dDemo$AgeN = as.numeric(dDemo$Age)
aveAge = mean(dDemo$AgeN)
stAge = sd(dDemo$AgeN)

numFemales <- sum(ifelse(str_detect(dDemo$Gender, "F"), 1,
                         ifelse(str_detect(dDemo$Gender, "f"),1,0)))



# Reshape the data for matlab  -------------------------------------------------------

#Subset dataframe to relevant columns- for Response Time
keep = c("subjectID", "conditionProtoStr", "rt", "colorScaleStr", "darkSideStr", "darkLegendOrientStr", "targetOrientStr", "colormap")
dW = dC1[keep]
dW = dW[with(dW, order(colorScaleStr,darkSideStr,darkLegendOrientStr,targetOrientStr, colormap)),]

#reshape so that each column is a colormap
dW2 = reshape(dW, timevar = 'colormap', idvar = c('subjectID', "conditionProtoStr", "colorScaleStr", "darkSideStr", "darkLegendOrientStr", "targetOrientStr"), direction = 'wide')
dW2 = dW2[with(dW2, order(conditionProtoStr)),]


#subset to Slower/Shorter conditions- RT
dW2Slow = dW2[dW2$conditionProtoStr == "slower",]
dW2Short = dW2[dW2$conditionProtoStr == "shorter",]


#Subset dataframe to relevant columns- Accuracy data
keep = c("subjectID", "conditionProtoStr", "correct", "colorScaleStr", "darkSideStr", "darkLegendOrientStr", "targetOrientStr", "colormap")
dWb= dC1[keep]
dWb = dWb[with(dWb, order(colorScaleStr,darkSideStr,darkLegendOrientStr,targetOrientStr, colormap)),]

#reshape so that each column is a colormap
dW2b = reshape(dWb, timevar = 'colormap', idvar = c('subjectID', "conditionProtoStr", "colorScaleStr", "darkSideStr", "darkLegendOrientStr", "targetOrientStr"), direction = 'wide')


#subset to Slower/Shorter conditions-Acc
dW2bSlow = dW2b[dW2b$conditionProtoStr == "slower",]
dW2bShort = dW2b[dW2b$conditionProtoStr == "shorter",]



#get the subject IDs
subjectsSlow = unique(dW2Slow$subjectID)
nSlow = length(subjectsSlow)
output <- vector("list", nSlow)
output2 <- vector("list", nSlow)


#get the subject IDs
subjectsShort = unique(dW2Short$subjectID)
nShort = length(subjectsShort)
output <- vector("list", nShort)
output2 <- vector("list", nShort)



#Change wd for saving individual subject data
#("C:\SchlossVRL\more-of-what-colormaps\Organizing-R\Exp2-SlowerShorter-Aliens-Labels")


#loop through each subject ID and create a csv file for each one - Slower
for (i in 1:nSlow){
  print(subjectsSlow[i])
  output[[i]]<- dW2Slow[dW2Slow$subjectID == subjectsSlow[i],]
 # write.csv(data.frame(output[[i]]), file = paste0(i, "-Slow-rtdata.csv"), row.names = FALSE)
  output2[[i]]<- dW2bSlow[dW2bSlow$subjectID == subjectsSlow[i],]
  #write.csv(data.frame(output2[[i]]), file = paste0(i, "-Slow-accuracydata.csv"), row.names = FALSE)
  
  
}


#loop through each subject ID and create a csv file for each one - shorter
for (i in 1:nShort){
  print(subjectsShort[i])
  output[[i]]<- dW2Short[dW2Short$subjectID == subjectsShort[i],]
  #write.csv(data.frame(output[[i]]), file = paste0(i, "-Short-rtdata.csv"), row.names = FALSE)
  output2[[i]]<- dW2bShort[dW2bShort$subjectID == subjectsShort[i],]
  #write.csv(data.frame(output2[[i]]), file = paste0(i, "-Short-accuracydata.csv"), row.names = FALSE)
  
}




# EXPERIMENT 3: faster/slower-aliens-noLabels -----------------------------


#Load in SONA data
d <- read.csv("Exp3.csv") #Update me with name given when exporting from mySQL. 
varDescribe(d)


#VARIABLES 

#subjectID = id to be used for analyses
#conditionProto: target faster = 0, target longer = 1; 
#rt = Response time
#question_order: instruction practice trials vs. experiment trials

#colorscale: ColorBrewerBlue = 0; Hot = 1; 
#colormap: 0-19 (different underyling datasets)
#darkSide: dark on left = 0; on right = 1; 
#darkLegOrient: dark low = 0; dark high = 1 (in legend colorscale)
#targetOrient: target high = 0; target low (on legend)
#targetSide: correct response left = 0; right = 1;

#darkMoreQuantity (dark more = 1, light more = 0): for longer condition: if targetSide == darkside (dark on left, target on right, meaning left is larger number)
# for faster condition: if targetSide != darkSide (dark on left, target on right, meaning left is larger numbers, aka slower). 
#darkMoreConcept (dark more = 1, light more = 0): if targetSide == darkSide  (dark on left, target on right, meaning left is concept)


# Color vision check --------------------------------------------------------------------

#Change response to character
d$responses = as.character(d$responses)

# Check for colorblindness
dColorblind <- filter(d, str_detect(d$responses, "colorDifficulty")) 
dColorblind$colorblind <- ifelse(str_detect(dColorblind$responses, "Yes"), 1,0 )
dColorblind = dColorblind[dColorblind$colorblind == 1,]
dColorblind$subjectID
dontuseColorblind <- data.frame(subjectID = dColorblind$subjectID) 


#Remove subjects reporting "Yes" to both/either colorblindness question
d = anti_join(d, dontuseColorblind )
#Removes  7 people



# Demographics ---------------------------------------------------------------------

#AGE

#Filter to age rows 
dAge <-  filter(d, str_detect(d$responses, "Age"))

#Get the age values from the string response
dAge$Age <- str_sub(dAge$responses,9, 10) 
keep = c("subjectID", "Age")
Age <- dAge[keep]

#Merge with main data
d <- merge(d,Age,by = "subjectID") 



#GENDER

#Filter to age rows 
dGender <-  filter(d, str_detect(d$responses, "Gender"))

#Get the age values from the string response
dGender$Gender <- str_sub(dGender$responses,23,26) 
keep = c("subjectID", "Gender")
Gender <- dGender[keep]


#Merge with main data
d <- merge(d,Gender, by = "subjectID") 



# Filter to colormap trials --------------------------------------------------------------------


#Filter to relevant rows & columns
dC <- d[d$trial_type == "image-keyboard-responseMAS-colormaps",] 
dC <- dC[dC$key_press != 0,]
dC[is.na(dC)] = 0


#Exclude practice trials
dC <- dC[dC$question_order == "exp",] #change to == "exp"



#Add additional columns
dC$darkMoreQuantity = ifelse(dC$conditionProto == 1 & dC$targetSide == dC$darkSide, 1,
                             ifelse(dC$conditionProto == 0 & dC$targetSide != dC$darkSide, 1, 0))
dC$darkMoreConcept = ifelse(dC$targetSide == dC$darkSide, 1, 0)
dC$conditionProtoStr =  varRecode(dC$conditionProto, c(0,1), c("faster", "longer"))
dC$colorScaleStr = varRecode(dC$colorScale, c(0,1), c("Blue", "Hot"))
dC$darkMoreConceptStr = varRecode(dC$darkMoreConcept, c(0,1), c("light +", "dark +"))
dC$darkMoreQuantityStr = varRecode(dC$darkMoreQuantity, c(0,1), c("light +", "dark +"))
dC$darkSideStr = varRecode(dC$darkSide, c(0,1), c("dark-left", "dark-right"))
dC$darkLegendOrientStr = varRecode(dC$darkLegendOrient, c(0,1), c("dark-low", "dark-high"))
dC$targetOrientStr = varRecode(dC$targetOrient, c(0,1), c("target-high", "target-low"))
dC$targetSideStr = varRecode(dC$targetSide, c(0,1), c("target-left", "target-right"))
dC$quantOrient = ifelse(dC$conditionProto == 1 & dC$targetOrientStr == "target-high", "quant hi", 
                        ifelse(dC$conditionProto == 0 & dC$targetOrientStr == "target-low", "quant hi", "quant lo"))




# Exclude participants with < 90% accuracy ---------------------------------

#Count number of correct responses (total possible = 320)
BadAcc = aggregate(dC$correct, by = list(dC$subjectID), FUN = sum)
BadAcc = BadAcc[BadAcc$x <=288,]
BadAcc

dontuseAcc <- data.frame(subjectID = BadAcc$Group.1) 

#Remove participants with accuracy 90% ()
dC = anti_join(dC, dontuseAcc)
#Removes 16 people


dC1 = dC

# Demographics for included participants ----------------------------------


dDemo = dC[dC$trial_index == 71,]

dDemo$AgeN = as.numeric(dDemo$Age)
aveAge = mean(dDemo$AgeN)
stAge = sd(dDemo$AgeN)

numFemales <- sum(ifelse(str_detect(dDemo$Gender, "F"), 1,
                         ifelse(str_detect(dDemo$Gender, "f"),1,0)))



# Reshape the data for matlab  -------------------------------------------------------

#Subset dataframe to relevant columns- for Response Time
keep = c("subjectID", "conditionProtoStr", "rt", "colorScaleStr", "darkSideStr", "darkLegendOrientStr", "targetOrientStr", "colormap")
dW = dC1[keep]
dW = dW[with(dW, order(colorScaleStr,darkSideStr,darkLegendOrientStr,targetOrientStr, colormap)),]

#reshape so that each column is a colormap
dW2 = reshape(dW, timevar = 'colormap', idvar = c('subjectID', "conditionProtoStr", "colorScaleStr", "darkSideStr", "darkLegendOrientStr", "targetOrientStr"), direction = 'wide')
dW2 = dW2[with(dW2, order(conditionProtoStr)),]


#subset to faster/longer conditions- RT
dW2Fast = dW2[dW2$conditionProtoStr == "faster",]
dW2Long = dW2[dW2$conditionProtoStr == "longer",]


#Subset dataframe to relevant columns- Accuracy data
keep = c("subjectID", "conditionProtoStr", "correct", "colorScaleStr", "darkSideStr", "darkLegendOrientStr", "targetOrientStr", "colormap")
dWb= dC1[keep]
dWb = dWb[with(dWb, order(colorScaleStr,darkSideStr,darkLegendOrientStr,targetOrientStr, colormap)),]

#reshape so that each column is a colormap
dW2b = reshape(dWb, timevar = 'colormap', idvar = c('subjectID', "conditionProtoStr", "colorScaleStr", "darkSideStr", "darkLegendOrientStr", "targetOrientStr"), direction = 'wide')


#subset to faster/longer conditions-Acc
dW2bFast = dW2b[dW2b$conditionProtoStr == "faster",]
dW2bLong = dW2b[dW2b$conditionProtoStr == "longer",]


#get the subject IDs
subjectsFast = unique(dW2Fast$subjectID)
nFast = length(subjectsFast)
output <- vector("list", nFast)
output2 <- vector("list", nFast)


#get the subject IDs
subjectsLong = unique(dW2Long$subjectID)
nLong = length(subjectsLong)
output <- vector("list", nLong)
output2 <- vector("list", nLong)




#Change wd for saving individual subject data
#("C:\SchlossVRL\more-of-what-colormaps\Organizing-R\Exp3-FasterSlower-Aliens-NoLabels")


#loop through each subject ID and create a csv file for each one - faster
for (i in 1:nFast){
  print(subjectsFast[i])
  output[[i]]<- dW2Fast[dW2Fast$subjectID == subjectsFast[i],]
 # write.csv(data.frame(output[[i]]), file = paste0(i, "-fast-rtdataNoLabel.csv"), row.names = FALSE)
  output2[[i]]<- dW2bFast[dW2bFast$subjectID == subjectsFast[i],]
 # write.csv(data.frame(output2[[i]]), file = paste0(i, "-fast-accuracydataNoLabel.csv"), row.names = FALSE)
  
}


#loop through each subject ID and create a csv file for each one - longer
for (i in 1:nLong){
  print(subjectsLong[i])
  output[[i]]<- dW2Long[dW2Long$subjectID == subjectsLong[i],]
  #write.csv(data.frame(output[[i]]), file = paste0(i, "-long-rtdataNoLabel.csv"), row.names = FALSE)
  output2[[i]]<- dW2bLong[dW2bLong$subjectID == subjectsLong[i],]
 # write.csv(data.frame(output2[[i]]), file = paste0(i, "-long-accuracydataNoLabel.csv"), row.names = FALSE)
  
}



# EXPERIMENT 4: faster/slower-soil-labels ---------------------------------


#Load in SONA data
d <- read.csv("Exp4.csv") 
varDescribe(d)


#VARIABLES

#subjectID = id to be used for analyses
#conditionProto: target faster = 0, target longer = 1; 
#rt = Response time
#question_order: instruction practice trials vs. experiment trials


#colorscale: ColorBrewerBlue = 0; Hot = 1; 
#colormap: 0-19 (different underyling datasets)
#darkSide: dark on left = 0; on right = 1; 
#darkLegOrient: dark low = 0; dark high = 1 (in legend colorscale)
#targetOrient: target high = 0; target low (on legend)
#targetSide: correct response left = 0; right = 1;

#darkMoreQuantity (dark more = 1, light more = 0): for longer condition: if targetSide == darkside (dark on left, target on right, meaning left is larger number)
# for faster condition: if targetSide != darkSide (dark on left, target on right, meaning left is larger numbers, aka slower). 
#darkMoreConcept (dark more = 1, light more = 0): if targetSide == darkSide  (dark on left, target on right, meaning left is concept)



# Color vision check --------------------------------------------------------------------

#Change response to character
d$responses = as.character(d$responses)

# Check for colorblindness
dColorblind <- filter(d, str_detect(d$responses, "colorDifficulty")) 
dColorblind$colorblind <- ifelse(str_detect(dColorblind$responses, "Yes"), 1,0 )
dColorblind = dColorblind[dColorblind$colorblind == 1,]
dColorblind$subjectID
dontuseColorblind <- data.frame(subjectID = dColorblind$subjectID) 


#Remove subjects reporting "Yes" to both/either colorblindness question
d = anti_join(d, dontuseColorblind )
#Removes  8 people



# Demographics ------------------------------------------------------------

# AGE 
dAge <-  filter(d, str_detect(d$responses, "Age"))

#Get the age values from the string response
dAge$Age <- str_sub(dAge$responses,9, 10) 
keep = c("subjectID", "Age")
Age <- dAge[keep]

#Merge with main data
d <- merge(d,Age,by = "subjectID") 



#GENDER 

#Filter to age rows 
dGender <-  filter(d, str_detect(d$responses, "Gender"))

#Get the age values from the string response
dGender$Gender <- str_sub(dGender$responses,23,26) 
keep = c("subjectID", "Gender")
Gender <- dGender[keep]


#Merge with main data
d <- merge(d,Gender, by = "subjectID") 



# Filter to colormap trials --------------------------------------------------------------------


#Filter to relevant rows & columns
dC <- d[d$trial_type == "image-keyboard-responseMAS-colormaps",] 
dC <- dC[dC$key_press != 0,]
dC[is.na(dC)] = 0


#Exclude practice trials
dC <- dC[dC$question_order == "exp",] #change to == "exp"



#Add additional columns
dC$darkMoreQuantity = ifelse(dC$conditionProto == 1 & dC$targetSide == dC$darkSide, 1,
                             ifelse(dC$conditionProto == 0 & dC$targetSide != dC$darkSide, 1, 0))
dC$darkMoreConcept = ifelse(dC$targetSide == dC$darkSide, 1, 0)
dC$conditionProtoStr =  varRecode(dC$conditionProto, c(0,1), c("faster", "longer"))
dC$colorScaleStr = varRecode(dC$colorScale, c(0,1), c("Blue", "Hot"))
dC$darkMoreConceptStr = varRecode(dC$darkMoreConcept, c(0,1), c("light +", "dark +"))
dC$darkMoreQuantityStr = varRecode(dC$darkMoreQuantity, c(0,1), c("light +", "dark +"))
dC$darkSideStr = varRecode(dC$darkSide, c(0,1), c("dark-left", "dark-right"))
dC$darkLegendOrientStr = varRecode(dC$darkLegendOrient, c(0,1), c("dark-low", "dark-high"))
dC$targetOrientStr = varRecode(dC$targetOrient, c(0,1), c("target-high", "target-low"))
dC$targetSideStr = varRecode(dC$targetSide, c(0,1), c("target-left", "target-right"))
dC$quantOrient = ifelse(dC$conditionProto == 1 & dC$targetOrientStr == "target-high", "quant hi", 
                        ifelse(dC$conditionProto == 0 & dC$targetOrientStr == "target-low", "quant hi", "quant lo"))




# Exclude participants with < 90% accuracy ---------------------------------

#Count number of correct responses (total possible = 320)
BadAcc = aggregate(dC$correct, by = list(dC$subjectID), FUN = sum)
BadAcc = BadAcc[BadAcc$x <=288,]
BadAcc

dontuseAcc <- data.frame(subjectID = BadAcc$Group.1) 

#Remove participants with accuracy 90% ()
dC = anti_join(dC, dontuseAcc)
#Removes 14 people


dC1 = dC

# Demographics for included participants ----------------------------------


dDemo = dC[dC$trial_index == 71,]

dDemo$AgeN = as.numeric(dDemo$Age)
aveAge = mean(dDemo$AgeN)
stAge = sd(dDemo$AgeN)

numFemales <- sum(ifelse(str_detect(dDemo$Gender, "F"), 1,
                         ifelse(str_detect(dDemo$Gender, "f"),1,0)))



# Reshape the data for matlab  -------------------------------------------------------

#Subset dataframe to relevant columns- for Response Time
keep = c("subjectID", "conditionProtoStr", "rt", "colorScaleStr", "darkSideStr", "darkLegendOrientStr", "targetOrientStr", "colormap")
dW = dC1[keep]
dW = dW[with(dW, order(colorScaleStr,darkSideStr,darkLegendOrientStr,targetOrientStr, colormap)),]

#reshape so that each column is a colormap
dW2 = reshape(dW, timevar = 'colormap', idvar = c('subjectID', "conditionProtoStr", "colorScaleStr", "darkSideStr", "darkLegendOrientStr", "targetOrientStr"), direction = 'wide')
dW2 = dW2[with(dW2, order(conditionProtoStr)),]


#subset to faster/longer conditions- RT
dW2Fast = dW2[dW2$conditionProtoStr == "faster",]
dW2Long = dW2[dW2$conditionProtoStr == "longer",]


#Subset dataframe to relevant columns- Accuracy data
keep = c("subjectID", "conditionProtoStr", "correct", "colorScaleStr", "darkSideStr", "darkLegendOrientStr", "targetOrientStr", "colormap")
dWb= dC1[keep]
dWb = dWb[with(dWb, order(colorScaleStr,darkSideStr,darkLegendOrientStr,targetOrientStr, colormap)),]

#reshape so that each column is a colormap
dW2b = reshape(dWb, timevar = 'colormap', idvar = c('subjectID', "conditionProtoStr", "colorScaleStr", "darkSideStr", "darkLegendOrientStr", "targetOrientStr"), direction = 'wide')


#subset to faster/longer conditions-Acc
dW2bFast = dW2b[dW2b$conditionProtoStr == "faster",]
dW2bLong = dW2b[dW2b$conditionProtoStr == "longer",]


#get the subject IDs
subjectsFast = unique(dW2Fast$subjectID)
nFast = length(subjectsFast)
output <- vector("list", nFast)
output2 <- vector("list", nFast)


#get the subject IDs
subjectsLong = unique(dW2Long$subjectID)
nLong = length(subjectsLong)
output <- vector("list", nLong)
output2 <- vector("list", nLong)



#Change wd for saving individual subject data
#("C:\SchlossVRL\more-of-what-colormaps\Organizing-R\Exp4-FasterSlower-Soil-Labels")


#loop through each subject ID and create a csv file for each one - faster
for (i in 1:nFast){
  print(subjectsFast[i])
  output[[i]]<- dW2Fast[dW2Fast$subjectID == subjectsFast[i],]
 # write.csv(data.frame(output[[i]]), file = paste0(i, "-fast-Soil-rtdata.csv"), row.names = FALSE)
  output2[[i]]<- dW2bFast[dW2bFast$subjectID == subjectsFast[i],]
 # write.csv(data.frame(output2[[i]]), file = paste0(i, "-fast-Soil-accuracydata.csv"), row.names = FALSE)
  
  
}


#loop through each subject ID and create a csv file for each one - longer
for (i in 1:nLong){
  print(subjectsLong[i])
  output[[i]]<- dW2Long[dW2Long$subjectID == subjectsLong[i],]
 # write.csv(data.frame(output[[i]]), file = paste0(i, "-long-Soil-rtdata.csv"), row.names = FALSE)
  output2[[i]]<- dW2bLong[dW2bLong$subjectID == subjectsLong[i],]
 # write.csv(data.frame(output2[[i]]), file = paste0(i, "-long-Soil-accuracydata.csv"), row.names = FALSE)
  
}



# EXPERIMENT 5: Rank/Index-Health-Labels ----------------------------------


#Load in  data
d <- read.csv("Exp5.csv")  
varDescribe(d)


#VARIABLES

#subjectID = id to be used for analyses
#conditionProto: index condition = 0, rank condition = 1; 
#rt = Response time
#question_order: instruction practice trials vs. experiment trials

#colorscale: ColorBrewerBlue = 0; Hot = 1; 
#colormap: 0-19 (different underyling datasets)
#darkSide: dark on left = 0; on right = 1; 
#darkLegOrient: dark low = 0; dark high = 1 (in legend colorscale)
#targetOrient: target high = 0; target low (on legend)
#targetSide: correct response left = 0; right = 1;


#switch condition so that index is 1 (congruent) and rank is 0 (incongruent) to align with faster/longer conditions
d$conditionProto = ifelse(d$conditionProto == 0, 1,
                          ifelse(d$conditionProto == 1, 0, 3))


#darkMoreQuantity (dark more = 1, light more = 0): for index condition: if targetSide == darkside (dark on left, target on right, meaning left is larger number)
# for rank condition: if targetSide != darkSide (dark on left, target on right, meaning left is larger numbers, aka slower). 
#darkMoreConcept (dark more = 1, light more = 0): if targetSide == darkSide  (dark on left, target on right, meaning left is concept)



# Color vision check --------------------------------------------------------------------

#Change response to character
d$responses = as.character(d$responses)

# Check for colorblindness
dColorblind <- filter(d, str_detect(d$responses, "colorDifficulty")) 
dColorblind$colorblind <- ifelse(str_detect(dColorblind$responses, "Yes"), 1,0 )
dColorblind = dColorblind[dColorblind$colorblind == 1,]
dColorblind$subjectID
dontuseColorblind <- data.frame(subjectID = dColorblind$subjectID) 


#Remove subjects reporting "Yes" to both/either colorblindness question
d = anti_join(d, dontuseColorblind )
#Removes  5 people



# Demographics ------------------------------------------------------------

# AGE

#Filter to age rows 
dAge <-  filter(d, str_detect(d$responses, "Age"))

#Get the age values from the string response
dAge$Age <- str_sub(dAge$responses,9, 10) 
keep = c("subjectID", "Age")
Age <- dAge[keep]

#Merge with main data
d <- merge(d,Age,by = "subjectID") 


 #GENDER

#Filter to age rows 
dGender <-  filter(d, str_detect(d$responses, "Gender"))

#Get the age values from the string response
dGender$Gender <- str_sub(dGender$responses,23,26) 
keep = c("subjectID", "Gender")
Gender <- dGender[keep]


#Merge with main data
d <- merge(d,Gender, by = "subjectID") 


#Filter to colormap trials --------------------------------------------------------------------


#Filter to relevant rows & columns
dC <- d[d$trial_type == "image-keyboard-responseMAS-colormaps",] 
dC <- dC[dC$key_press != 0,]
dC[is.na(dC)] = 0


#Exclude practice trials
dC <- dC[dC$question_order == "exp",]


#Add additional columns
dC$darkMoreQuantity = ifelse(dC$conditionProto == 1 & dC$targetSide == dC$darkSide, 1,
                             ifelse(dC$conditionProto == 0 & dC$targetSide != dC$darkSide, 1, 0))
dC$darkMoreConcept = ifelse(dC$targetSide == dC$darkSide, 1, 0)
dC$conditionProtoStr =  varRecode(dC$conditionProto, c(0,1), c("rank", "index"))
dC$colorScaleStr = varRecode(dC$colorScale, c(0,1), c("Blue", "Hot"))
dC$darkMoreConceptStr = varRecode(dC$darkMoreConcept, c(0,1), c("light +", "dark +"))
dC$darkMoreQuantityStr = varRecode(dC$darkMoreQuantity, c(0,1), c("light +", "dark +"))
dC$darkSideStr = varRecode(dC$darkSide, c(0,1), c("dark-left", "dark-right"))
dC$darkLegendOrientStr = varRecode(dC$darkLegendOrient, c(0,1), c("dark-low", "dark-high"))
dC$targetOrientStr = varRecode(dC$targetOrient, c(0,1), c("target-high", "target-low"))
dC$targetSideStr = varRecode(dC$targetSide, c(0,1), c("target-left", "target-right"))



# Exclude participants with < 90% accuracy ---------------------------------

#Count number of correct responses (total possible = 320)
BadAcc = aggregate(dC$correct, by = list(dC$subjectID), FUN = sum)
BadAcc = BadAcc[BadAcc$x <=288,]
BadAcc

dontuseAcc <- data.frame(subjectID = BadAcc$Group.1) 

#Remove participants with accuracy 90% ()
dC = anti_join(dC, dontuseAcc)
#Removes 11 people


dC1 = dC



# Demographics for included participants ----------------------------------

dCcount = dC[!duplicated(dC$subjectID),]

dDemo = dC[dC$trial_index == 71,]

dDemo$AgeN = as.numeric(dDemo$Age)
aveAge = mean(dDemo$AgeN)
stAge = sd(dDemo$AgeN)

numFemales <- sum(ifelse(str_detect(dDemo$Gender, "F"), 1,
                         ifelse(str_detect(dDemo$Gender, "f"),1,0)))

numMales = 60-numFemales



# Reshape the data for matlab  -------------------------------------------------------

#Subset dataframe to relevant columns- for Response Time
keep = c("subjectID", "conditionProtoStr", "rt", "colorScaleStr", "darkSideStr", "darkLegendOrientStr", "targetOrientStr", "colormap")
dW = dC1[keep]
dW = dW[with(dW, order(colorScaleStr,darkSideStr,darkLegendOrientStr,targetOrientStr, colormap)),]

#reshape so that each column is a colormap
dW2 = reshape(dW, timevar = 'colormap', idvar = c('subjectID', "conditionProtoStr", "colorScaleStr", "darkSideStr", "darkLegendOrientStr", "targetOrientStr"), direction = 'wide')
dW2 = dW2[with(dW2, order(conditionProtoStr)),]


#subset to rank/index conditions- RT
dW2Rank = dW2[dW2$conditionProtoStr == "rank",]
dW2Index = dW2[dW2$conditionProtoStr == "index",]


#Subset dataframe to relevant columns- Accuracy data
keep = c("subjectID", "conditionProtoStr", "correct", "colorScaleStr", "darkSideStr", "darkLegendOrientStr", "targetOrientStr", "colormap")
dWb= dC1[keep]
dWb = dWb[with(dWb, order(colorScaleStr,darkSideStr,darkLegendOrientStr,targetOrientStr, colormap)),]

#reshape so that each column is a colormap
dW2b = reshape(dWb, timevar = 'colormap', idvar = c('subjectID', "conditionProtoStr", "colorScaleStr", "darkSideStr", "darkLegendOrientStr", "targetOrientStr"), direction = 'wide')


#subset to rank index conditions-Acc
dW2bRank = dW2b[dW2b$conditionProtoStr == "rank",]
dW2bIndex = dW2b[dW2b$conditionProtoStr == "index",]


#get the subject IDs
subjectsRank = unique(dW2Rank$subjectID)
nRank = length(subjectsRank)
output <- vector("list", nRank)
output2 <- vector("list", nRank)


#get the subject IDs
subjectsIndex= unique(dW2Index$subjectID)
nIndex = length(subjectsIndex)
output <- vector("list", nIndex)
output2 <- vector("list", nIndex)



#loop through each subject ID and create a csv file for each one -faster
for (i in 1:nRank){
  print(subjectsRank[i])
  output[[i]]<- dW2Rank[dW2Rank$subjectID == subjectsRank[i],]
#  write.csv(data.frame(output[[i]]), file = paste0(i, "-rank-Health-rtdata.csv"), row.names = FALSE)
  output2[[i]]<- dW2bRank[dW2bRank$subjectID == subjectsRank[i],]
 # write.csv(data.frame(output2[[i]]), file = paste0(i, "-rank-Health-accuracydata.csv"), row.names = FALSE)
  
  
}


#loop through each subject ID and create a csv file for each one
for (i in 1:nIndex){
  print(subjectsIndex[i])
  output[[i]]<- dW2Index[dW2Index$subjectID == subjectsIndex[i],]
 # write.csv(data.frame(output[[i]]), file = paste0(i, "-index-Health-rtdata.csv"), row.names = FALSE)
  output2[[i]]<- dW2bIndex[dW2bIndex$subjectID == subjectsIndex[i],]
 # write.csv(data.frame(output2[[i]]), file = paste0(i, "-index-Health-accuracydata.csv"), row.names = FALSE)
  
}



