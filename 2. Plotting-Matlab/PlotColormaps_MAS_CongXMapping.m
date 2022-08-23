function [ColormapOut, ColormapOut4] = PlotColormaps_MAS_CongXMapping( Data1a, Data1b, Data2a, Data2b, Data3a, Data3b, Data4a, Data4b, Data5a, Data5b, Condition1,Condition2,Condition3, S1name, S2name, figNum, yminimum, ymaximum )


% Data has the following structure:
%within the 32 rows, 1-16 is color scale 1, 17-32 is color scale 2. 
%within each color scale, 1-8 is dark hotspot, 9-16 is light hotspot 
%within each hotspot, 1-4 is dark on the left, 5-8 is dark on the right.
%within each lighntess side, 1-2 the scale is oreinted so dark high, 3-4 is dark low 
%within each scale orientation, 1 is greater high, 2 is greater low.    
%columns are subjects (data has already been aggregated across images)

for exp = 1:5  
    if (exp == 1)
        Data1a = Data1a %because faster condition has 31 participants, separate from the other 3  (Data1 vs Data)
        Data1b = Data1b %because faster condition has 31 participants, separate from the other 3  (Data1 vs Data)
        Condition = Condition1
    elseif (exp == 2)
        Dataa = Data2a
        Datab = Data2b
        Condition = Condition2 %slower/shorter
    elseif (exp == 3)
        Dataa = Data3a
        Datab = Data3b
        Condition = Condition1
    elseif (exp == 4)
        Dataa = Data4a
        Datab = Data4b
        Condition = Condition1
    elseif (exp == 5)
        Dataa = Data5a
        Datab = Data5b
        Condition = Condition3 %rank/index
    end
    
    %Set order
    Ord = [1 3 4 2];
   
    
 %used for x axis labels
    if (Condition == " Faster" || Condition == " Slower" || Condition == " Rank")%- dark more concept
        Cond = Condition; 
    else
        Cond = Condition3; 
    end

  
    % Exp. 1 (faster/longer w/ labels- faster condition has 31  participants) 
    if exp == 1
        n = size(Data1a,2);

        CondCongruent = " Longer" ; 
        CondIncongruent = " Faster"; 
        %separate color scales
        S1Data1a = Data1a(1:8,:); %Blue colorscale
        S2Data1a = Data1a(9:16,:); %Hot colorscale

        %combine whether darker was on the left or right for each color scale
        S1LR1a(1:4,:) =  (S1Data1a(1:4,:) + S1Data1a(5:8,:))/2; 
        S2LR1a(1:4,:) =  (S2Data1a(1:4,:) + S2Data1a(5:8,:))/2;

        S1Ord1a = S1LR1a(Ord,:); 
        S2Ord1a = S2LR1a(Ord,:); 

        %Output for comparing with legend text
        ColormapOut1a = [S1Ord1a',S2Ord1a'];

        S1Avg1a = mean(S1Ord1a,2);
        S2Avg1a = mean(S2Ord1a,2);

        %Average S1 & S2 so only have D+ and L+ 
        S1All1a(1:2,:) =  (S1Ord1a(1:2,:) + S1Ord1a(3:4,:))/2; 
        S1AllAvg1a = mean(S1All1a,2);

        S2All1a(1:2,:) =  (S2Ord1a(1:2,:) + S2Ord1a(3:4,:))/2; 
        S2AllAvg1a = mean(S2All1a,2);
        
        SBothAllFull1a = [S1All1a, S2All1a];
        SBothAllAvg1a = [S1All1a; S2All1a];
        SBothAllAvgS1a = [mean(SBothAllAvg1a([1,3],:));  mean(SBothAllAvg1a([2,4],:))];
        SBothAllAvg1a = mean(SBothAllFull1a, 2);
            
       
        %Output for comparing without legend text
        ColormapOut4a = [SBothAllFull1a'];

        
        % CALCULATING ERROR (from Cousineau (2005))
         % subtract each subject's overall mean to eliminate subject over all
         % biases, and then add back in grand mean 
        SubjMean1a = mean(ColormapOut1a,2)';
        GrandMean1a = mean(SubjMean1a);

        %error bars for data averaged over just colorscale
        SBothAllAvgVals1a = SBothAllAvgS1a - SubjMean1a + GrandMean1a;
        SBothAll_SEM1a = std(SBothAllAvgVals1a')./sqrt(n); %error bars for both averaged color scales
         Ord2 = [1 2];
                
        % Plot data averaged over just color scale (not leg orientation) (Output4)
        SBothAllPrep1a = reshape(SBothAllAvg1a,1,2)';
        SBothAll_SEMPrep1a = reshape(SBothAll_SEM1a,1,2)';
        SAllPlot1a = SBothAllPrep1a(Ord2,:);
        SBothname1a = ' - Aliens w/ labels';
        SAll_SEMplot1a = SBothAll_SEMPrep1a(Ord2,:);


        %%%%% SECOND CONGRUENCY CONDITION
        %separate color scales
        S1Data1b = Data1b(1:8,:); %Blue colorscale
        S2Data1b = Data1b(9:16,:); %Hot colorscale

        %combine whether darker was on the left or right for each color scale
        S1LR1b(1:4,:) =  (S1Data1b(1:4,:) + S1Data1b(5:8,:))/2; 
        S2LR1b(1:4,:) =  (S2Data1b(1:4,:) + S2Data1b(5:8,:))/2;

        S1Ord1b = S1LR1b(Ord,:); 
        S2Ord1b = S2LR1b(Ord,:); 

        %Output for comparing with legend text
        ColormapOut1b = [S1Ord1b',S2Ord1b'];
        S1Avg1b = mean(S1Ord1b,2);
        S2Avg1b = mean(S2Ord1b,2);

        %Average S1 & S2 so only have D+ and L+ 
        S1All1b(1:2,:) =  (S1Ord1b(1:2,:) + S1Ord1b(3:4,:))/2; 
        S1AllAvg1b = mean(S1All1b,2);
        S2All1b(1:2,:) =  (S2Ord1b(1:2,:) + S2Ord1b(3:4,:))/2; 
        S2AllAvg1b = mean(S2All1b,2);
        
        SBothAllFull1b = [S1All1b, S2All1b];
        SBothAllAvg1b = [S1All1b; S2All1b];
        SBothAllAvgS1b = [mean(SBothAllAvg1b([1,3],:));  mean(SBothAllAvg1b([2,4],:))];
        SBothAllAvg1b = mean(SBothAllFull1b, 2);
        
        %Output for comparing without legend text
        ColormapOut4b = [SBothAllFull1b'];



        % CALCULATING ERROR (from Cousineau (2005))
         % subtract each subject's overall mean to eliminate subject over all
         % biases, and then add back in grand mean 
        SubjMean1b = mean(ColormapOut1b,2)';
        GrandMean1b = mean(SubjMean1b);

        %error bars for data averaged over just colorscale
        SBothAllAvgVals1b = SBothAllAvgS1b - SubjMean1b + GrandMean1b;
        SBothAll_SEM1b = std(SBothAllAvgVals1b')./sqrt(n); %error bars for both averaged color scales
         Ord2 = [1 2];

        % Plot data averaged over just color scale (not leg orientation) (Output4)
        SBothAllPrep1b = reshape(SBothAllAvg1b,1,2)';
        SBothAll_SEMPrep1b = reshape(SBothAll_SEM1b,1,2)';
        SAllPlot1b = SBothAllPrep1b(Ord2,:);
        SBothname1b = ' - Aliens w/ labels';
        SAll_SEMplot1b = SBothAll_SEMPrep1b(Ord2,:);
        
        
    %for experiments 2-5
    elseif exp ~= 1
        n = size(Dataa,2);

        %CONGRUENT CONDITIONS
        %separate color scales
        S1Dataa = Dataa(1:8,:); %Blue colorscale
        S2Dataa = Dataa(9:16,:); %Hot colorscale

        %combine whether darker was on the left or right for each color scale
        S1LRa(1:4,:) =  (S1Dataa(1:4,:) + S1Dataa(5:8,:))/2; 
        S2LRa(1:4,:) =  (S2Dataa(1:4,:) + S2Dataa(5:8,:))/2;
        S1Orda = S1LRa(Ord,:); 
        S2Orda = S2LRa(Ord,:); 

        %Output for comparing with legend text
        ColormapOuta = [S1Orda',S2Orda'];
        S1Avga = mean(S1Orda,2);
        S2Avga = mean(S2Orda,2);


        %Average S1 & S2 so only have D+ and L+ 
        S1Alla(1:2,:) =  (S1Orda(1:2,:) + S1Orda(3:4,:))/2; 
        S1AllAvga = mean(S1Alla,2);

        S2Alla(1:2,:) =  (S2Orda(1:2,:) + S2Orda(3:4,:))/2; 
        S2AllAvga = mean(S2Alla,2);
        
        SBothAllFulla = [S1Alla, S2Alla];
        SBothAllFulla = [S1Alla, S2Alla];
        SBothAllAvga = [S1Alla; S2Alla];
        SBothAllAvgSa = [mean(SBothAllAvga([1,3],:));  mean(SBothAllAvga([2,4],:))];
        SBothAllAvga = mean(SBothAllFulla, 2);
        
        %Output for comparing without legend text
        ColormapOut4a = [SBothAllFulla'];

        % CALCULATING ERROR (from Cousineau (2005))
        % subtract each subject's overall mean to eliminate subject over all
        % biases, and then add back in grand mean 
        SubjMeana = mean(ColormapOuta,2)';
        GrandMeana = mean(SubjMeana);

        %error bars for data averaged over just colorscale
        SBothAllAvgValsa = SBothAllAvgSa - SubjMeana + GrandMeana;
        SBothAll_SEMa = std(SBothAllAvgValsa')./sqrt(n); %error bars for both averaged color scales
             
    
        % Plot data averaged over just color scale (not leg orientation) (Output4)
        if (exp == 2)
            SBothAllPrep2a = reshape(SBothAllAvga,1,2)';
            SBothAll_SEMPrep2a = reshape(SBothAll_SEMa,1,2)' ; 
            SAllPlot2a = SBothAllPrep2a(Ord2,:);
            SBothname2a = ' -Aliens w/ labels';
            SAll_SEMplot2a = SBothAll_SEMPrep2a(Ord2,:);
        elseif (exp == 3)
            SBothAllPrep3a = reshape(SBothAllAvga,1,2)';
            SBothAll_SEMPrep3a = reshape(SBothAll_SEMa,1,2)';
            SAllPlot3a = SBothAllPrep3a(Ord2,:);
            SBothname3a = ' -Aliens w/o labels';
            SAll_SEMplot3a = SBothAll_SEMPrep3a(Ord2,:);
        elseif (exp == 4)
            SBothAllPrep4a = reshape(SBothAllAvga,1,2)';
            SBothAll_SEMPrep4a = reshape(SBothAll_SEMa,1,2)';
            SAllPlot4a = SBothAllPrep4a(Ord2,:);
            SBothname4a = ' - Soil w/ labels';
            SAll_SEMplot4a = SBothAll_SEMPrep4a(Ord2,:);
        elseif (exp == 5)
            SBothAllPrep5a = reshape(SBothAllAvga,1,2)';
            SBothAll_SEMPrep5a = reshape(SBothAll_SEMa,1,2)';
            SAllPlot5a = SBothAllPrep5a(Ord2,:);
            SBothname5a = ' - Health w/ labels';
            SAll_SEMplot5a = SBothAll_SEMPrep5a(Ord2,:);
        end

         %INONGRUENT CONDITIONS
        %separate color scales
        S1Datab = Datab(1:8,:); %Blue colorscale
        S2Datab = Datab(9:16,:); %Hot colorscale

        %combine whether darker was on the left or right for each color scale
        S1LRb(1:4,:) =  (S1Datab(1:4,:) + S1Datab(5:8,:))/2; 
        S2LRb(1:4,:) =  (S2Datab(1:4,:) + S2Datab(5:8,:))/2;
        S1Ordb = S1LRb(Ord,:); 
        S2Ordb = S2LRb(Ord,:); 

        %Output for comparing with legend text
        ColormapOutb = [S1Ordb',S2Ordb'];
        S1Avgb = mean(S1Ordb,2);
        S2Avgb = mean(S2Ordb,2);

        %Average S1 & S2 so only have D+ and L+ 
        S1Allb(1:2,:) =  (S1Ordb(1:2,:) + S1Ordb(3:4,:))/2; 
        S1AllAvgb = mean(S1All1b,2);

        S2Allb(1:2,:) =  (S2Ordb(1:2,:) + S2Ordb(3:4,:))/2; 
        S2AllAvgb = mean(S2Allb,2);
        
        SBothAllFullb = [S1Allb, S2Allb];
        SBothAllFullb = [S1Allb, S2Allb];
        SBothAllAvgb = [S1Allb; S2Allb];
        SBothAllAvgSb = [mean(SBothAllAvgb([1,3],:));  mean(SBothAllAvgb([2,4],:))];
        SBothAllAvgb = mean(SBothAllFullb, 2);
        
        
        %Output for comparing without legend text
        ColormapOut4b = [SBothAllFullb'];

        % CALCULATING ERROR (from Cousineau (2005))
        % subtract each subject's overall mean to eliminate subject over all
        % biases, and then add back in grand mean 
        SubjMeanb = mean(ColormapOutb,2)';
        GrandMeanb = mean(SubjMeanb);

        %error bars for data averaged over just colorscale
        SBothAllAvgValsb = SBothAllAvgSb - SubjMeanb + GrandMeanb;
        SBothAll_SEMb = std(SBothAllAvgValsb')./sqrt(n); %error bars for both averaged color scales
        
    
        % Plot data averaged over just color scale (not leg orientation) (Output4)
        if (exp == 2)
            SBothAllPrep2b = reshape(SBothAllAvgb,1,2)';
            SBothAll_SEMPrep2b = reshape(SBothAll_SEMb,1,2)' ; 
            SAllPlot2b = SBothAllPrep2b(Ord2,:);
            SBothname2b = ' -Aliens w/ labels';
            SAll_SEMplot2b = SBothAll_SEMPrep2b(Ord2,:);
        elseif (exp == 3)
            SBothAllPrep3b = reshape(SBothAllAvgb,1,2)';
            SBothAll_SEMPrep3b = reshape(SBothAll_SEMb,1,2)';
            SAllPlot3b = SBothAllPrep3b(Ord2,:);
            SBothname3b = ' -Aliens w/o labels';
            SAll_SEMplot3b = SBothAll_SEMPrep3b(Ord2,:);
        elseif (exp == 4)
            SBothAllPrep4b = reshape(SBothAllAvgb,1,2)';
            SBothAll_SEMPrep4b = reshape(SBothAll_SEMb,1,2)';
            SAllPlot4b = SBothAllPrep4b(Ord2,:);
            SBothname4b = ' - Soil w/ labels';
            SAll_SEMplot4b = SBothAll_SEMPrep4b(Ord2,:);
        elseif (exp == 5)
            SBothAllPrep5b = reshape(SBothAllAvgb,1,2)';
            SBothAll_SEMPrep5b = reshape(SBothAll_SEMb,1,2)';
            SAllPlot5b = SBothAllPrep5b(Ord2,:);
            SBothname5b = ' - Health w/ labels';
            SAll_SEMplot5b = SBothAll_SEMPrep5b(Ord2,:);
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

SAllPlot1 = [SAllPlot1a, SAllPlot1b]';
SAll_SEMplot1 = [SAll_SEMplot1a, SAll_SEMplot1b]';
b = bar(SAllPlot1, 'FaceColor', 'flat');
b(1).CData = [0 0 0];
b(2).CData = [1 1 1];
Cond = ["Faster", "Longer"]; 

     for row = 1:2
        for col = 1:2
            plot([row+Disp(col) row+Disp(col)], [SAllPlot1(row,col) - SAll_SEMplot1(row,col), SAllPlot1(row,col) + SAll_SEMplot1(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot1(row,col) - SAll_SEMplot1(row,col), SAllPlot1(row,col) - SAll_SEMplot1(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot1(row,col) + SAll_SEMplot1(row,col), SAllPlot1(row,col) + SAll_SEMplot1(row,col)],'Color', Gray, 'LineWidth', 1 )
        end
    end

    ylim([ yminimum ymaximum])
    title (strcat (SBothname1a) )
    legend(leg)
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
    ylabel('Mean Response Time (ms)')

    
    
%Slower/shorter aliens with labels   
subplot(1,5,2)
hold on


SAllPlot2 = [SAllPlot2a, SAllPlot2b]';
SAll_SEMplot2 = [SAll_SEMplot2a, SAll_SEMplot2b]';
b = bar(SAllPlot2, 'FaceColor', 'flat');
b(1).CData = [0 0 0];
b(2).CData = [1 1 1];
Cond = ["Slower", "Shorter"]; 

     for row = 1:2
        for col = 1:2
            plot([row+Disp(col) row+Disp(col)], [SAllPlot2(row,col) - SAll_SEMplot2(row,col), SAllPlot2(row,col) + SAll_SEMplot2(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot2(row,col) - SAll_SEMplot2(row,col), SAllPlot2(row,col) - SAll_SEMplot2(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot2(row,col) + SAll_SEMplot2(row,col), SAllPlot2(row,col) + SAll_SEMplot2(row,col)],'Color', Gray, 'LineWidth', 1 )
        end
    end

    ylim([ yminimum ymaximum])
    title (strcat (SBothname2a) )
    legend(leg)
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
    ylabel('Mean Response Time (ms)')
    
    
    
%Faster/Longer aliens without labels   
subplot(1,5,3)
hold on


SAllPlot3 = [SAllPlot3a, SAllPlot3b]';
SAll_SEMplot3 = [SAll_SEMplot3a, SAll_SEMplot3b]';
b = bar(SAllPlot3, 'FaceColor', 'flat');
b(1).CData = [0 0 0];
b(2).CData = [1 1 1];
Cond = ["Faster", "Longer"]; 

     for row = 1:2
        for col = 1:2
            plot([row+Disp(col) row+Disp(col)], [SAllPlot3(row,col) - SAll_SEMplot3(row,col), SAllPlot3(row,col) + SAll_SEMplot3(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot3(row,col) - SAll_SEMplot3(row,col), SAllPlot3(row,col) - SAll_SEMplot3(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot3(row,col) + SAll_SEMplot3(row,col), SAllPlot3(row,col) + SAll_SEMplot3(row,col)],'Color', Gray, 'LineWidth', 1 )
        end
    end

    ylim([ yminimum ymaximum])
    title (strcat (SBothname3a) )
    legend(leg)
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
    ylabel('Mean Response Time (ms)')
      

%Faster/Longer soil with labels   
subplot(1,5,4)
hold on


SAllPlot4 = [SAllPlot4a, SAllPlot4b]';
SAll_SEMplot4 = [SAll_SEMplot4a, SAll_SEMplot4b]';
b = bar(SAllPlot4, 'FaceColor', 'flat');
b(1).CData = [0 0 0];
b(2).CData = [1 1 1];
Cond = ["Faster", "Longer"]; 

     for row = 1:2
        for col = 1:2
            plot([row+Disp(col) row+Disp(col)], [SAllPlot4(row,col) - SAll_SEMplot4(row,col), SAllPlot4(row,col) + SAll_SEMplot4(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot4(row,col) - SAll_SEMplot4(row,col), SAllPlot4(row,col) - SAll_SEMplot4(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot4(row,col) + SAll_SEMplot4(row,col), SAllPlot4(row,col) + SAll_SEMplot4(row,col)],'Color', Gray, 'LineWidth', 1 )
        end
    end

    ylim([ yminimum ymaximum])
    title (strcat (SBothname4a) )
    legend(leg)
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
    ylabel('Mean Response Time (ms)')
 
    
 
    
%Rank/Index health with labels   
subplot(1,5,5)
hold on

SAllPlot5 = [SAllPlot5a, SAllPlot5b]';
SAll_SEMplot5 = [SAll_SEMplot5a, SAll_SEMplot5b]';
b = bar(SAllPlot5, 'FaceColor', 'flat');
b(1).CData = [0 0 0];
b(2).CData = [1 1 1];
Cond = ["Faster", "Longer"]; 

     for row = 1:2
        for col = 1:2
            plot([row+Disp(col) row+Disp(col)], [SAllPlot5(row,col) - SAll_SEMplot5(row,col), SAllPlot5(row,col) + SAll_SEMplot5(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot5(row,col) - SAll_SEMplot5(row,col), SAllPlot5(row,col) - SAll_SEMplot5(row,col)],'Color', Gray, 'LineWidth', 1 )
            plot([row+Disp(col)-.05 row+Disp(col)+.05], [SAllPlot5(row,col) + SAll_SEMplot5(row,col), SAllPlot5(row,col) + SAll_SEMplot5(row,col)],'Color', Gray, 'LineWidth', 1 )
        end
    end

    ylim([ yminimum ymaximum])
    title (strcat (SBothname5a))
    legend(leg)
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
    ylabel('Mean Response Time (ms)')

end