function [distances_extended, global_mean] = DistancesArray(data_M)
%UNTITLED3 Summary of this function goes here
%   data_M should be a column matrix
len_data = length(data_M);
data_M_extended = zeros(len_data + 2,2);
data_M_extended(2:end-1,:) = data_M;
% disp(size(data_M));
data_M_extended(1,:) = data_M(end,:);
data_M_extended(end,:) = data_M(1,:);
distances = zeros(len_data,1);
for i = 1:len_data
    distances(i) = norm(data_M_extended(i+1,:) - ... 
        data_M_extended(i,:));
end
global_mean = mean(distances);
% distances(:,1) = distances(:,1) - mean_distance;
distances_extended = zeros(len_data+1,1); distances_extended(1:end-1) = distances;
distances_extended(end) = distances(1);
end