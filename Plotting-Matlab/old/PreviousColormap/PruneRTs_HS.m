function [MeanRT_HSmore, MeanRT_HSboth] = PruneRTs(RT, Acc)
% Prune RTs that are +/- 2 SD from subj mean and that are on error trials

numCond = size(RT,1);
numRep = size(RT,2);
n = size(RT,3);


%figure out mean and sd for each subject after removing error trials and
%not presented conditions

for i = 1:n
    SubjStore = [];
    for cond = 1:numCond
       
        %take out errors for calculating mean and SD across all trials 
        for rep = 1:numRep
            if Acc(cond,rep,i) == 1 %answer was correct
                SubjStore = [SubjStore; RT(cond,rep,i)];
            end
        end
    end
    SubjMean(i) = mean(SubjStore); %mean of all accurate trials for this subj
    SubjSD(i) = std(SubjStore);    %standard deviation of all accurate trials for this subj
    
end


SumRT_HSmore = zeros(numCond, n); %only images where hotspot was always "more"
SumRT_HSboth = zeros(numCond, n); %only images where hotspot was presented equally as "more" and "less" 


%take out errors and outliers, because accuracy must equal 1, this
%excludes trials that were not presented (accuracy data stored as -100)
for i = 1:n
    
    SubjMin = SubjMean(i) - 2*SubjSD(i); %minimum allowed RT for this subject
    SubjMax = SubjMean(i) + 2*SubjSD(i); %max RT allowed for this subject
    
    
    for cond = 1:numCond
       
        %only images where hotspot was always "more"
        nt = 0; %number of valid trials
        
        for rep = 1:numRep
            %Only looking at colormaps that only appeared in trials when hotspot was more 
            if (rep > 3 && rep < 11) || rep > 13
                if Acc(cond,rep,i) == 1 && RT(cond,rep,i) > SubjMin && RT(cond,rep,i) < SubjMax
                    SumRT_HSmore(cond,i) = SumRT_HSmore(cond,i) +  RT(cond,rep,i);
                    nt = nt+1;
                end
            end
        end 
        MeanRT_HSmore(cond,i) = SumRT_HSmore(cond,i)/nt;
        
        
        %only images where hotspot was presented equally as "more" and "less" 
        nt = 0; %number of valid trials
        
        for rep = 1:numRep
            %Only looking at colormaps that only appeared in trials when hotspot was more 
            if (rep <= 3 ||  rep >= 11) && rep <= 13
                if Acc(cond,rep,i) == 1 && RT(cond,rep,i) > SubjMin && RT(cond,rep,i) < SubjMax
                    SumRT_HSboth(cond,i) = SumRT_HSboth(cond,i) +  RT(cond,rep,i);
                    nt = nt+1;
                end
            end
        end 
        MeanRT_HSboth(cond,i) = SumRT_HSboth(cond,i)/nt; 
    end
end


end

