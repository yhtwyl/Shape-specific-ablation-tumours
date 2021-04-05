%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% SUMMARY %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DataOfInterest = zeros(2,24);
grid_points = 100;
filename = strcat('/home/linuxlover/Documents/MATLAB/PreviousProblem/OverlappingCases/Validation',...
                  'Cases/FinalFourPresentedInArticle/Case1_INorm_data_central_region_100by100by100.txt');
TargetStates = [2,0,3,0,1,3,0,0,1;3,3,2,0,3,3,2,3,2;3,3,2,0,2,2,3,2,3;2,0,1,2,2,1,1,3,0];
[DataOfInterest,slice_value] = DataGeneration(filename,grid_points);
DataOfInterestDistances = zeros(1,length(DataOfInterest));
for i = 1:length(DataOfInterest)
    DataOfInterestDistances(i) = norm(DataOfInterest(:,i));
end
[~, TinesIDsOrder] = RankDistances(DataOfInterestDistances);
StatesAssigned = 9.*ones(1,9);
DetailedMatrixLevel1 = zeros(100,16);
DetailedMatrixLevel2 = zeros(150,24);
DetailedMatrixLevel3 = zeros(200,32);
%% count = 0;error_lower_limit = -1.0; error_upper_limit = -0.2;
TinesIDs = OnlyFour(TinesIDsOrder);
TineID = TinesIDs(1);
%%%%%%%%%%%%%%%%%%%%%%%%%% TINE 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do the matching for alternate tines and not for the consequtive tines.
PossibleCasesTine1 = Algol(DataOfInterestDistances,TineID,StatesAssigned);
%%%%%%%%%%%%%%%%%%%%%%%% TINE 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%
TineID = TinesIDs(2); idx_begin = 1;
for i = 1:size(PossibleCasesTine1,1)
    StatesAssigned = AssignTheStates(TinesIDs,TineID,PossibleCasesTine1(i,1:4));
    PossibleCasesTine2 = Algol(DataOfInterestDistances,TineID,StatesAssigned);
    if size(PossibleCasesTine2,1) ~= 0
        n = size(PossibleCasesTine2,1);
        idx_end = idx_begin + n - 1;
        for j = 1:n
            DummyMat(j,:) = PossibleCasesTine1(i,:);
        end
        DetailedMatrixLevel1(idx_begin:idx_end,1:16) = [DummyMat PossibleCasesTine2];
        idx_begin = idx_end + 1;
    end
    clear PossibleCasesTine2 DummyMat
end

TineID = TinesIDs(3); idx_begin = 1;
for i = 1:size(DetailedMatrixLevel1,1)
    StatesAssigned = AssignTheStates(TinesIDs,TineID,[DetailedMatrixLevel1(i,1:4), DetailedMatrixLevel1(i,9:12)]);
    %%    StatesAssigned = [DetailedMatrix(i,4),DetailedMatrix(i,1:2),DetailedMatrix(i,9:10),0,0,0,DetailedMatrix(i,3)];
    PossibleCasesTine3 = Algol(DataOfInterestDistances,TineID,StatesAssigned);
    if size(PossibleCasesTine3,1) ~= 0
        n = size(PossibleCasesTine3,1);
        idx_end = idx_begin + n - 1;
        for j = 1:n
            DummyMat(j,:) = DetailedMatrixLevel1(i,:);
        end
        DetailedMatrixLevel2(idx_begin:idx_end,1:24) = [DummyMat PossibleCasesTine3];
        idx_begin = idx_end + 1;
    end
    clear PossibleCasesTine3 DummyMat
end

TineID = TinesIDs(4); idx_begin = 1;
for i = 1:size(DetailedMatrixLevel2,1)
    StatesAssigned = AssignTheStates(TinesIDs,TineID,[DetailedMatrixLevel2(i,1:4),DetailedMatrixLevel2(i,9:12),DetailedMatrixLevel2(i,17:20)]);
    %%    StatesAssigned = [DetailedMatrix(i,4),DetailedMatrix(i,1:2),DetailedMatrix(i,9:10),0,0,0,DetailedMatrix(i,3)];
    PossibleCasesTine4 = Algol(DataOfInterestDistances,TineID,StatesAssigned);
    if size(PossibleCasesTine4,1) ~= 0
        n = size(PossibleCasesTine4,1);
        idx_end = idx_begin + n - 1;
        for j = 1:n
            DummyMat(j,:) = DetailedMatrixLevel2(i,:);
        end
        DetailedMatrixLevel3(idx_begin:idx_end,1:32) = [DummyMat PossibleCasesTine4];
        idx_begin = idx_end + 1;
    end
    clear PossibleCasesTine4 DummyMat
