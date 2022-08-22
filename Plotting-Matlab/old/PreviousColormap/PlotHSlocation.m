function [] = PlotHSlocation( Data,  Condition, S1name, S2name, figNum, yminimum, ymaximum )


colormap ('gray')
n = size(Data,2);


% CALCULATING ERROR (from Cousineau (2005))
% subtract each subject's overall mean to eliminate subject over all
% biases, and then add back in grand mean 
 
SubjMean = mean(Data,1);
GrandMean = mean(SubjMean);
 
AdjVals = Data - SubjMean + GrandMean;
SEM = std(AdjVals')./sqrt(n); 

AvgData = mean(Data,2);

%% 


Cond = {'Dark'; 'Light'};
Gray = [.5 .5 .5];
Disp = [-.15, .15];

figure (figNum)
colormap ('gray')
subplot(1,2,1)
    hold on
    b = bar(AvgData(1:2), .5, 'FaceColor', 'flat');
    b(1).CData = [.4 .4 .4; .7 .7 .7];    
        
    ylim([yminimum ymaximum])
  
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
    ylabel('Mean RT (ms)')
    
    for i = 1:2
        plot([i i], [AvgData(i) - SEM(i), AvgData(i) + SEM(i)],'Color', Gray, 'LineWidth', 1 )
        plot([i - .08 i + .08], [AvgData(i) - SEM(i), AvgData(i) - SEM(i)],'Color', Gray, 'LineWidth', 1 )
        plot([i - .08 i + .08], [AvgData(i) + SEM(i), AvgData(i) + SEM(i)],'Color', Gray, 'LineWidth', 1 )
    end
    title (strcat (S1name , Condition) )
    
subplot(1,2,2)
hold on
    b = bar(AvgData(3:4) , .5, 'FaceColor', 'flat');
    b(1).CData = [.4 .4 .4; .7 .7 .7];  
     
    ylim([ yminimum ymaximum])
    set(gca, 'XTickLabel',Cond,'XTick',[1:2], 'FontSize', 9.5)
    ylabel('Mean RT (ms)')


    for i = 3:4
        d = i-2;
        plot([d d], [AvgData(i) - SEM(i), AvgData(i) + SEM(i)],'Color', Gray, 'LineWidth', 1 )
        plot([d - .08 d + .08], [AvgData(i) - SEM(i), AvgData(i) - SEM(i)],'Color', Gray, 'LineWidth', 1 )
        plot([d - .08 d + .08], [AvgData(i) + SEM(i), AvgData(i) + SEM(i)],'Color', Gray, 'LineWidth', 1 )
    end
    title (strcat (S2name , Condition) )

    set(gcf, 'Position',  [512   687   331   120])
       
end

