function [ColormapOut ColormapOut2 ColormapOut4] = PlotColormaps_MAS( Data,  Condition, S1name, S2name, figNum, yminimum, ymaximum )

% Data = Faster1.AvgRTsubj; 
% Condition = ' Faster';
% S1name = 'Blue';
% S2name = 'Hot';
% figNum = 1;
% yminimum = 1000;
% ymaximum = 1600;
% 


% Data has the following structure:
%within the 32 rows, 1-16 is color scale 1, 17-32 is color scale 2. 
%within each color scale, 1-8 is dark hotspot, 9-16 is light hotspot 
%within each hotspot, 1-4 is dark on the left, 5-8 is dark on the right.
%within each lighntess side, 1-2 the scale is oreinted so dark high, 3-4 is dark low 
%within each scale orientation, 1 is greater high, 2 is greater low.    
%columns are subjects (data has already been aggregated across images)

%COLORMAP WHAT
% within the 16 rows, 1-8 is 'blue', 9-16 is 'hot' color scale. 
    % within each color scale, 1-4 is dark on the left, 5-8 is dark on the right.
    % within each lighntess side, 1-2 the scale is oriented so dark high, 3-4 is dark low 
    % within each scale orientation, 1 is target high, 2 is target low.    
% columns are subjects (data has already been aggregated across images)
%Data =  Grid.AvgRTsubj_GC
n = size(Data,2);

%separate color scales
S1Data = Data(1:8,:); %Blue colorscale
S2Data = Data(9:16,:); %Hot colorscale

%combine whether darker was on the left or right for each color scale
S1LR(1:4,:) =  (S1Data(1:4,:) + S1Data(5:8,:))/2; 
%S1LR(5:8,:) =  (S1Data(9:12,:) + S1Data(13:16,:))/2; %hotspot is light

S2LR(1:4,:) =  (S2Data(1:4,:) + S2Data(5:8,:))/2; 
%S2LR(5:8,:) =  (S2Data(9:12,:) + S2Data(13:16,:))/2; %hotspot is light

%want to average over the two trials that are the same except which side
%the dark is on. 

%rows are currently scale orientation  dark high (1-2) dark low(3-4)
%with in those, legend text is target-high (1), target-low (2)

% within the 16 rows, 1-8 is 'blue', 9-16 is 'hot' color scale. 
    % within each color scale, 1-4 is dark on the left, 5-8 is dark on the right.
    % within each lighntess side, 1-2 the scale is oreinted so dark high, 3-4 is dark low 
    % within each scale orientation, 1 is target high, 2 is target low.    
% columns are subjects (data has already been aggregated across images)

%want the order: 
%D+, L+ when greater is high (1,3), and D+, l+ when greater is low (4,2). 
%1 & 4 are D+ concept and 3 & 2 are L+ concept
%1 & 3 are target HI, 4 & 2 are target low (so for congruent condition-
%greater is high for 1 & 3, for incongruent, target is high for 4 & 2)

%dark more of the quantity (faster/slower is opposite of concept)
if (Condition == " Faster" || Condition == " Slower" || Condition == " Rank")
    Ord = [3 1 2 4];%[2 4 3 1];% %1 & 4 are L+ quantity and 3 & 2 are D+ quantity
else
    Ord = [1 3 4 2];
end  


S1Ord = S1LR(Ord,:); 
S2Ord = S2LR(Ord,:); 


%Output for comparing with legend text
%ColormapOut = [S1Ord',S2Ord'];

S1Avg = mean(S1Ord,2);
S2Avg = mean(S2Ord,2);


% Reorder for SPSS output so it is quant hi; d+/L+, quant lo; d+/L+
if (Condition == " Faster" || Condition == " Shorter" || Condition == " Rank")
   Ord2F = [3 1 4 2];
else
   Ord2F = [1 2 3 4];
end
S1OrdF = S1Ord(Ord2F,:);
S2OrdF = S2Ord(Ord2F,:); 
ColormapOut = [S1OrdF',S2OrdF'];


%% Averaging over only color scale

%Average S1 & S2 so only have D+ and L+ 
SBothAll = (S1Ord + S2Ord)/2; 

%Output for comparing without legend text
ColormapOut4 = [SBothAll'];

SBothAllAvg = mean(SBothAll,2);


%% Averaging over legend text for each color scale

%Average the new 1 % 3 (D+:  quant+ hi and quant+low) & 2 & 4 (L+: quant+ hi &
%quant+ lo)
%low)
S1HiLo =  (S1Ord([1 2], :) + S1Ord([3 4], :))/2;
S2HiLo =  (S2Ord([1 2], :) + S2Ord([3 4], :))/2;

