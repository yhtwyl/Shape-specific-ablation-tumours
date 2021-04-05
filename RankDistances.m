function [sorted,TineIDs] = RankDistances(DataOfInterestDistances)
unsorted = zeros(1,size(DataOfInterestDistances,1));
    for i = 1:size(DataOfInterestDistances,2) %% bloody row vector
        if (i ~= 1) && (i ~= 8)
            unsorted(i) = sum(DataOfInterestDistances(i-1:i+1));
        elseif i == 1
            unsorted(i) = sum([DataOfInterestDistances(i:i+1),DataOfInterestDistances(8)]);
        elseif i == 8
            unsorted(i) = sum([DataOfInterestDistances(i-1:i),DataOfInterestDistances(1)]);
        end
    end
    [sorted, TineIDs] = sort(unsorted,2,'descend');
end

