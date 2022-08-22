function [ColormapOut] = PlotColormapsHS( Data,  Condition, S1name, S2name, figNum)


% Data has the following strucutre:
%within the 32 rows, 1-16 is color scale 1, 17-32 is color scale 2. 
%within each color scale, 1-8 is dark hotspot, 9-16 is light hotspot 
%within each hotspot, 1-4 is dark on the left, 5-8 is dark on the right.
%within each lighntess side, 1-2 the scale is oreinted so dark high, 3-4 is dark low 
%within each scale orientation, 1 is greater high, 2 is greater low.    
%columns are repititons (with different images). 

n = size(Data,2);

%separate the color scales
S1Data = Data(1:16,:); 
S2Data = Data(17:32,:); 

%combine whether darker was on the left or right for each color scale
S1LR(1:4,:) =  (S1Data(1:4,:) + S1Data(5:8,:))/2; %hotspot is dark
S1LR(5:8,:) =  (S1Data(9:12,:) + S1Data(13:16,:))/2; %hotspot is light

S2LR(1:4,:) =  (S2Data(1:4,:) + S2Data(5:8,:))/2; %hotspot is dark
S2LR(5:8,:) =  (S2Data(9:12,:) + S2Data(13:16,:))/2; %hostpot lis light

%rows are currently dark hotspot(1-4) light hot spot (5-8)
%within those, scale orientation goes dark high (1-2) dark low(3-4)
%with in those, legend text is greater-high (1), greater low (2)

%we want to make it so that the order within each hotspot is
%D+, L+ when greater is high, and D+, l+ when greater is low. 
Ord = [1 3 4 2   5 7 8 6]; 

S1Ord = S1LR(Ord,:); 
S1Avg = mean(S1Ord,2);

S2Ord = S2LR(Ord,:); 
S2Avg = mean(S2Ord,2);

ColormapOut = [S1Ord',S2Ord'];

%% Averaging over legend text for each color scale
S1HiLo = (S1Ord([1 6], :) + S1Ord([3 8], :))/2;
S2HiLo = (S2Ord([1 6], :) + S2Ord([3 8], :))/2;

S1HiLoAvg = mean(S1HiLo,2);
S2HiLoAvg = mean(S2HiLo,2);

%% CALCULATING ERROR (from Cousineau (2005))
% subtract each subject's overall mean to eliminate subject over all
% biases, and then add back in grand mean 

%valid trials (hotspot more colormaps): 
V = [1  3   6  8 9  11  14  16];
SubjMean = mean(ColormapOut(:,V),2)';
GrandMean = mean(SubjMean);

