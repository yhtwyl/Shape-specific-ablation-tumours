function [index] = FindClosestIndex(slice_value,NoOfGridPoints,min_limit,max_limit)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
array = linspace(min_limit,max_limit,NoOfGridPoints);
idx = 1;% error_prev = 1;
while (array(idx) - slice_value).*(array(idx+1) - slice_value) > 0
%     error_prev = array(idx) - slice_value;
%     if (array(idx) - slice_value) == 0
%         break;
%     end
    idx = idx + 1;
end
% fprintf('Slice at index no. %d = %6.4f\n',idx+1, array(idx+1));   
index = idx + 1;
end