%Output for comparing without legend text
ColormapOut2 = [S1HiLo',S2HiLo'];

S1HiLoAvg = mean(S1HiLo,2);
S2HiLoAvg = mean(S2HiLo,2);

%% Averaging over color scale & legend text 

%Average S1 & S2 so only have D+ and L+ 
SBothHiLo = (S1HiLo([1 2],:) + S2HiLo([1 2],:))/2; 

%Output for comparing without legend text
ColormapOut3 = [SBothHiLo'];

SBothHiLoAvg = mean(SBothHiLo,2);


%% CALCULATING ERROR (from Cousineau (2005))

% subtract each subject's overall mean to eliminate subject over all
% biases, and then add back in grand mean 
 
SubjMean = mean(ColormapOut,2)';
GrandMean = mean(SubjMean);

%error bars for data full data
 S1AdjVals = S1Ord - SubjMean + GrandMean; 
 S2AdjVals = S2Ord - SubjMean + GrandMean; 

 S1_SEM = std(S1AdjVals')./sqrt(n); %error bars for color scale 1
 S2_SEM = std(S2AdjVals')./sqrt(n); %error bars for color scale 2
 
 
%error bars for data averaged over just colorscale
SBothAllAvgVals = SBothAll - SubjMean + GrandMean;
SBothAll_SEM = std(SBothAllAvgVals')./sqrt(n); %error bars for both averaged color scales
  

%error bars for data averaged over just legend text
 S1HiLoAdjVals = S1HiLo - SubjMean + GrandMean;
 S2HiLoAdjVals = S2HiLo - SubjMean + GrandMean;

 S1HiLo_SEM = std(S1HiLoAdjVals')./sqrt(n); %error bars for color scale 1
 S2HiLo_SEM = std(S2HiLoAdjVals')./sqrt(n); %error bars for color scale 2


%error bars for data averaged over legend text and colorscale
 SBothHiLoAdjVals = SBothHiLo - SubjMean + GrandMean;
 SBothHiLo_SEM = std(SBothHiLoAdjVals')./sqrt(n); %error bars for both averaged color scales
    
%% Plot data separately for color scales, averaged over legend text (Output2)
S1HiLoPlot = reshape(S1HiLoAvg,2,1)';%2,2)';
S2HiLoPlot = reshape(S2HiLoAvg,2,1)';

S1HiLo_SEMplot = reshape(S1HiLo_SEM,2,1)';
S2HiLo_SEMplot = reshape(S2HiLo_SEM,2,1)';

%used for x axis labels
if (Condition == " Faster" || Condition == " Slower" || Condition == " Rank")%- dark more concept
    Cond = {'D+ #\newlineL+ C', 'L+ #\newlineD+ C'};
else
    Cond = {'D+ #\newlineD+ C', 'L+ #\newlineL+ C';};
end

leg = {'D+ #', 'L+ #'};
%Cond = {'D+ #', 'L+ #';}; %Dark more quantity
Gray = [.5 .5 .5];
Disp = [0, 1];
TitleInfo = 'Averaged over legOrient';


figure (figNum)
clf
subplot(1,2,1)
    hold on
    
    b = bar(S1HiLoPlot, 'FaceColor', 'flat');
    b(1).CData = [0 0 0];
    b.CData(2,:) = [1 1 1]
    %b(2).CData = [1 1 1];
    
    colormap ('gray')
    
    for row = 1:1
        for col = 1:2
            plot([row+Disp(col) row+Disp(col)], [S1HiLoPlot(row,col) - S1HiLo_SEMplot(row,col), S1HiLoPlot(row,col) + S1HiLo_SEMplot(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.07 row+Disp(col)+.07], [S1HiLoPlot(row,col) - S1HiLo_SEMplot(row,col), S1HiLoPlot(row,col) - S1HiLo_SEMplot(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.07 row+Disp(col)+.07], [S1HiLoPlot(row,col) + S1HiLo_SEMplot(row,col), S1HiLoPlot(row,col) + S1HiLo_SEMplot(row,col)],'Color', Gray, 'LineWidth', 1 )
        end
    end
    title (strcat (S1name , Condition) )
    legend(leg)
    ylim([yminimum ymaximum])
    ylabel('Mean Response Time (ms)')
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
    
    
subplot(1,2,2)
hold on
    b = bar(S2HiLoPlot, 'FaceColor', 'flat');
    b(1).CData = [0 0 0];
    b.CData(2,:) = [1 1 1]

   % b(2).CData = [1 1 1];
    
     for row = 1:1
        for col = 1:2
            plot([row+Disp(col) row+Disp(col)], [S2HiLoPlot(row,col) - S2HiLo_SEMplot(row,col), S2HiLoPlot(row,col) + S2HiLo_SEMplot(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.07 row+Disp(col)+.07], [S2HiLoPlot(row,col) - S2HiLo_SEMplot(row,col), S2HiLoPlot(row,col) - S2HiLo_SEMplot(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.07 row+Disp(col)+.07], [S2HiLoPlot(row,col) + S2HiLo_SEMplot(row,col), S2HiLoPlot(row,col) + S2HiLo_SEMplot(row,col)],'Color', Gray, 'LineWidth', 1 )
        end
     end
    
    title (strcat (S2name , Condition) )
    legend(leg)
    ylim([ yminimum ymaximum])
    ylabel('Mean Response Time (ms)')
    legend(leg)
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
    

  %  set(gcf, 'Position',  [529 1041 438 120])
    

%% Plot data separated by color scales and legend text (Full-output)

S1Prep = reshape(S1Avg,2,2)' ;%4)';
S2Prep = reshape(S2Avg,2,2)';

S1_SEMprep = reshape(S1_SEM,2,2)';
S2_SEMprep = reshape(S2_SEM,2,2)';

%re-order the rows so that they are grouped by where more of the concept is 
% for faster/longer, more is the same as where the target is
% for shorter/slower, more is the opposite as where the target is (so flip
% order of second set of bars with first set of bars for just that
% condition)
if (Condition == " Faster" || Condition == " Shorter" || Condition == " Rank")
   Ord2 = [2 1];
else
   Ord2 = [1 2];
end

%used for x axis labels
if (Condition == " Faster" || Condition == " Slower" || Condition == " Rank")%- dark more concept
    Cond = {'More #-Hi\newlineMore C-Lo'; 'More #-Lo\newlineMore C-Hi';};
else
    Cond = {'More #-Hi\newlineMore C-Hi'; 'More #-Lo\newlineMore C-Lo';};
end

S1Plot = S1Prep(Ord2,:);
S2Plot = S2Prep(Ord2,:);

S1_SEMplot = S1_SEMprep(Ord2,:);
S2_SEMplot = S2_SEMprep(Ord2,:);

leg = {'D+ #', 'L+ #'};
%Cond = {'More #-Hi'; 'More #-Lo';};
Gray = [.5 .5 .5];
Disp = [-.15, .15];

figure (figNum*10)
colormap ('gray')
clf
subplot(1,2,1)
hold on
    b = bar(S1Plot, 'FaceColor', 'flat');
    b(1).CData = [0 0 0];
    b(2).CData = [1 1 1];
    
     for row = 1:2
        for col = 1:2
            plot([row+Disp(col) row+Disp(col)], [S1Plot(row,col) - S1_SEMplot(row,col), S1Plot(row,col) + S1_SEMplot(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [S1Plot(row,col) - S1_SEMplot(row,col), S1Plot(row,col) - S1_SEMplot(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [S1Plot(row,col) + S1_SEMplot(row,col), S1Plot(row,col) + S1_SEMplot(row,col)],'Color', Gray, 'LineWidth', 1 )
        end
    end
      
    ylim([ yminimum ymaximum])
    title (strcat (S1name , Condition) )
    legend(leg)
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
    ylabel('Mean Response Time (ms)')
    
   
subplot(1,2, 2)
hold on

    b = bar(S2Plot, 'FaceColor', 'flat');
    b(1).CData = [0 0 0];
    b(2).CData = [1 1 1];
    
     for row = 1:2
        for col = 1:2 
            plot([row+Disp(col) row+Disp(col)], [S2Plot(row,col) - S2_SEMplot(row,col), S2Plot(row,col) + S2_SEMplot(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [S2Plot(row,col) - S2_SEMplot(row,col), S2Plot(row,col) - S2_SEMplot(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [S2Plot(row,col) + S2_SEMplot(row,col), S2Plot(row,col) + S2_SEMplot(row,col)],'Color', Gray, 'LineWidth', 1 )
        end
     end
    
    ylim([ yminimum ymaximum])
    title (strcat (S2name , Condition) )
    legend(leg)
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
    
    %set(gcf, 'Position',  [968 1039 718 123])    
    ylabel('Mean Response Time (ms)')
    

%% Plot data averaged over legend orientation & color scale (Output3)
SBothHiLoPlot = reshape(SBothHiLoAvg,2,1)';%2,2)';

SBothHiLo_SEMplot = reshape(SBothHiLo_SEM,2,1)';

%used for x axis labels
if (Condition == " Faster" || Condition == " Slower" || Condition == " Rank")%- dark more concept
    Cond = {'D+ #\newlineL+ C', 'L+ #\newlineD+ C'};
else
    Cond = {'D+ #\newlineD+ C', 'L+ #\newlineL+ C';};
end
leg = {'D+ #', 'L+ #'};
%Cond = {'D+ #', 'L+ #';}; % 
Gray = [.5 .5 .5];
Disp = [0, 1];
SBothname = ' - Ave. over colorscale/legOrient';

figure (figNum*20)
clf
subplot(1,1,1)
    hold on
    
    b = bar(SBothHiLoPlot, 'FaceColor', 'flat');
    b(1).CData = [0 0 0];
    b.CData(2,:) = [1 1 1]
    %b(2).CData = [1 1 1];
    
    colormap ('gray')
    
    for row = 1:1
        for col = 1:2
            plot([row+Disp(col) row+Disp(col)], [SBothHiLoPlot(row,col) - SBothHiLo_SEMplot(row,col), SBothHiLoPlot(row,col) + SBothHiLo_SEMplot(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.07 row+Disp(col)+.07], [SBothHiLoPlot(row,col) - SBothHiLo_SEMplot(row,col), SBothHiLoPlot(row,col) - SBothHiLo_SEMplot(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.07 row+Disp(col)+.07], [SBothHiLoPlot(row,col) + SBothHiLo_SEMplot(row,col), SBothHiLoPlot(row,col) + SBothHiLo_SEMplot(row,col)],'Color', Gray, 'LineWidth', 1 )
        end
    end
    title (strcat (Condition , SBothname) )
    legend(leg)
    ylim([yminimum ymaximum])
    ylabel('Mean Response Time (ms)')
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
   


%% Plot data averaged over just color scale (not leg orientation) (Output4)
SBothAllPrep = reshape(SBothAllAvg,2,2)';%2,2)';

SBothAll_SEMPrep = reshape(SBothAll_SEM,2,2)';


%re-order the rows so that they are grouped by where more of the concept is 
% for faster/longer, more is the same as where the target is
% for shorter/slower, more is the opposite as where the target is (so flip
% order of second set of bars with first set of bars for just that
% condition)
%used for x axis labels
if (Condition == " Faster" || Condition == " Slower" || Condition == " Rank")%- dark more concept
    Cond = {'More #-Hi\newlineMore C-Lo'; 'More #-Lo\newlineMore C-Hi';};
else
    Cond = {'More #-Hi\newlineMore C-Hi'; 'More #-Lo\newlineMore C-Lo';};
end


%dark more of the quantity- used for ordering bars - dont need anymore
%because already reordered
if (Condition == " Faster" || Condition == " Shorter" || Condition == " Rank")
   Ord2 = [2 1];
else
   Ord2 = [1 2];
end


SAllPlot = SBothAllPrep(Ord2,:);
SBothname = ' - Ave. over colorscale';

SAll_SEMplot = SBothAll_SEMPrep(Ord2,:);

leg = {'D+ #', 'L+ #'};
Gray = [.5 .5 .5];
Disp = [-.15, .15];

figure (figNum*30)
colormap ('gray')
clf
subplot(1,1,1)
hold on
    b = bar(SAllPlot, 'FaceColor', 'flat');
    b(1).CData = [0 0 0];
    b(2).CData = [1 1 1];
    
     for row = 1:2
        for col = 1:2
            plot([row+Disp(col) row+Disp(col)], [SAllPlot(row,col) - SAll_SEMplot(row,col), SAllPlot(row,col) + SAll_SEMplot(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot(row,col) - SAll_SEMplot(row,col), SAllPlot(row,col) - SAll_SEMplot(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot(row,col) + SAll_SEMplot(row,col), SAllPlot(row,col) + SAll_SEMplot(row,col)],'Color', Gray, 'LineWidth', 1 )
        end
    end
      
    ylim([ yminimum ymaximum])
    title (strcat (Condition, SBothname) )
    legend(leg)
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
    ylabel('Mean Response Time (ms)')
    
   

end