%error bars for data averaged over legend text
 S1HiLoAdjVals = S1HiLo - SubjMean + GrandMean;
 S2HiLoAdjVals = S2HiLo - SubjMean + GrandMean;

 S1HiLo_SEM = std(S1HiLoAdjVals')./sqrt(n); %error bars for color scale 1
 S2HiLo_SEM = std(S2HiLoAdjVals')./sqrt(n); %error bars for color scale 2

%error bars for data seprated by legend text
 S1AdjVals = S1Ord - SubjMean + GrandMean; 
 S2AdjVals = S2Ord - SubjMean + GrandMean; 

 S1_SEM = std(S1AdjVals')./sqrt(n); %error bars for color scale 1
 S2_SEM = std(S2AdjVals')./sqrt(n); %error bars for color scale 2


%% plot data separately for color scales but averaged over legend text
leg = {'D+', 'L+'};
Cond = {'D Hotspt, D+'; 'L Hotspt, L+'};
Gray = [.5 .5 .5];

ymaximum = 1300;
yminimum = 1050;


figure (figNum)
hold on

subplot(1,2,1)
hold on
    b = bar(S1HiLoAvg, .3, 'FaceColor', 'flat');
    b(1).CData = [0 0 0; 1 1 1];
 
    
    ylim([yminimum ymaximum])
    title (strcat (S1name, Condition) )
    set(gca, 'XTickLabel',Cond,'XTick',[1:4], 'FontSize', 9.5)
    ylabel('Mean RT (ms)')
    
    for i = 1:2
        plot([i,i], [S1HiLoAvg(i)-S1HiLo_SEM(i), S1HiLoAvg(i)+S1HiLo_SEM(i)],'Color', Gray,  'LineWidth', 1)
        plot([i-.05,i+.05], [S1HiLoAvg(i)-S1HiLo_SEM(i), S1HiLoAvg(i)-S1HiLo_SEM(i)],'Color', Gray,  'LineWidth', 1)
        plot([i-.05,i+.05], [S1HiLoAvg(i)+S1HiLo_SEM(i), S1HiLoAvg(i)+S1HiLo_SEM(i)],'Color', Gray,  'LineWidth', 1)
    end
    
    
subplot(1,2, 2)
    hold on
    b = bar(S2HiLoAvg, .3, 'FaceColor', 'flat');
    b(1).CData = [0 0 0; 1 1 1];

    
    ylim([ yminimum ymaximum])
    title (strcat (S2name , Condition) )
    set(gca, 'XTickLabel',Cond,'XTick',[1:4], 'FontSize', 9.5)
    ylabel('Mean RT (ms)')
    
    for i = 1:2
        plot([i,i], [S2HiLoAvg(i)-S2HiLo_SEM(i), S2HiLoAvg(i)+S2HiLo_SEM(i)],'Color', Gray,   'LineWidth', 1 )
        plot([i-.05,i+.05], [S2HiLoAvg(i)-S2HiLo_SEM(i), S2HiLoAvg(i)-S2HiLo_SEM(i)],'Color', Gray,  'LineWidth', 1 )
        plot([i-.05,i+.05], [S2HiLoAvg(i)+S2HiLo_SEM(i), S2HiLoAvg(i)+S2HiLo_SEM(i)],'Color', Gray,  'LineWidth', 1 )
    end
    
    
set(gcf, 'Position',  [529        1041         438         120])    

%% Plot data separated by color scales and legend text
S1Prep = reshape(S1Avg,2,4)';
S2Prep = reshape(S2Avg,2,4)';

S1_SEMprep = reshape(S1_SEM,2,4)';
S2_SEMprep = reshape(S2_SEM,2,4)';

%re-order the rows so that they are grouped by hotspot lightness not leg
%text, and elimit NaNs for trias that didn't exist (hotspot-less mappings)


S1Plot = [S1Prep(1,1); S1Prep(3,2); S1Prep(2,1); S1Prep(4,2);];
S2Plot = [S2Prep(1,1); S2Prep(3,2); S2Prep(2,1); S2Prep(4,2);];

S1_SEMplot = [S1_SEMprep(1,1); S1_SEMprep(3,2); S1_SEMprep(2,1); S1_SEMprep(4,2);];
S2_SEMplot = [S2_SEMprep(1,1); S2_SEMprep(3,2); S2_SEMprep(2,1); S2_SEMprep(4,2);];

Cond = {'Dhs/GreatHi'; 'Lhs/GreatHi'; 'Dhs/GreatLo'; 'Lhs/GreatLo'};
 
figure (figNum*10)
colormap ('gray')
subplot(1,2,1)
hold on
    b = bar(S1Plot, .45, 'FaceColor', 'flat');
    b(1).CData = [0 0 0; 1 1 1; 0 0 0; 1 1 1];

    
     for row = 1:4

        plot([row, row], [S1Plot(row) - S1_SEMplot(row), S1Plot(row) + S1_SEMplot(row)],'Color', Gray, 'LineWidth', 1 )
        plot([row-.09 row+.09], [S1Plot(row) - S1_SEMplot(row), S1Plot(row) - S1_SEMplot(row)],'Color', Gray, 'LineWidth', 1 )
        plot([row-.09 row+.09], [S1Plot(row) + S1_SEMplot(row), S1Plot(row) + S1_SEMplot(row)],'Color', Gray, 'LineWidth', 1 )

    end
    
    
    ylim([yminimum 1400])
    title (strcat (S1name , Condition) )
    legend(leg)
    set(gca, 'XTickLabel',Cond,'XTick',[1:4], 'FontSize', 9.5)
    ylabel('Mean RT (ms)')
    
    
subplot(1,2, 2)
hold on

    b = bar(S2Plot, .45, 'FaceColor', 'flat');
    b(1).CData = [0 0 0; 1 1 1; 0 0 0; 1 1 1];

    
     for row = 1:4
        for col = 1:2
            plot([row,  row], [S2Plot(row) - S2_SEMplot(row), S2Plot(row) + S2_SEMplot(row)],'Color', Gray, 'LineWidth', 1 )
            plot([row-.09 row+.09], [S2Plot(row) - S2_SEMplot(row), S2Plot(row) - S2_SEMplot(row)],'Color', Gray, 'LineWidth', 1 )
            plot([row-.09 row+.09], [S2Plot(row) + S2_SEMplot(row), S2Plot(row) + S2_SEMplot(row)],'Color', Gray, 'LineWidth', 1 )
        end
     end
    
    ylim([yminimum 1400])
    title (strcat (S2name , Condition) )
    legend(leg)
    set(gca, 'XTickLabel',Cond,'XTick',[1:4], 'FontSize', 9.5)
    
    set(gcf, 'Position',  [968 1039 718 123])    
    ylabel('Mean RT (ms)')

end

