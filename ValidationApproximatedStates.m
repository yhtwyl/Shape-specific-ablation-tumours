%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% SUMMARY %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DataOfInterest = zeros(2,24);
grid_points = 100;
filename = strcat('/home/linuxlover/Documents/MATLAB/PreviousProblem/OverlappingCases/Validation',...
                  'Cases/FinalFourPresentedInArticle/Case4_INorm_data_central_region_100by100by100.txt');
TargetStates = [2,0,3,0,1,3,0,0,1;3,3,2,0,3,3,2,3,2;3,3,2,0,2,2,3,2,3;2,0,1,2,2,1,1,3,0];
[DataOfInterest,slice_value] = DataGeneration(filename,grid_points);
DataOfInterestDistances = zeros(1,length(DataOfInterest));
for i = 1:length(DataOfInterest)
    DataOfInterestDistances(i) = norm(DataOfInterest(:,i));
end

hold on;
fig_name = gcf;
filename = strcat('/home/linuxlover/Documents/MATLAB/PreviousProblem/OverlappingCases/ValidationCases',...
                  '/FinalFourPresentedInArticle/AblationDataForApproximatedCase4OfPresentedInPaper.txt');
[DataOfInterest_,slice_value_] = OverlappingForValidatingApproxCases(filename,grid_points,fig_name);
DataOfInterestDistances_ = zeros(1,length(DataOfInterest_));
for i = 1:length(DataOfInterest_)
    DataOfInterestDistances_(i) = norm(DataOfInterest_(:,i));
end