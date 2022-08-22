### ### ### ### ### ### ### ### ### 
####   ONLINE COLORMAPS WHAT  #####
### ### ### ### ### ### ### ### ### 

### SHORTER/SLOWER DATA


#Load in packages
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


#Set working directory - Change for your computer 
#setwd("C:/Users/melan/Dropbox/Research/Experiments/ColormapWhat/Analyses/SlowerShorter-Aliens-Labels")
setwd("~/Dropbox/ColormapWhat/Analyses/SlowerShorter-Aliens-Labels")


#Load in SONA data
d <- read.csv("Exp2.csv") #Update me with name given when exporting from mySQL. 
varDescribe(d)



#workerID = SONA id used for assigning credit 
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
#Removes  X people



# Age ---------------------------------------------------------------------

#Filter to age rows 
dAge <-  filter(d, str_detect(d$responses, "Age"))

#Get the age values from the string response
dAge$Age <- str_sub(dAge$responses,9, 10) 
keep = c("subjectID", "Age")
Age <- dAge[keep]

#Merge with main data
d <- merge(d,Age,by = "subjectID") 



# Gender ------------------------------------------------------------------

#Filter to age rows 
dGender <-  filter(d, str_detect(d$responses, "Gender"))

#Get the age values from the string response
dGender$Gender <- str_sub(dGender$responses,23,26) 
keep = c("subjectID", "Gender")
Gender <- dGender[keep]


#Merge with main data
d <- merge(d,Gender, by = "subjectID") 






# COLORMAPS  -------------------------------------------------------

# Prep: Filter to colormap trials --------------------------------------------------------------------


#Filter to relevant rows & columns
dC <- d[d$trial_type == "image-keyboard-responseMAS-colormaps",] 
dC <- dC[dC$key_press != 0,]
dC[is.na(dC)] = 0


#Exclude practice trials
dC <- dC[dC$question_order == "exp",] #change to == "exp"



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
#Removes 11 people


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



#loop through each subject ID and create a csv file for each one -Slower
for (i in 1:nSlow){
  print(subjectsSlow[i])
  output[[i]]<- dW2Slow[dW2Slow$subjectID == subjectsSlow[i],]
  write.csv(data.frame(output[[i]]), file = paste0(i, "-Slow-rtdata.csv"), row.names = FALSE)
  output2[[i]]<- dW2bSlow[dW2bSlow$subjectID == subjectsSlow[i],]
  write.csv(data.frame(output2[[i]]), file = paste0(i, "-Slow-accuracydata.csv"), row.names = FALSE)
  
  
}


#loop through each subject ID and create a csv file for each one
for (i in 1:nShort){
  print(subjectsShort[i])
  output[[i]]<- dW2Short[dW2Short$subjectID == subjectsShort[i],]
  write.csv(data.frame(output[[i]]), file = paste0(i, "-Short-rtdata.csv"), row.names = FALSE)
  output2[[i]]<- dW2bShort[dW2bShort$subjectID == subjectsShort[i],]
  write.csv(data.frame(output2[[i]]), file = paste0(i, "-Short-accuracydata.csv"), row.names = FALSE)
  
}

#STOP HERE













# Prune RT +- 2SD from each participant's mean ---------------------------

dC2 = dC[dC$correct == 1,]


#Create a datatable and get the mean and Standard deviation of the response times for each participant
SubjMean = aggregate(dC2$rt, by = list(dC2$subjectID), FUN = mean)
SubjMean2 = aggregate(dC2$rt, by = list(dC2$subjectID), FUN = sd)

#rename columns
names(SubjMean)[names(SubjMean) == "Group.1"] <- "subjectID"
names(SubjMean)[names(SubjMean) == "x"] <- "mean"
names(SubjMean2)[names(SubjMean2) == "Group.1"] <- "subjectID"
names(SubjMean2)[names(SubjMean2) == "x"] <- "stdev"

#Combine above tables and get +- 2SD from mean for each
SubjMean3 <- merge(SubjMean,SubjMean2, by = "subjectID") 
SubjMean3$stdevPlus2 = SubjMean3$mean + 2*SubjMean3$stdev
SubjMean3$stdevMinus2 = SubjMean3$mean - 2*SubjMean3$stdev

#add to main data table
dC2 <- merge(dC2,SubjMean3, by = "subjectID") 


#Compared RT for each trial with the upper/lower bounds (+- 2SD) & eliminate rows outside the bounds
dC3 = dC2[(dC2$rt < dC2$stdevPlus2) & (dC2$rt > dC2$stdevMinus2),]




# Plot data ---------------------------------------------------------------


#Plot graph with dark is more of the CONCEPT - fix this

#Get subject means by
#dSubj <- dC %>% 
#  group_by(subjectID) %>% 
#  summarise(mean_rt = mean(rt))



#Get subject means by condition
dSubj <- dC3 %>% 
  group_by(subjectID, darkMoreConceptStr, conditionProtoStr, colorScaleStr) %>% 
  summarise(mean_rt = mean(rt))

