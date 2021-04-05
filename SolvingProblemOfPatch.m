function [refined_M] = SolvingProblemOfPatch(data_M)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
data_M_ = data_M.'; % Make the original array column matrix
%% Distances array
[distances_extended, global_mean] = DistancesArray(data_M_);

%{
 fprintf('length of distances array = %d \n',length(distances_extended));
fprintf('global mean = %f \n', global_mean); 
%}

%% 
idx = 1; wake_size = 5;
while true
    if idx == 1 && (distances_extended(idx+1) > global_mean)
%         fprintf('global mean = %f \n', global_mean);
%         fprintf('distances grom its next neighbour = %f \n', distances_extended(idx+1));
%         fprintf('therfore data at first index needs to be deleted \n');
        data_M_(idx,:) = [];
        distances_extended = DistancesArray(data_M_);
    elseif idx == 1 && (distances_extended(idx+1) <= global_mean)
        idx = idx + 1;
    elseif idx > 1
        if idx < wake_size+1
            wake = 2;
        else
            wake = idx - wake_size + 2;
        end
        local_mean = LocalMean(distances_extended(wake:idx));
%        fprintf('local mean = %f \n',local_mean);
        if (local_mean >= global_mean)
            data_M_(idx,:) = [];
            distances_extended = DistancesArray(data_M_);
%             fprintf('size of reduced distances array = %d \n',size(distances_extended));
        else
            idx = idx + 1;
        end
    end
%     fprintf('length of distances array at %d = %d \n',idx, length(data_M_));
    if idx == length(data_M_) + 1
        % fprintf('length of distances array after removing defected data= ,%d \n',idx);
        break;
    end
end
% problematic_indexes_reduced = problematic_indexes(problematic_indexes ~= 0);
% problematic_indexes_reduced = sort(problematic_indexes_reduced,'descend');
% for i = 1:length(problematic_indexes_reduced)
%     data_M_transposed(problematic_indexes_reduced(i),:) = [];
% end
refined_M = data_M_.';
end