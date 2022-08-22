function [MeanRTcond] = PruneRTs_HSLoc(RT, Acc)
% Prune RTs that are +/- 2 SD from subj mean and that are on error trials

numCond = size(RT,1);
numRep = size(RT,2);
n = size(RT,3);


%figure out mean and sd for each subject after removing error trials

for i = 1:n
    SubjStore = [];
    for cond = 1:numCond
       
        %take out errors for calculating mean and SD across all trials 
        for rep = 1:numRep
            if Acc(cond,rep,i) == 1 %answer was correct
                SubjStore = [SubjStore; RT(cond,rep,i)];
            end
        end
        SubjMean(i) = mean(SubjStore); %mean of all accurate trials
        SubjSD(i) = std(SubjStore);    %standard deviation of all accurate trials 
    end
end

SumRT = zeros(numCond, n);
nt = zeros(numCond, n);

for i = 1:n
    
    SubjMin = SubjMean(i) - 2*SubjSD(i);
    SubjMax = SubjMean(i) + 2*SubjSD(i);
    
    
    for cond = 1:numCond
     
        %take out errors and outliers
        for rep = 1:numRep
            if Acc(cond,rep,i) == 1 && RT(cond,rep,i) > SubjMin && RT(cond,rep,i) < SubjMax
                SumRT(cond,i) = SumRT(cond,i) +  RT(cond,rep,i);
                nt(cond,i) = nt(cond,i)+1;
            end
        end 
        
        MeanRT(cond,i) = SumRT(cond,i)./nt(cond,i);
        
        MeanRTcond(1,:) = sum(SumRT(1:8,:),1)./sum(nt(1:8,:),1);  %scale 1, hotspot is dark
        MeanRTcond(2,:) = sum(SumRT(9:16,:),1)./sum(nt(9:16,:),1); %scale 1, hotspot is light

        MeanRTcond(3,:) = sum(SumRT(17:24,:),1)./sum(nt(17:24,:),1);  %scale 2, hotspot is dark
        MeanRTcond(4,:) = sum(SumRT(25:32,:),1)./sum(nt(25:32,:),1); %scale 2, hotspot is light

        
    end
end


end

