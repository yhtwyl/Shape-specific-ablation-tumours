DataOfInterest = zeros(2,24);
grid_points = 100;
filename = strcat('C:\Users\InSilico\Documents\MATLAB\OverlappingCases\Validation',...
    'Cases\FinalFourPresentedInArticle\Case1_INorm_data_central_region_100by100by100.txt');
DataOfInterest = DataGeneration(filename,grid_points);
DataSetsFilenames = {'CoordsAndDistancesSymmetricCases.txt','CoordsAndDistancesUniqueCases.txt','CoordsAndDistancesUniqueCasesBros.txt'};
DataOfInterestDistances = zeros(1,length(DataOfInterest));
for i = 1:length(DataOfInterest)
    DataOfInterestDistances(i) = norm(DataOfInterest(:,i));
end
error_limit = 0.5;
for i = 1:2:7
    error = 5.0;idx = 0;
    while idx < 3 && error > error_limit
        idx = idx + 1;
        data = load(DataSetsFilenames{idx});
        len = length(data);
        index = 0;
        while error > error_limit && index < len
            index = index + 1;
            LenT1 = data(index,7);
            LenT2 = data(index,8);
            LenT8 = data(index,9);
            if i == 1
                left = 8;
            else
                left = i-1;
            end
            error = max([abs(DataOfInterestDistances(i) - LenT1),abs(DataOfInterestDistances(i+1) - LenT2) ...
                    ,abs(DataOfInterestDistances(left) - LenT8)]);
        end
    end
    if error > error_limit
        disp(['No match bro! for tine ', num2str(i)]);
        break;
    end
    switch idx
    case 1
        DirectoryOfDataFile = 'C:\Users\InSilico\Documents\MATLAB\OverlappingCases\HalfModel';
        nature = "Symmetric";
        similar = 0;
        Sets = [1 2 3 4 5 7;21 30 37 44 47 50];
    case 2
        DirectoryOfDataFile = 'C:\Users\InSilico\Documents\MATLAB\OverlappingCases\FullModel';
        nature = "Unique";
        similar = 0;
        Sets = [1 2 3 4 5 6 8;19 42 51 60 67 74 77];
    case 3
        DirectoryOfDataFile = 'C:\Users\InSilico\Documents\MATLAB\OverlappingCases\FullModel';
        nature = "Unique";
        similar = 1;
        Sets = [1 2 3 4 5 6 8;19 42 51 60 67 74 77];
    end

    j = 1;
    SetNo = Sets(1,j); case_no = index;% - Sets(2,1);
    while (index > Sets(2,j)) && (index <= Sets(2,end))
        j = j + 1;
        SetNo = Sets(1,j);
        NoOfCasesInPrevSet = Sets(2,j-1);
        case_no = Sets(2,j) - NoOfCasesInPrevSet;
    end
    
    if index > Sets(2,end)
        disp('Bad luck bro!');
        % break;
    else
        %%TineID = i; %%

        filename = strcat(DirectoryOfDataFile,'\Set',num2str(SetNo), ...
                    '_Inorm_data_70by70by70_central_region_appended.txt');
        FigHandle = gcf; slice_plane = 'z'; slice_value = 47;azimuthal_angle = 0; %%%%%%%%%%%%% CORRECT SLICE POSIITON %%%%%%%%%%%%
        [x,y,z,v] = ReadmatrixFromDatabase(filename,similar); % reflection
        grid_points = 70; %%%%%%%%%% FOR DATABASE
        x_mat = reshape(x,[grid_points,grid_points,grid_points]);
        y_mat = reshape(y,[grid_points,grid_points,grid_points]);
        z_mat = reshape(z,[grid_points,grid_points,grid_points]);
        v_mat = reshape(v(:,case_no),[grid_points,grid_points,grid_points]);

        [x_tine_contribution,y_tine_contribution,v_tine_contribution] = ShapesDataForSliceFit...
                (x_mat,y_mat,z_mat,v_mat,slice_plane,slice_value,azimuthal_angle);
        [M, fm] = contour(x_tine_contribution,y_tine_contribution,v_tine_contribution,[1 1]);
        delete(fm);
        Refined_M = SolvingProblemOfPatch(M);
        if i > 1; Refined_M = RotateContourData(Refined_M,i); end %%% i corresponds to tine number.
        plot(Refined_M(1,:),Refined_M(2,:));axis square;
    end
end