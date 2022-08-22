function [ColormapOut, ColormapOut4] = PlotColormaps_MAS_All( Data1, Data2, Data3, Data4, Data5, Condition1,Condition2,Condition3, S1name, S2name, figNum, yminimum, ymaximum )

%  Data1 = Faster1.AvgRTsubj; 
%   Data2 = Slower.AvgRTsubj; 
%   Data3 = FasterNoLab.AvgRTsubj; 
%   Data4 = FasterSoil.AvgRTsubj; 
%   Data5 = Rank.AvgRTsubj;
% 
% Condition = ' Faster';
% S1name = 'Blue';
% S2name = 'Hot';
% figNum = 1;
% yminimum = 1000;
% ymaximum = 1600;


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

for exp = 1:5  
    if (exp == 1)
        Data1 = Data1 %because faster condition has 31 participants, separate from the other 3  (Data1 vs Data)
        Condition = Condition1
    elseif (exp == 2)
        Data = Data2
        Condition = Condition2 %slower/shorter
    elseif (exp == 3)
        Data = Data3
        Condition = Condition1
    elseif (exp == 4)
        Data = Data4
        Condition = Condition1
    elseif (exp == 5)
        Data = Data5
        Condition = Condition3 %rank/index
    end
    
 %reorder data dark more concept / more concept hi
%     if (Condition == " Shorter" || Condition == " Slower")
%        Ord = [2 4 3 1];%[3 1 2 4]; %1 & 4 are L+ quantity and 3 & 2 are D+ quantity
%             %Ord = [3 1 2 4]; %1 & 4 are L+ quantity and 3 & 2 are D+ quantity
%     else
         Ord = [1 3 4 2];
