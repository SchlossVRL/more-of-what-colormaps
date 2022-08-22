### ### ### ### ### ### ### ### ### 
####   ONLINE COLORMAPS WHAT  #####
### ### ### ### ### ### ### ### ### 


#FASTER/LONGER DATA - No labels

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
setwd("C:/Users/melan/Dropbox/Research/Experiments/ColormapWhat/Analyses/BinTrials-FasterLonger-NoLabels")
#setwd("~/Dropbox/ColormapWhat/Analyses/FasterLonger-NoLabelsData")


#Load in SONA data
d <- read.csv("Exp3.csv") #Update me with name given when exporting from mySQL. 
varDescribe(d)



#workerID = SONA id used for assigning credit 
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
dC <- dC[dC$question_order == "exp" | dC$question_order == "instr",] #change to == "exp"
dC$BinTrial = ifelse(dC$question_order == "instr", 0,
                  ifelse(dC$trial_index > 70 & dC$trial_index < 321, 1,
                         ifelse(dC$trial_index >= 321 & dC$trial_index < 573, 2,
                                ifelse(dC$trial_index >= 573  & dC$trial_index < 825, 3,
                                       ifelse(dC$trial_index >= 825, 4, 10)))))



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



# Exclude participants with < 90% accuracy ---------------------------------

#Count number of correct responses (total possible = 320)
BadAcc = aggregate(dC$correct, by = list(dC$subjectID), FUN = sum)
BadAcc = BadAcc[BadAcc$x <=288,]
BadAcc

dontuseAcc <- data.frame(subjectID = BadAcc$Group.1) 

#Remove participants with accuracy 90% ()
dC = anti_join(dC, dontuseAcc)
#Removes 15 people


dC1 = dC


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







# bins based on just pure order in exp.   -------------------------------------------------------

#Subset dataframe to relevant columns- for Response Time
keep = c("subjectID", "conditionProtoStr", "rt", "colorScaleStr", "darkSideStr", "darkLegendOrientStr", "targetOrientStr", "darkMoreConceptStr", "colormap", "BinTrial")
dW = dC1[keep]
dW = dW[with(dW, order(colorScaleStr,darkSideStr,darkLegendOrientStr,targetOrientStr, darkMoreConceptStr, BinTrial, colormap)),]

varDescribeBy(dW, dW$BinTrial)




#reshape so that each column is a colormap
dW2 = reshape(dW, timevar = 'colormap', idvar = c('subjectID', "conditionProtoStr", "colorScaleStr", "darkSideStr", "darkLegendOrientStr", "targetOrientStr","darkMoreConceptStr", "BinTrial"), direction = 'wide')
dW2 = dW2[with(dW2, order(conditionProtoStr)),]
 

dW2$AveRT = rowMeans(dW2[,8:27], na.rm = T)


#subset to faster/longer conditions- RT
dW2Fast = dW2[dW2$conditionProtoStr == "faster",]
dW2Long = dW2[dW2$conditionProtoStr == "longer",]



dW2.summaryagg <- dW2 %>%
  group_by( conditionProtoStr, darkMoreConceptStr, BinTrial) %>%
  summarise(
    
    sd = sd(AveRT, na.rm = TRUE),
    AveRT = mean(AveRT),
    N    = length(AveRT/subjectID),
    se   = sd / sqrt(N)
  )
dW2.summaryagg


#Plot the data
plotPoint = ggplot(data=dW2.summaryagg, aes(x = BinTrial, y = AveRT, color = darkMoreConceptStr)) +
  geom_point(size = 4)+#(stat='identity')+#, position=position_dodge(.9), width=.5) +
  geom_line(size = 2)+
  facet_grid(~conditionProtoStr)+
  scale_color_grey()+
  theme_dark()+
  geom_vline(xintercept = 0.5, color = "white", linetype = "dashed")+
  geom_errorbar(aes(ymin = AveRT-se, ymax = AveRT+se), width = .2) + 
  labs(y = 'Response Time', x = 'Trial type') 
