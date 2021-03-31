DataOfInterest = zeros(2,24);
grid_points = 100;
filename = strcat('C:\Users\InSilico\Documents\MATLAB\OverlappingCases\Validation',...
    'Cases\FinalFourPresentedInArticle\Case4_INorm_data_central_region_100by100by100.txt');
DataOfInterest = DataGeneration(filename,grid_points);
DataSetsFilenames = {'StatesAndDistancesSymmetricCases.txt','StatesAndDistancesUniqueCases.txt','StatesAndDistancesUniqueCasesBros.txt'};
DataOfInterestDistances = zeros(1,length(DataOfInterest));
for i = 1:length(DataOfInterest)
    DataOfInterestDistances(i) = norm(DataOfInterest(:,i));
end
StatesAssigned = int8.empty;
error_limit = 0.5;count = 0;
for i = 1:2:7
    count = count + 1;idx_ = 0;
    for idx = 1:3
        DataAll = load(DataSetsFilenames{idx});
        if length(StatesAssigned) ~= 0
            data = FilteredDataSet(DataAll,StatesAssigned,i);
        else
            data = DataAll;
        end
        [len,~] = size(data);
        if len > 0
            idx_ = idx_ + 1;
            for index = 1:len
                LenT1 = data(index,5);
                LenT2 = data(index,6);
                LenT8 = data(index,7);
                if i == 1
                    left = 8;
                else
                    left = i-1;
                end
                error(index) = max([abs(DataOfInterestDistances(i) - LenT1), abs(DataOfInterestDistances(i+1) - LenT2) ...
                        , abs(DataOfInterestDistances(left) - LenT8)]);
            end
            [value,place] = min(error);
            DataForLeastErrorOfEachSet(idx_,:) = [value, data(place,1:4), idx, data(place,8), data(place,9)];
        end
        clear DataAll error data;
    end
    [~,int_idx] = min(DataForLeastErrorOfEachSet(:,1));
    DataForLeastErrorAmongstAll(count,:) = DataForLeastErrorOfEachSet(int_idx,:);

    if i > 1 && i < 7
        StatesAssigned(i:i+1) = DataForLeastErrorOfEachSet(int_idx,2:3);
    elseif i == 7
        StatesAssigned(i) = DataForLeastErrorOfEachSet(int_idx,2);
    elseif i == 1
        StatesAssigned(i:i+1) = DataForLeastErrorOfEachSet(int_idx,2:3);
        StatesAssigned(8) = DataForLeastErrorOfEachSet(int_idx,5);
        StatesAssigned(9) = DataForLeastErrorOfEachSet(int_idx,4);
    end

    switch DataForLeastErrorAmongstAll(count,6)
    case 1
        DirectoryOfDataFile = 'C:\Users\InSilico\Documents\MATLAB\OverlappingCases\HalfModel';
        nature = 1;% 1 = "Symmetric";
        similar = 0;
    case 2
        DirectoryOfDataFile = 'C:\Users\InSilico\Documents\MATLAB\OverlappingCases\FullModel';
        nature = 0;% 0 = "Unique";
        similar = 0;
    case 3
        DirectoryOfDataFile = 'C:\Users\InSilico\Documents\MATLAB\OverlappingCases\FullModel';
        nature = 0;% 0 = "Unique";
        similar = 1;
    end
    SetNo = DataForLeastErrorAmongstAll(count,7);case_no = DataForLeastErrorAmongstAll(count,8);

    filename = strcat(DirectoryOfDataFile,'\Set',num2str(SetNo), ...
                   '_Inorm_data_70by70by70_central_region_appended.txt');
    FigHandle = gcf; slice_plane = 'z'; slice_value = 47;azimuthal_angle = 0; %%%%%%%%%%%%% CORRECT SLICE POSIITON %%%%%%%%%%%%
    [x,y,z,v] = ReadmatrixFromDatabase(filename,nature,similar); % reflection
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
    if i > 1; Refined_M = RotateContourData(Refined_M,i); end %%% i corresponds to tine number.
    plot(Refined_M(1,:),Refined_M(2,:));axis square;
    % end
end