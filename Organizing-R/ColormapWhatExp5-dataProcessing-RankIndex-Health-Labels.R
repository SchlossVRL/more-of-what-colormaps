### ### ### ### ### ### ### ### ### 
####   ONLINE COLORMAPS WHAT  #####
### ### ### ### ### ### ### ### ### 


#Rank/Index HEALTH DATA with LABELS

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
setwd("C:/Users/melan/Dropbox/Research/Experiments/ColormapWhat-Lexi/Analyses/RankIndex-Health-Labels")
#setwd("~/Dropbox/ColormapWhat/Analyses/RankIndex-Health-Labels")


#Load in SONA data
d <- read.csv("Exp5.csv") #Update me with name given when exporting from mySQL. 
varDescribe(d)



#workerID = SONA id used for assigning credit 
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
  write.csv(data.frame(output[[i]]), file = paste0(i, "-rank-Health-rtdata.csv"), row.names = FALSE)
  output2[[i]]<- dW2bRank[dW2bRank$subjectID == subjectsRank[i],]
  write.csv(data.frame(output2[[i]]), file = paste0(i, "-rank-Health-accuracydata.csv"), row.names = FALSE)
  
  
}


#loop through each subject ID and create a csv file for each one
for (i in 1:nIndex){
  print(subjectsIndex[i])
  output[[i]]<- dW2Index[dW2Index$subjectID == subjectsIndex[i],]
  write.csv(data.frame(output[[i]]), file = paste0(i, "-index-Health-rtdata.csv"), row.names = FALSE)
  output2[[i]]<- dW2bIndex[dW2bIndex$subjectID == subjectsIndex[i],]
  write.csv(data.frame(output2[[i]]), file = paste0(i, "-index-Health-accuracydata.csv"), row.names = FALSE)
  
}


#STOP HERE
















# Remove incorrect trials -------------------------------------------------

dC = dC[dC$correct == 1,]




# Prune RT +- 2SD from each participant's mean ---------------------------

#Create a datatable and get the mean and Standard deviation of the response times for each participant
SubjMean = aggregate(dC$rt, by = list(dC$subjectID), FUN = mean)
SubjMean2 = aggregate(dC$rt, by = list(dC$subjectID), FUN = sd)

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
dC <- merge(dC,SubjMean3, by = "subjectID") 


#Compared RT for each trial with the upper/lower bounds (+- 2SD) & eliminate rows outside the bounds
dC = dC[(dC$rt < dC$stdevPlus2) & (dC$rt > dC$stdevMinus2),]




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


