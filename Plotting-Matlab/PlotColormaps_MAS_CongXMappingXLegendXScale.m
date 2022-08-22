function [ColormapOut, ColormapOut4] = PlotColormaps_MAS_CongXMappingXLegendXScale( Data1, Data2, Data3, Data4, Data5, Condition1,Condition2,Condition3, S1name, S2name, figNum, yminimum, ymaximum )

%  Data1 = Faster1.AvgRTsubj; 
%   Data2 = Slower.AvgRTsubj; 
%   Data3 = FasterNoLab.AvgRTsubj; 
%   Data4 = FasterSoil.AvgRTsubj; 
%   Data5 = Rank.AvgRTsubj;
% 
% Condition1 = ' Faster';
% Condition2 = ' Slower'; 
% Condition3 = ' Rank'; 
% S1name = 'Blue';
% S2name = 'Hot';
% figNum = 3333;
% yminimum = 1000;
% ymaximum = 1700;


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
        %SBothAll1 = (S1Ord1 + S2Ord1)/2; 

        %Output for comparing without legend text
        ColormapOut4 = ColormapOut1;

        %Average 
        SBothAllAvg1Scale1 = mean(S1Ord1,2);
        SBothAllAvg1Scale2 = mean(S2Ord1,2);

        % CALCULATING ERROR (from Cousineau (2005))
         % subtract each subject's overall mean to eliminate subject over all
         % biases, and then add back in grand mean 
        SubjMean1 = mean(ColormapOut1,2)';
        GrandMean1 = mean(SubjMean1);

        %error bars for data averaged over just colorscale
        SBothAllAvgVals1Scale1 = SBothAllAvg1Scale1 - SubjMean1 + GrandMean1;
        SBothAll_SEM1Scale1 = std(SBothAllAvgVals1Scale1')./sqrt(n); %error bars for both averaged color scales
         SBothAllAvgVals1Scale2 = SBothAllAvg1Scale2 - SubjMean1 + GrandMean1;
        SBothAll_SEM1Scale2 = std(SBothAllAvgVals1Scale2')./sqrt(n); %error bars for both averaged color scales

        
     %dark more of the concept- used for ordering bars
    if (Condition == " Slower" || Condition == " Shorter")
        Ord2 = [2 1];
    else
        Ord2 = [1 2];
    end 
                
        % Plot data averaged over just color scale (not leg orientation) (Output4)
        SBothAllPrep1Scale1 = reshape(SBothAllAvg1Scale1,2,2)';
        SBothAll_SEMPrep1Scale1 = reshape(SBothAll_SEM1Scale1,2,2)';
        SAllPlot1Scale1 = SBothAllPrep1Scale1(Ord2,:);
        SBothname1Scale1 = 'scale1  - Aliens w/ labels';
        SAll_SEMplot1Scale1 = SBothAll_SEMPrep1Scale1(Ord2,:);

        SBothAllPrep1Scale2 = reshape(SBothAllAvg1Scale2,2,2)';
        SBothAll_SEMPrep1Scale2 = reshape(SBothAll_SEM1Scale2,2,2)';
        SAllPlot1Scale2 = SBothAllPrep1Scale2(Ord2,:);
        SBothname1Scale2 = 'scale2 - Aliens w/ labels';
        SAll_SEMplot1Scale2 = SBothAll_SEMPrep1Scale2(Ord2,:);

        
        
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
       % SBothAll = (S1Ord + S2Ord)/2; 

        %Output for comparing without legend text
        ColormapOut4 = ColormapOut;
        SBothAllAvgScale1 = mean(S1Ord,2);
        SBothAllAvgScale2 = mean(S2Ord,2);


        % CALCULATING ERROR (from Cousineau (2005))
        % subtract each subject's overall mean to eliminate subject over all
        % biases, and then add back in grand mean 
        SubjMean = mean(ColormapOut,2)';
        GrandMean = mean(SubjMean);

        %error bars for data averaged over just colorscale
        SBothAllAvgValsScale1 = SBothAllAvgScale1 - SubjMean + GrandMean;
        SBothAll_SEMScale1 = std(SBothAllAvgValsScale1')./sqrt(n); %error bars for both averaged color scales
        SBothAllAvgValsScale2 = SBothAllAvgScale2 - SubjMean + GrandMean;
        SBothAll_SEMScale2 = std(SBothAllAvgValsScale2')./sqrt(n); %error bars for both averaged color scales

        
        
     %dark more of the concept- used for ordering bars
    if (Condition == " Slower" || Condition == " Shorter")
        Ord2 = [2 1];
    else
        Ord2 = [1 2];
    end 
    
    
        % Plot data averaged over just color scale (not leg orientation) (Output4)
        if (exp == 2)
            SBothAllPrep2Scale1 = reshape(SBothAllAvgScale1,2,2)';
            SBothAll_SEMPrep2Scale1 = reshape(SBothAll_SEMScale1,2,2)' ; 
            SAllPlot2Scale1 = SBothAllPrep2Scale1(Ord2,:);
            SBothname2Scale1 = 'Scale1 -Aliens w/ labels';
            SAll_SEMplot2Scale1 = SBothAll_SEMPrep2Scale1(Ord2,:);
            
            SBothAllPrep2Scale2 = reshape(SBothAllAvgScale2,2,2)';
            SBothAll_SEMPrep2Scale2 = reshape(SBothAll_SEMScale2,2,2)' ; 
            SAllPlot2Scale2 = SBothAllPrep2Scale2(Ord2,:);
            SBothname2Scale2 = 'Scale2 -Aliens w/ labels';
            SAll_SEMplot2Scale2 = SBothAll_SEMPrep2Scale2(Ord2,:);
            
        elseif (exp == 3)
            SBothAllPrep3Scale1 = reshape(SBothAllAvgScale1,2,2)';
            SBothAll_SEMPrep3Scale1 = reshape(SBothAll_SEMScale1,2,2)';
            SAllPlot3Scale1 = SBothAllPrep3Scale1(Ord2,:);
            SBothname3Scale1 = 'Scale1 -Aliens w/o labels';
            SAll_SEMplot3Scale1 = SBothAll_SEMPrep3Scale1(Ord2,:);
            
            SBothAllPrep3Scale2 = reshape(SBothAllAvgScale2,2,2)';
            SBothAll_SEMPrep3Scale2 = reshape(SBothAll_SEMScale2,2,2)';
            SAllPlot3Scale2 = SBothAllPrep3Scale2(Ord2,:);
            SBothname3Scale2 = ' Scale2-Aliens w/o labels';
            SAll_SEMplot3Scale2 = SBothAll_SEMPrep3Scale2(Ord2,:);
            
        elseif (exp == 4)
            SBothAllPrep4Scale1 = reshape(SBothAllAvgScale1,2,2)';
            SBothAll_SEMPrep4Scale1 = reshape(SBothAll_SEMScale1,2,2)';
            SAllPlot4Scale1 = SBothAllPrep4Scale1(Ord2,:);
            SBothname4Scale1 = 'Scale1 - Soil w/ labels';
            SAll_SEMplot4Scale1 = SBothAll_SEMPrep4Scale1(Ord2,:);
            
            SBothAllPrep4Scale2 = reshape(SBothAllAvgScale2,2,2)';
            SBothAll_SEMPrep4Scale2 = reshape(SBothAll_SEMScale2,2,2)';
            SAllPlot4Scale2 = SBothAllPrep4Scale2(Ord2,:);
            SBothname4Scale2 = 'Scale2 - Soil w/ labels';
            SAll_SEMplot4Scale2 = SBothAll_SEMPrep4Scale2(Ord2,:);
            
        elseif (exp == 5)
            SBothAllPrep5Scale1 = reshape(SBothAllAvgScale1,2,2)';
            SBothAll_SEMPrep5Scale1 = reshape(SBothAll_SEMScale1,2,2)';
            SAllPlot5Scale1 = SBothAllPrep5Scale1(Ord2,:);
            SBothname5Scale1 = 'Scale1 - Health w/ labels';
            SAll_SEMplot5Scale1 = SBothAll_SEMPrep5Scale1(Ord2,:);
            
            SBothAllPrep5Scale2 = reshape(SBothAllAvgScale2,2,2)';
            SBothAll_SEMPrep5Scale2 = reshape(SBothAll_SEMScale2,2,2)';
            SAllPlot5Scale2 = SBothAllPrep5Scale2(Ord2,:);
            SBothname5Scale2 = 'Scale2 - Health w/ labels';
            SAll_SEMplot5Scale2 = SBothAll_SEMPrep5Scale2(Ord2,:);
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
    

%Faster/Longer aliens with labels - blue  
subplot(2,5,1)
hold on

b = bar(SAllPlot1Scale1, 'FaceColor', 'flat');
b(1).CData = [0 0 0];
b(2).CData = [1 1 1];

     for row = 1:2
        for col = 1:2
            plot([row+Disp(col) row+Disp(col)], [SAllPlot1Scale1(row,col) - SAll_SEMplot1Scale1(row,col), SAllPlot1Scale1(row,col) + SAll_SEMplot1Scale1(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot1Scale1(row,col) - SAll_SEMplot1Scale1(row,col), SAllPlot1Scale1(row,col) - SAll_SEMplot1Scale1(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot1Scale1(row,col) + SAll_SEMplot1Scale1(row,col), SAllPlot1Scale1(row,col) + SAll_SEMplot1Scale1(row,col)],'Color', Gray, 'LineWidth', 1 )
        end
    end

    ylim([ yminimum ymaximum])
    title (strcat (Condition1, S1name) )
    legend(leg)
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
    ylabel('Mean Response Time (ms)')

    
%Faster/Longer aliens with labels  - hot 
subplot(2,5,6)
hold on

b = bar(SAllPlot1Scale2, 'FaceColor', 'flat');
b(1).CData = [0 0 0];
b(2).CData = [1 1 1];

     for row = 1:2
        for col = 1:2
            plot([row+Disp(col) row+Disp(col)], [SAllPlot1Scale2(row,col) - SAll_SEMplot1Scale2(row,col), SAllPlot1Scale2(row,col) + SAll_SEMplot1Scale2(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot1Scale2(row,col) - SAll_SEMplot1Scale2(row,col), SAllPlot1Scale2(row,col) - SAll_SEMplot1Scale2(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot1Scale2(row,col) + SAll_SEMplot1Scale2(row,col), SAllPlot1Scale2(row,col) + SAll_SEMplot1Scale2(row,col)],'Color', Gray, 'LineWidth', 1 )
        end
    end

    ylim([ yminimum ymaximum])
    title (strcat (Condition1, S2name) )
    legend(leg)
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
    ylabel('Mean Response Time (ms)')

   
    
    
%Slower/shorter aliens with labels - scale 1  
subplot(2,5,2)
hold on

b = bar(SAllPlot2Scale1, 'FaceColor', 'flat');
b(1).CData = [0 0 0];
b(2).CData = [1 1 1];

     for row = 1:2
        for col = 1:2
            plot([row+Disp(col) row+Disp(col)], [SAllPlot2Scale1(row,col) - SAll_SEMplot2Scale1(row,col), SAllPlot2Scale1(row,col) + SAll_SEMplot2Scale1(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot2Scale1(row,col) - SAll_SEMplot2Scale1(row,col), SAllPlot2Scale1(row,col) - SAll_SEMplot2Scale1(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot2Scale1(row,col) + SAll_SEMplot2Scale1(row,col), SAllPlot2Scale1(row,col) + SAll_SEMplot2Scale1(row,col)],'Color', Gray, 'LineWidth', 1 )
        end
    end

    ylim([ yminimum ymaximum])
    title (strcat (Condition2, S1name) )
    legend(leg)
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
    ylabel('Mean Response Time (ms)')
      
      
%Slower/shorter aliens with labels   - scale 2
subplot(2,5,7)
hold on

b = bar(SAllPlot2Scale2, 'FaceColor', 'flat');
b(1).CData = [0 0 0];
b(2).CData = [1 1 1];

     for row = 1:2
        for col = 1:2
            plot([row+Disp(col) row+Disp(col)], [SAllPlot2Scale2(row,col) - SAll_SEMplot2Scale2(row,col), SAllPlot2Scale2(row,col) + SAll_SEMplot2Scale2(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot2Scale2(row,col) - SAll_SEMplot2Scale2(row,col), SAllPlot2Scale2(row,col) - SAll_SEMplot2Scale2(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot2Scale2(row,col) + SAll_SEMplot2Scale2(row,col), SAllPlot2Scale2(row,col) + SAll_SEMplot2Scale2(row,col)],'Color', Gray, 'LineWidth', 1 )
        end
    end

    ylim([ yminimum ymaximum])
    title (strcat (Condition2, S2name) )
    legend(leg)
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
    ylabel('Mean Response Time (ms)')
    
    
    
%Faster/Longer aliens without labels  -scale 1 
subplot(2,5,3)
hold on

b = bar(SAllPlot3Scale1, 'FaceColor', 'flat');
b(1).CData = [0 0 0];
b(2).CData = [1 1 1];

     for row = 1:2
        for col = 1:2
            plot([row+Disp(col) row+Disp(col)], [SAllPlot3Scale1(row,col) - SAll_SEMplot3Scale1(row,col), SAllPlot3Scale1(row,col) + SAll_SEMplot3Scale1(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot3Scale1(row,col) - SAll_SEMplot3Scale1(row,col), SAllPlot3Scale1(row,col) - SAll_SEMplot3Scale1(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot3Scale1(row,col) + SAll_SEMplot3Scale1(row,col), SAllPlot3Scale1(row,col) + SAll_SEMplot3Scale1(row,col)],'Color', Gray, 'LineWidth', 1 )
        end
    end

    ylim([ yminimum ymaximum])
    title (strcat (Condition1, S1name) )
    legend(leg)
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
    ylabel('Mean Response Time (ms)')
      
    
%Faster/Longer aliens without labels  -scale 2
subplot(2,5,8)
hold on

b = bar(SAllPlot3Scale2, 'FaceColor', 'flat');
b(1).CData = [0 0 0];
b(2).CData = [1 1 1];

     for row = 1:2
        for col = 1:2
            plot([row+Disp(col) row+Disp(col)], [SAllPlot3Scale2(row,col) - SAll_SEMplot3Scale2(row,col), SAllPlot3Scale2(row,col) + SAll_SEMplot3Scale2(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot3Scale2(row,col) - SAll_SEMplot3Scale2(row,col), SAllPlot3Scale2(row,col) - SAll_SEMplot3Scale2(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot3Scale2(row,col) + SAll_SEMplot3Scale2(row,col), SAllPlot3Scale2(row,col) + SAll_SEMplot3Scale2(row,col)],'Color', Gray, 'LineWidth', 1 )
        end
    end

    ylim([ yminimum ymaximum])
    title (strcat (Condition1, S2name) )
    legend(leg)
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
    ylabel('Mean Response Time (ms)')

    
    
%Faster/Longer soil with labels - scale 1
subplot(2,5,4)
hold on

b = bar(SAllPlot4Scale1, 'FaceColor', 'flat');
b(1).CData = [0 0 0];
b(2).CData = [1 1 1];

     for row = 1:2
        for col = 1:2
            plot([row+Disp(col) row+Disp(col)], [SAllPlot4Scale1(row,col) - SAll_SEMplot4Scale1(row,col), SAllPlot4Scale1(row,col) + SAll_SEMplot4Scale1(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot4Scale1(row,col) - SAll_SEMplot4Scale1(row,col), SAllPlot4Scale1(row,col) - SAll_SEMplot4Scale1(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot4Scale1(row,col) + SAll_SEMplot4Scale1(row,col), SAllPlot4Scale1(row,col) + SAll_SEMplot4Scale1(row,col)],'Color', Gray, 'LineWidth', 1 )
        end
    end

    ylim([ yminimum ymaximum])
    title (strcat (Condition1, S1name) )
    legend(leg)
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
    ylabel('Mean Response Time (ms)')
 
%Faster/Longer soil with labels - scale 2
subplot(2,5,9)
hold on

b = bar(SAllPlot4Scale2, 'FaceColor', 'flat');
b(1).CData = [0 0 0];
b(2).CData = [1 1 1];

     for row = 1:2
        for col = 1:2
            plot([row+Disp(col) row+Disp(col)], [SAllPlot4Scale2(row,col) - SAll_SEMplot4Scale2(row,col), SAllPlot4Scale2(row,col) + SAll_SEMplot4Scale2(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot4Scale2(row,col) - SAll_SEMplot4Scale2(row,col), SAllPlot4Scale2(row,col) - SAll_SEMplot4Scale2(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot4Scale2(row,col) + SAll_SEMplot4Scale2(row,col), SAllPlot4Scale2(row,col) + SAll_SEMplot4Scale2(row,col)],'Color', Gray, 'LineWidth', 1 )
        end
    end

    ylim([ yminimum ymaximum])
    title (strcat (Condition1, S2name) )
    legend(leg)
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
    ylabel('Mean Response Time (ms)')
    
    
    
%Rank/Index health with labels   - scale 1
subplot(2,5,5)
hold on

b = bar(SAllPlot5Scale1, 'FaceColor', 'flat');
b(1).CData = [0 0 0];
b(2).CData = [1 1 1];

     for row = 1:2
        for col = 1:2
            plot([row+Disp(col) row+Disp(col)], [SAllPlot5Scale1(row,col) - SAll_SEMplot5Scale1(row,col), SAllPlot5Scale1(row,col) + SAll_SEMplot5Scale1(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot5Scale1(row,col) - SAll_SEMplot5Scale1(row,col), SAllPlot5Scale1(row,col) - SAll_SEMplot5Scale1(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot5Scale1(row,col) + SAll_SEMplot5Scale1(row,col), SAllPlot5Scale1(row,col) + SAll_SEMplot5Scale1(row,col)],'Color', Gray, 'LineWidth', 1 )
        end
    end

    ylim([ yminimum ymaximum])
    title (strcat (Condition3, S1name) )
    legend(leg)
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
    ylabel('Mean Response Time (ms)')
    
%Rank/Index health with labels   - scale 2
subplot(2,5,10)
hold on

b = bar(SAllPlot5Scale2, 'FaceColor', 'flat');
b(1).CData = [0 0 0];
b(2).CData = [1 1 1];

     for row = 1:2
        for col = 1:2
            plot([row+Disp(col) row+Disp(col)], [SAllPlot5Scale2(row,col) - SAll_SEMplot5Scale2(row,col), SAllPlot5Scale2(row,col) + SAll_SEMplot5Scale2(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot5Scale2(row,col) - SAll_SEMplot5Scale2(row,col), SAllPlot5Scale2(row,col) - SAll_SEMplot5Scale2(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot5Scale2(row,col) + SAll_SEMplot5Scale2(row,col), SAllPlot5Scale2(row,col) + SAll_SEMplot5Scale2(row,col)],'Color', Gray, 'LineWidth', 1 )
        end
    end

    ylim([ yminimum ymaximum])
    title (strcat (Condition3, S2name) )
    legend(leg)
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
    ylabel('Mean Response Time (ms)')

end