#Get means and standard error for each condition,across participants
dC.summaryagg <- dSubj %>%
  group_by( conditionProtoStr,colorScaleStr, darkMoreConceptStr) %>%
  summarise(
    sd = sd(mean_rt, na.rm = TRUE),
    mean_rt = mean(mean_rt),
    N    = length(mean_rt/subjectID),
    se   = sd / sqrt(N)
  )

dC.summaryagg



#Plot the data
plotPoint = ggplot(data=dC.summaryagg, aes(x = conditionProtoStr, y = mean_rt, fill = darkMoreConceptStr)) +
  geom_bar(stat='identity', position=position_dodge(.9), width=.5) +
  facet_grid(~colorScaleStr)+
  scale_color_hue()+
  geom_errorbar(aes(ymin = mean_rt-se, ymax = mean_rt+se),width = 0.2, position = position_dodge(.9)) + 
  labs(y = 'Response Time', x = 'Trial type') 
plotPoint






# -------------------------------------------------------------------------

#CALCULATING ERROR (from Cousineau (2005))

# subtract each subject's overall mean to eliminate subject over all
# biases, and then add back in grand mean 

#SubjMean = mean(ColormapOut,2)
#Get subject means by
dSubj <- dC2 %>% 
  group_by(subjectID) %>% 
  summarise(mean_rt = mean(rt))


#GrandMean = mean(SubjMean);
dMean = mean(dSubj$mean_rt)

#error bars for data averaged over legend text
#S1HiLoAdjVals = S1HiLo - SubjMean + GrandMean;
#S2HiLoAdjVals = S2HiLo - SubjMean + GrandMean;

dC.summaryagg <- dC2 %>%
  group_by( conditionProtoStr,colorScaleStr, darkMoreConceptStr) %>%
  summarise(mean_rt = mean(rt))

dC.summaryagg$corMean = dC.summaryagg$mean_rt - dSubj$mean_rt + dMean




dC.summaryagg <- dC2 %>%
  group_by( conditionProtoStr,colorScaleStr, darkMoreConceptStr) %>%
  summarise(
    
    sd = sd(rt, na.rm = TRUE),
    rt = mean(rt),
    N    = length(rt/subjectID),
    se   = sd / sqrt(N)
  )
dC.summaryagg


#S1HiLo_SEM = std(S1HiLoAdjVals')./sqrt(n); %error bars for color scale 1
#S2HiLo_SEM = std(S2HiLoAdjVals')./sqrt(n); %error bars for color scale 2

#%error bars for data seprated by legend text
#S1AdjVals = S1Ord - SubjMean + GrandMean; 
#S2AdjVals = S2Ord - SubjMean + GrandMean; 




#Plot the data
plotPoint = ggplot(data=dC.summaryagg, aes(x = conditionProtoStr, y = mean_rt, fill = darkMoreConceptStr)) +
  geom_bar(stat='identity', position=position_dodge(.9), width=.5) +
  facet_grid(~colorScaleStr)+
  scale_color_hue()+
  geom_errorbar(aes(ymin = mean_rt-se, ymax = mean_rt+se),width = 0.2, position = position_dodge(.9)) + 
  labs(y = 'Response Time', x = 'Trial type') 
plotPoint










# old ---------------------------------------------------------------------



#Plot graph with dark is more of the QUANTITY
dC3.summary <- dC3 %>%
  group_by( conditionProtoStr, darkMoreConceptStr, conceptOrient) %>%
  summarise(
    sd = sd(rt, na.rm = TRUE),
    rt = mean(rt),
    N    = length(rt/subjectID),
    se   = sd / sqrt(N)
  )
dC3.summary


plotPoint2 = ggplot(data=dC3.summary, aes(x = conceptOrient, y = rt, fill = darkMoreConceptStr)) +
  geom_bar(stat='identity', position=position_dodge(.9), width=.5) +
  facet_grid(~conditionProtoStr)+
  scale_color_hue()+
  #theme_dark()+
  geom_errorbar(aes(ymin = rt-se, ymax = rt+se),width = 0.2, position = position_dodge(.9)) + 
  labs(y = 'Response Time', x = 'Trial type') +
  ylim(0,1600)
plotPoint2






#Plot graph with dark is more of the QUANTITY
dC3.summary <- dC3 %>%
  group_by( conditionProtoStr, darkMoreQuantityStr, quantOrient) %>%
  summarise(
    sd = sd(rt, na.rm = TRUE),
    rt = mean(rt),
    N    = length(rt/subjectID),
    se   = sd / sqrt(N)
  )
dC3.summary


plotPoint2 = ggplot(data=dC3.summary, aes(x = quantOrient, y = rt, fill = darkMoreQuantityStr)) +
  geom_bar(stat='identity', position=position_dodge(.9), width=.5) +
  facet_grid(~conditionProtoStr)+
  scale_color_hue()+
  #theme_dark()+
  geom_errorbar(aes(ymin = rt-se, ymax = rt+se),width = 0.2, position = position_dodge(.9)) + 
  labs(y = 'Response Time', x = 'Trial type') +
  ylim(0,1600)
plotPoint2