plotPoint


#Plot the data
plotPoint = ggplot(data=dW2.summaryagg, aes(x = BinTrial, y = AveRT, color = conditionProtoStr)) +
  geom_point()+#(stat='identity')+#, position=position_dodge(.9), width=.5) +
  geom_line()+
  facet_grid(~darkMoreConceptStr)+
  scale_color_hue()+
  geom_errorbar(aes(ymin = AveRT-se, ymax = AveRT+se), width = .2) + 
  labs(y = 'Response Time', x = 'Trial type') 
plotPoint






#Plot the data
plotPoint = ggplot(data=dW2.summaryagg, aes(x = BinTrial, y = AveRT, color = darkMoreConceptStr)) +
  geom_point()+#(stat='identity')+#, position=position_dodge(.9), width=.5) +
  facet_grid(~conditionProtoStr)+
  scale_color_hue()+
  geom_errorbar(aes(ymin = AveRT-se, ymax = AveRT+se),width = 0.2, position = position_dodge(.9)) + 
  labs(y = 'Response Time', x = 'Trial type') 
plotPoint





# Bins based on the first 5 of each condition = bin 1, next 5 = bin 2, etc. -------------------------------------------------------

#Subset dataframe to relevant columns- for Response Time
keep = c("subjectID", "conditionProtoStr", "rt", "colorScaleStr", "darkSideStr", "darkLegendOrientStr", "targetOrientStr", "darkMoreConceptStr", "colormap","trial_index", "BinTrial")
dW = dC1[keep]
dW = dW[with(dW, order(subjectID, colorScaleStr,darkSideStr,darkLegendOrientStr,targetOrientStr, darkMoreConceptStr, trial_index, colormap)),]

varDescribeBy(dW, dW$BinTrial)
#write.csv(dW, "binTrialsTest.csv")

d2 = read.csv("binTrialsTest.csv")
keep = c("subjectID", "conditionProtoStr", "rt", "colorScaleStr", "darkSideStr", "darkLegendOrientStr", "targetOrientStr", "darkMoreConceptStr", "colormap", "BinTrial2")
d22 = d2[keep]

#reshape so that each column is a colormap
dW2 = reshape(d22, timevar = 'colormap', idvar = c('subjectID', "conditionProtoStr", "colorScaleStr", "darkSideStr", "darkLegendOrientStr", "targetOrientStr","darkMoreConceptStr", "BinTrial2"), direction = 'wide')
dW2 = dW2[with(dW2, order(conditionProtoStr)),]


dW2$AveRT = rowMeans(dW2[,9:28], na.rm = T)
varDescribeBy(dW2, dW2$BinTrial2)

#subset to faster/longer conditions- RT
dW2Fast = dW2[dW2$conditionProtoStr == "faster",]
dW2Long = dW2[dW2$conditionProtoStr == "longer",]



dW2.summaryagg <- dW2 %>%
  group_by( conditionProtoStr, darkMoreConceptStr, BinTrial2) %>%
  summarise(
    
    sd = sd(AveRT, na.rm = TRUE),
    AveRT = mean(AveRT),
    N    = length(AveRT/subjectID),
    se   = sd / sqrt(N)
  )
dW2.summaryagg


#Plot the data
plotPoint = ggplot(data=dW2.summaryagg, aes(x = BinTrial2, y = AveRT, color = darkMoreConceptStr)) +
  geom_point(size = 4)+#(stat='identity')+#, position=position_dodge(.9), width=.5) +
  geom_line(size = 2)+
  facet_grid(~conditionProtoStr)+
  scale_color_grey()+
  theme_dark()+
  geom_vline(xintercept = 0.5, color = "white", linetype = "dashed")+
  geom_errorbar(aes(ymin = AveRT-se, ymax = AveRT+se), width = .2) + 
  labs(y = 'Response Time', x = 'Trial Bin') 
plotPoint