%     end   

    
 %used for x axis labels
    if (Condition == " Faster" || Condition == " Slower" || Condition == " Rank")%- dark more concept
        Cond = {'More C-Hi\newlineMore #-Lo';'More C-Lo\newlineMore #-Hi';};
    else
        Cond = {'More C-Hi\newlineMore #-Hi'; 'More C-Lo\newlineMore #-Lo';};
    end


  
    % Exp. 1 (faster/longer w/ labels- faster condition has 31  participants) 
    if exp == 1
        n = size(Data1,2);

        %separate color scales
        S1Data1 = Data1(1:8,:); %Blue colorscale
        S2Data1 = Data1(9:16,:); %Hot colorscale

        %combine whether darker was on the left or right for each color scale
        S1LR1(1:4,:) =  (S1Data1(1:4,:) + S1Data1(5:8,:))/2; 
        S2LR1(1:4,:) =  (S2Data1(1:4,:) + S2Data1(5:8,:))/2;

        S1Ord1 = S1LR1(Ord,:); 
        S2Ord1 = S2LR1(Ord,:); 

        %Output for comparing with legend text
        ColormapOut1 = [S1Ord1',S2Ord1'];

        S1Avg1 = mean(S1Ord1,2);
        S2Avg1 = mean(S2Ord1,2);

        %Average S1 & S2 so only have D+ and L+ 
        SBothAll1 = (S1Ord1 + S2Ord1)/2; 

        %Output for comparing without legend text
        ColormapOut4 = [SBothAll1'];

        %Average 
        SBothAllAvg1 = mean(SBothAll1,2);


        % CALCULATING ERROR (from Cousineau (2005))
         % subtract each subject's overall mean to eliminate subject over all
         % biases, and then add back in grand mean 
        SubjMean1 = mean(ColormapOut1,2)';
        GrandMean1 = mean(SubjMean1);

        %error bars for data averaged over just colorscale
        SBothAllAvgVals1 = SBothAll1 - SubjMean1 + GrandMean1;
        SBothAll_SEM1 = std(SBothAllAvgVals1')./sqrt(n); %error bars for both averaged color scales

        
     %dark more of the concept- used for ordering bars
    if (Condition == " Slower" || Condition == " Shorter")
        Ord2 = [2 1];
    else
        Ord2 = [1 2];
    end 
                
        % Plot data averaged over just color scale (not leg orientation) (Output4)
        SBothAllPrep1 = reshape(SBothAllAvg1,2,2)';
        SBothAll_SEMPrep1 = reshape(SBothAll_SEM1,2,2)';
        SAllPlot1 = SBothAllPrep1(Ord2,:);
        SBothname1 = ' - Aliens w/ labels';
        SAll_SEMplot1 = SBothAll_SEMPrep1(Ord2,:);


    %for experiments 2-5
    elseif exp ~= 1

        n = size(Data,2);

        %separate color scales
        S1Data = Data(1:8,:); %Blue colorscale
        S2Data = Data(9:16,:); %Hot colorscale

        %combine whether darker was on the left or right for each color scale
        S1LR(1:4,:) =  (S1Data(1:4,:) + S1Data(5:8,:))/2; 
        S2LR(1:4,:) =  (S2Data(1:4,:) + S2Data(5:8,:))/2;
        S1Ord = S1LR(Ord,:); 
        S2Ord = S2LR(Ord,:); 

        %Output for comparing with legend text
        ColormapOut = [S1Ord',S2Ord'];
        S1Avg = mean(S1Ord,2);
        S2Avg = mean(S2Ord,2);

        %Average S1 & S2 so only have D+ and L+ 
        SBothAll = (S1Ord + S2Ord)/2; 

        %Output for comparing without legend text
        ColormapOut4 = [SBothAll'];
        SBothAllAvg = mean(SBothAll,2);


        % CALCULATING ERROR (from Cousineau (2005))
        % subtract each subject's overall mean to eliminate subject over all
        % biases, and then add back in grand mean 
        SubjMean = mean(ColormapOut,2)';
        GrandMean = mean(SubjMean);

        %error bars for data averaged over just colorscale
        SBothAllAvgVals = SBothAll - SubjMean + GrandMean;
        SBothAll_SEM = std(SBothAllAvgVals')./sqrt(n); %error bars for both averaged color scales

        
        
     %dark more of the concept- used for ordering bars
    if (Condition == " Slower" || Condition == " Shorter")
        Ord2 = [2 1];
    else
        Ord2 = [1 2];
    end 
    
    
        % Plot data averaged over just color scale (not leg orientation) (Output4)
        if (exp == 2)
            SBothAllPrep2 = reshape(SBothAllAvg,2,2)';
            SBothAll_SEMPrep2 = reshape(SBothAll_SEM,2,2)' ; 
            SAllPlot2 = SBothAllPrep2(Ord2,:);
            SBothname2 = ' -Aliens w/ labels';
            SAll_SEMplot2 = SBothAll_SEMPrep2(Ord2,:);
        elseif (exp == 3)
            SBothAllPrep3 = reshape(SBothAllAvg,2,2)';
            SBothAll_SEMPrep3 = reshape(SBothAll_SEM,2,2)';
            SAllPlot3 = SBothAllPrep3(Ord2,:);
            SBothname3 = ' -Aliens w/o labels';
            SAll_SEMplot3 = SBothAll_SEMPrep3(Ord2,:);
        elseif (exp == 4)
            SBothAllPrep4 = reshape(SBothAllAvg,2,2)';
            SBothAll_SEMPrep4 = reshape(SBothAll_SEM,2,2)';
            SAllPlot4 = SBothAllPrep4(Ord2,:);
            SBothname4 = ' - Soil w/ labels';
            SAll_SEMplot4 = SBothAll_SEMPrep4(Ord2,:);
        elseif (exp == 5)
            SBothAllPrep5 = reshape(SBothAllAvg,2,2)';
            SBothAll_SEMPrep5 = reshape(SBothAll_SEM,2,2)';
            SAllPlot5 = SBothAllPrep5(Ord2,:);
            SBothname5 = ' - Health w/ labels';
            SAll_SEMplot5 = SBothAll_SEMPrep5(Ord2,:);
        end

    end

end

%% Plot the data

%Set up figure
leg = {'D+ C', 'L+ C'};
Gray = [.5 .5 .5];
Disp = [-.15, .15];

figure (figNum)
colormap ('gray')
clf
    

%Faster/Longer aliens with labels   
subplot(1,5,1)
hold on

b = bar(SAllPlot1, 'FaceColor', 'flat');
b(1).CData = [0 0 0];
b(2).CData = [1 1 1];

     for row = 1:2
        for col = 1:2
            plot([row+Disp(col) row+Disp(col)], [SAllPlot1(row,col) - SAll_SEMplot1(row,col), SAllPlot1(row,col) + SAll_SEMplot1(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot1(row,col) - SAll_SEMplot1(row,col), SAllPlot1(row,col) - SAll_SEMplot1(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot1(row,col) + SAll_SEMplot1(row,col), SAllPlot1(row,col) + SAll_SEMplot1(row,col)],'Color', Gray, 'LineWidth', 1 )
        end
    end

    ylim([ yminimum ymaximum])
    title (strcat (Condition1, SBothname1) )
    legend(leg)
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
    ylabel('Mean Response Time (ms)')

    
    
%Slower/shorter aliens with labels   
subplot(1,5,2)
hold on

b = bar(SAllPlot2, 'FaceColor', 'flat');
b(1).CData = [0 0 0];
b(2).CData = [1 1 1];

     for row = 1:2
        for col = 1:2
            plot([row+Disp(col) row+Disp(col)], [SAllPlot2(row,col) - SAll_SEMplot2(row,col), SAllPlot2(row,col) + SAll_SEMplot2(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot2(row,col) - SAll_SEMplot2(row,col), SAllPlot2(row,col) - SAll_SEMplot2(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot2(row,col) + SAll_SEMplot2(row,col), SAllPlot2(row,col) + SAll_SEMplot2(row,col)],'Color', Gray, 'LineWidth', 1 )
        end
    end

    ylim([ yminimum ymaximum])
    title (strcat (Condition2, SBothname2) )
    legend(leg)
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
    ylabel('Mean Response Time (ms)')
    
    
    
%Faster/Longer aliens without labels   
subplot(1,5,3)
hold on

b = bar(SAllPlot3, 'FaceColor', 'flat');
b(1).CData = [0 0 0];
b(2).CData = [1 1 1];

     for row = 1:2
        for col = 1:2
            plot([row+Disp(col) row+Disp(col)], [SAllPlot3(row,col) - SAll_SEMplot3(row,col), SAllPlot3(row,col) + SAll_SEMplot3(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot3(row,col) - SAll_SEMplot3(row,col), SAllPlot3(row,col) - SAll_SEMplot3(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot3(row,col) + SAll_SEMplot3(row,col), SAllPlot3(row,col) + SAll_SEMplot3(row,col)],'Color', Gray, 'LineWidth', 1 )
        end
    end

    ylim([ yminimum ymaximum])
    title (strcat (Condition1, SBothname3) )
    legend(leg)
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
    ylabel('Mean Response Time (ms)')
      

%Faster/Longer soil with labels   
subplot(1,5,4)
hold on

b = bar(SAllPlot4, 'FaceColor', 'flat');
b(1).CData = [0 0 0];
b(2).CData = [1 1 1];

     for row = 1:2
        for col = 1:2
            plot([row+Disp(col) row+Disp(col)], [SAllPlot4(row,col) - SAll_SEMplot4(row,col), SAllPlot4(row,col) + SAll_SEMplot4(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot4(row,col) - SAll_SEMplot4(row,col), SAllPlot4(row,col) - SAll_SEMplot4(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot4(row,col) + SAll_SEMplot4(row,col), SAllPlot4(row,col) + SAll_SEMplot4(row,col)],'Color', Gray, 'LineWidth', 1 )
        end
    end

    ylim([ yminimum ymaximum])
    title (strcat (Condition1, SBothname4) )
    legend(leg)
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
    ylabel('Mean Response Time (ms)')
 
    
    
    
%Rank/Index health with labels   
subplot(1,5,5)
hold on

b = bar(SAllPlot5, 'FaceColor', 'flat');
b(1).CData = [0 0 0];
b(2).CData = [1 1 1];

     for row = 1:2
        for col = 1:2
            plot([row+Disp(col) row+Disp(col)], [SAllPlot5(row,col) - SAll_SEMplot5(row,col), SAllPlot5(row,col) + SAll_SEMplot5(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot5(row,col) - SAll_SEMplot5(row,col), SAllPlot5(row,col) - SAll_SEMplot5(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot5(row,col) + SAll_SEMplot5(row,col), SAllPlot5(row,col) + SAll_SEMplot5(row,col)],'Color', Gray, 'LineWidth', 1 )
        end
    end

    ylim([ yminimum ymaximum])
    title (strcat (Condition3, SBothname5) )
    legend(leg)
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
    ylabel('Mean Response Time (ms)')

end