
%% CHECK OVERALL ACCURACY

% Load conditions to check accuracy
FasterSoilacc = [Exp4.Faster.LoadAcc];
LongerSoilacc =[Exp4.Longer.LoadAcc];

% calculate overall accruacy
FasterSoilpropAcc = squeeze(mean(mean(FasterSoilacc,1),2));
LongerSoilpropAcc = squeeze(mean(mean(LongerSoilacc,1),2));

% check if accuracy is > 90%
FasterSoilhigh = find(FasterSoilpropAcc > .9);
LongerSoilhigh = find(LongerSoilpropAcc > .9);

% Grab RT data from people who were greater that 90% accurate
FasterSoil.RT = Exp4.Faster.LoadRT(:,:,FasterSoilhigh);    
LongerSoil.RT = Exp4.Longer.LoadRT(:,:,LongerSoilhigh);    

% Grab accuracy data from people who were greater that 90% accurate
FasterSoil.Acc = Exp4.Faster.LoadAcc(:,:,FasterSoilhigh);    
LongerSoil.Acc = Exp4.Longer.LoadAcc(:,:,LongerSoilhigh);    

%% PRUNE RTs

[FasterSoil.AvgRTsubj] = PruneRTs_MAS(FasterSoil.RT, FasterSoil.Acc);
[LongerSoil.AvgRTsubj] = PruneRTs_MAS(LongerSoil.RT, LongerSoil.Acc);

%% MAKE FIGURES FOR COLORMAP TASK
% UNCOMMENT HERE TO THE END TO CREATE OUTPUT FILES FOR SPSS

% [FasterSoil.output, FasterSoil.output2, FasterSoil.output4] = PlotColormaps_MAS( FasterSoil.AvgRTsubj, ' Faster', 'Blue', 'Hot', 1, 1000, 1600);
 %[LongerSoil.output, LongerSoil.output2, LongerSoil.output4] = PlotColormaps_MAS( LongerSoil.AvgRTsubj, ' Longer', 'Blue', 'Hot', 11, 1000, 1600);

%% Create output for SPSS ANOVAs
% 
%FULL DATA SET
% FasterSoilCond = zeros(length(FasterSoil.output),1)
% FasterSoil.outputAll = [FasterSoilCond, FasterSoil.output]
% LongerSoilCond = ones(length(LongerSoil.output),1)
% LongerSoil.outputAll = [LongerSoilCond, LongerSoil.output]
% 
% SPSSSoil_outAll = [FasterSoil.outputAll;  LongerSoil.outputAll]
% 
% %header = {'Condition','Blue_tHi_Dm','Blue_tHi_Lm','Blue_tLo_Dm','Blue_tLo_Lm','Hot_tHi_Dm','Hot_tHi_Lm','Hot_tLo_Dm','Hot_tLo_Lm'};
% %SPSS_out = [header2; SPSS_out]
% 
%  dlmwrite('Exp4_SPSS_outAll-dMoreConcept-v3.csv', SPSSSoil_outAll)

%  