end
ImpDataRow = min(find(DetailedMatrixLevel3(:,5) == 0)) - 1;
DetailedMatrixLevel3_unsorted = zeros(ImpDataRow,size(DetailedMatrixLevel3,2) + 1);
DetailedMatrixLevel3_unsorted(:,1:end-1) = DetailedMatrixLevel3(1:ImpDataRow,:);
DetailedMatrixLevel3_unsorted(:,end) = sum([DetailedMatrixLevel3(1:ImpDataRow,8),DetailedMatrixLevel3(1:ImpDataRow,16),DetailedMatrixLevel3(1:ImpDataRow,24),DetailedMatrixLevel3(1:ImpDataRow,32)],2);
DetailedMatrixLevel3_sorted = sortrows(DetailedMatrixLevel3_unsorted,size(DetailedMatrixLevel3_unsorted,2));
clear DetailedMatrixLevel3_unsorted DetailedMatrix DetailedMatrixLevel1 DetailedMatrixLevel2 DetailedMatrixLevel3 TineID
hold on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if size(DetailedMatrixLevel3_sorted,1) ~= 0
    ApproximatedStates = DetailedMatrixLevel3_sorted(end,1:end-1);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    StatesOfAllNineTines = zeros(1,9);
    for i = 1:length(TinesIDs)
        [left right] = TineNeighbours(TinesIDs(i));
        StatesOfAllNineTines(TinesIDs(i)) = ApproximatedStates(8*(i-1) + 1);
        StatesOfAllNineTines(left) = ApproximatedStates(8*(i-1) + 2);
        StatesOfAllNineTines(right) = ApproximatedStates(8*(i-1) + 4);
        StatesOfAllNineTines(9) = ApproximatedStates(8*(i-1) + 3);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%% EXTRACTING CORRESPONDING ABLATION DATA FROM THE DATABASE
    for j = 1:fix(length(ApproximatedStates)/8)
        TineID = TinesIDs(j);
        switch ApproximatedStates(8*(j-1) + 5)
          case 1
            DirectoryOfDataFile = '/home/linuxlover/Documents/MATLAB/PreviousProblem/OverlappingCases/HalfModel';
            nature = 1;% 1 = "Symmetric";
            similar = 0;
          case 2
            DirectoryOfDataFile = '/home/linuxlover/Documents/MATLAB/PreviousProblem/OverlappingCases/FullModel';
            nature = 0;% 0 = "Unique";
            similar = 0;
          case 3
            DirectoryOfDataFile = '/home/linuxlover/Documents/MATLAB/PreviousProblem/OverlappingCases/FullModel';
            nature = 0;% 0 = "Unique";
            similar = 1;
        end
        
        SetNo = ApproximatedStates(8*(j-1) + 6);case_no = ApproximatedStates(8*(j-1) + 7);
        
        filename = strcat(DirectoryOfDataFile,'/Set',num2str(SetNo), ...
                          '_Inorm_data_70by70by70_central_region_appended.txt');
        FigHandle = gcf; slice_plane = 'z'; azimuthal_angle = 0;% slice_value = 47; %%%%%%%%%%%%% CORRECT SLICE POSIITON %%%%%%%%%%%%
        [x,y,z,v] = ReadmatrixFromDatabase(filename,similar); % reflection
        grid_points = 70; %%%%%%%%%% FOR DATABASE
        x_mat = reshape(x,[grid_points,grid_points,grid_points]);
        y_mat = reshape(y,[grid_points,grid_points,grid_points]);
        z_mat = reshape(z,[grid_points,grid_points,grid_points]);
        v_mat = reshape(v(:,case_no),[grid_points,grid_points,grid_points]);
        
        if nature
            [x_,y_,z_,v_] = ReflectTheSymmetricData(x_mat,y_mat,z_mat,v_mat);
            [x_mat,y_mat,z_mat,v_mat] = MakeMatrixSquare(x_,y_,z_,v_);
        end
        
        [x_tine_contribution,y_tine_contribution,v_tine_contribution] = ShapesDataForSliceFit...
            (x_mat,y_mat,z_mat,v_mat,slice_plane,slice_value,azimuthal_angle);
        [M, fm] = contour(x_tine_contribution,y_tine_contribution,v_tine_contribution,[1 1]);
        delete(fm);
        Refined_M = SolvingProblemOfPatch(M);
        if TineID > 1; Refined_M = RotateContourData(Refined_M,TineID); end %%% i corresponds to tine number.
        plot(Refined_M(1,:),Refined_M(2,:));axis square;
    end
end