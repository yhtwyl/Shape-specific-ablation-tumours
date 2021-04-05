nature = "Unique";%"Symmetric"; % or 
reflection = "no"; % yes or no. In reference to symmtery of second kind. Cases following symmetry of first kind do not follow reflection.
if nature == "Unique"
    DirectoryOfDataFile = '~/Documents/MATLAB/PreviousProblem/OverlappingCases/FullModel';
    Sets = [1 19; 2 23; 3 9; 4 9; 5 7; 6 7; 8 3];
elseif nature   == "Symmetric"
    DirectoryOfDataFile = '~/Documents/MATLAB/PreviousProblem/OverlappingCases/HalfModel'; %
    Sets = [1 21; 2 9; 3 7; 4 7; 5 3; 7 3];
end
DataOfInterest = zeros(sum(Sets(:,2)),9);
grid_points = 70;
bottom_slice_value = 46;
top_slice_value = 55;
count_idx = 0; row = 0;
AverageDiaCurrentSlice = zeros(1,top_slice_value - bottom_slice_value + 1);
figure;fig1 = gcf;
for j = 2%;1:length(Sets)
    filename = strcat(DirectoryOfDataFile,'/Set',num2str(Sets(j,1)), ...
    '_Inorm_data_70by70by70_central_region_appended.txt');
    % filename = ('C:\Users\InSilico\Documents\MATLAB\OverlappingCases\FullModel\Set1_Inorm_data_70by70by70_central_region_Case_last.txt');
    % fprintf("read filename in main function at loop count %d = %s\n",list_(j) , filename);
    [x,y,z,v] = ReadDatabaseAndReturnWholeListData(filename,reflection);
    no_of_cases = min(size(v));slice_plane = 'z';azimuthal_angle = 0;
    delta_x = (max(x) - min(x))/grid_points; delta_y = (max(y) - min(y))/grid_points;
    count_idx = count_idx + 1;
    x_mat = reshape(x,[grid_points,grid_points,grid_points]);
    y_mat = reshape(y,[grid_points,grid_points,grid_points]);
    z_mat = reshape(z,[grid_points,grid_points,grid_points]);
    case_nos = Sets(count_idx,2);
    for i = 1:1%case_nos
        v_mat = reshape(v(:,i),[grid_points,grid_points,grid_points]);

        if nature == "Symmetric"
            [x_rectangular, y_rectangular, z_rectangular, v_rectangular] = ReflectTheSymmetricData(x_mat, y_mat, z_mat,v_mat);
            [x_mat, y_mat, z_mat, v_mat] = MakeMatrixSquare(x_rectangular, y_rectangular, z_rectangular, v_rectangular);
        end

        for slice_value = bottom_slice_value:top_slice_value
            [AverageDiaCurrentSlice(1,slice_value - bottom_slice_value + 1),~,~] = ...
                DoesEveryThing(x_mat,y_mat,z_mat,v_mat,slice_plane,slice_value,azimuthal_angle,delta_x,delta_y,'no',fig1);
        % index = index + 1;
        end
        [value, index] = max(AverageDiaCurrentSlice);
        slice_value = bottom_slice_value + index - 1;
        [~,AreaOfAblationOnSlicePlane,CoordinatesAlongTines] = ...
            DoesEveryThing(x_mat,y_mat,z_mat,v_mat,slice_plane,slice_value,azimuthal_angle,delta_x,delta_y,'yes',fig1);
        pause(1);
        %clf(fig1);
        %Coords = [CoordinatesAlongTines(1,:) CoordinatesAlongTines(2,:)];
        DistanceAlongPoints = [norm(CoordinatesAlongTines(:,1)),norm(CoordinatesAlongTines(:,2)),...
        norm(CoordinatesAlongTines(:,3))];
        row = row + 1;
        DataOfInterest(row,:) = [CoordinatesAlongTines(1,:), CoordinatesAlongTines(2,:), DistanceAlongPoints];
    end
end
