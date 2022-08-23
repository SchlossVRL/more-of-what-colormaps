
%% CHECK OVERALL ACCURACY

% combine grid and concentric conditions to check accuracy
Sloweracc = [Exp2.Slower.LoadAcc];
Shorteracc =[Exp2.Shorter.LoadAcc];

% calculate overall accruacy
SlowerpropAcc = squeeze(mean(mean(Sloweracc,1),2));
ShorterpropAcc = squeeze(mean(mean(Shorteracc,1),2));

% check if accuracy is > 90%
Slowerhigh = find(SlowerpropAcc > .9);
Shorterhigh = find(ShorterpropAcc > .9);

% Grab RT data from people who were greater that 90% accurate
Slower.RT = Exp2.Slower.LoadRT(:,:,Slowerhigh);    
Shorter.RT = Exp2.Shorter.LoadRT(:,:,Shorterhigh);    

% Grab accuracy data from people who were greater that 90% accurate
Slower.Acc = Exp2.Slower.LoadAcc(:,:,Slowerhigh);    
Shorter.Acc = Exp2.Shorter.LoadAcc(:,:,Shorterhigh);    

%% PRUNE RTs

[Slower.AvgRTsubj] = PruneRTs_MAS(Slower.RT, Slower.Acc);
[Shorter.AvgRTsubj] = PruneRTs_MAS(Shorter.RT, Shorter.Acc);

%% MAKE FIGURES FOR COLORMAP TASK
% % UNCOMMENT HERE TO THE END TO CREATE OUTPUT FILES FOR SPSS

  %[Slower.output, Slower.output2, Slower.output4] = PlotColormaps_MAS( Slower.AvgRTsubj, ' Slower', 'Blue', 'Hot', 1, 1000, 1600);
 % [Shorter.output, Shorter.output2, Shorter.output4] = PlotColormaps_MAS( Shorter.AvgRTsubj, ' Shorter', 'Blue', 'Hot', 11, 1000, 1600);

%% Create output for SPSS ANOVAs

% %FULL DATA set
% SlowerCond = zeros(length(Slower.output),1);
% Slower.outputAll = [SlowerCond, Slower.output];
% ShorterCond = ones(length(Shorter.output),1);
% Shorter.outputAll = [ShorterCond, Shorter.output];
% 
% SPSS_outAll = [Slower.outputAll;  Shorter.outputAll];
% 
%  dlmwrite('Exp2_SPSS_outAll.csv', SPSS_outAll);

%    