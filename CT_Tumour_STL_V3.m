%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% PASSED!!!! XY planes rotated at angles from 0 to 180 degree. PASSED YAHOOOOOOOOOOOOOOOOO  %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;
[ret, name] = system('hostname');
filename = 'C:\Users\2016m\Documents\MATLAB\ASME_Upgraded\livertumorsegmentation_livertumor.stl';
slice_height = 1;rotation_axis = {'x','y','z'};count = 1;
legends = [2,3;1,3;1,2]; % check it once
theta= linspace(0,2*pi,100); delta_theta = 90; % degree
triangles = read_binary_stl_file(filename);
centroid_z = mean(mean(triangles(:,[3 6 9])));
centroid_y = mean(mean(triangles(:,[2 5 8])));
centroid_x = mean(mean(triangles(:,[1 4 7])));
triangles(:,[3 6 9]) = triangles(:,[3 6 9]) - centroid_z;
triangles(:,[2 5 8]) = triangles(:,[2 5 8]) - centroid_y;
triangles(:,[1 4 7]) = triangles(:,[1 4 7]) - centroid_x;
TopEntry = 0; start_lat = 0; end_lat = 180;
for longitude = 0:delta_theta:(360 - delta_theta)
    tri_long = rotate_stl(triangles,"longitude",longitude);
    for latitude = start_lat:delta_theta:end_lat
        tri_long_lat = rotate_stl(tri_long,"latitude",-latitude);
        [Slices,min_z,max_z] = slice_stl_create_path(tri_long_lat,slice_height);
        VerticalTumourLimits = [min_z, max_z];
        %% figure; fig1 = gcf;
        BottomSliceValue = 4; TopSliceValue = size(Slices,2) - 4;
        for slice_value = BottomSliceValue:TopSliceValue
            NiceDataCutPlane = RefineStlSliceFlipV3(Slices{slice_value},"no");%Show z-slice height or not.
            [AverageDiaCurrentSlice(1,slice_value - BottomSliceValue + 1),~,~,~,~,~,~,~] = ...
                DoesEveryThingCtTumourSTL(NiceDataCutPlane(:,1:2),'no',fig1);
            clear NiceDataCutPlane;
        end
        [value, index] = max(AverageDiaCurrentSlice);
        slice_value = BottomSliceValue + index - 1;
        NiceDataCutPlane = RefineStlSliceFlipV3(Slices{slice_value},"yes");
        %%%%%%%%%%%%%% RECENTRE THE CONTOUR %%%%%%%%%%%%%
        % mean_xy = mean(NiceData,2); NiceData(1,:) = NiceData(1,:) - mean_xy(1); NiceData(2,:) = NiceData(2,:) - mean_xy(2);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [~,l1(1),l1(2),w1(1),w1(2),intersection_coords_length, intersection_coords_width,bb] = ...
            DoesEveryThingCtTumourSTL(NiceDataCutPlane(:,1:2),'no',fig1);
        %% plot([bb(1,:) bb(1,1)],[bb(2,:) bb(2,1)]);axis image;hold off;
        axs = gca; axs.FontSize = 10;
        %%%% set(get(gca, 'XLabel'), 'String', strcat(upper(slice_planes(legends(i,1))),'(mm)'));
        %%%% set(get(gca, 'YLabel'), 'String', strcat(upper(slice_planes(legends(i,2))),'(mm)'));
        sides(:,count) = [norm(bb(:,1) - bb(:,2));norm(bb(:,2) - bb(:,3))];
        if sides(1,count) > sides(2,count)
            D1 = sides(1,count);D2 = sides(2,count);
        else
            D1 = sides(2,count);D2 = sides(1,count);
        end
        %% set(get(gca, 'Title'), 'String', 'Slice');
        subtitle(strcat("D1 = ", num2str(D1),' | ',"D2 = ", num2str(D2)));
        [StatesOfAllNineTines, area, VerticalAblationLimits] = OverlappingFromDatabase(NiceDataCutPlane(:,1:2)',gcf);
        % % if size(StatesOfAllNineTines,1) ~= 0
        % %     % if D1 < D2
        % %     %     D1 = D2;
        % %     % end 
        % %     plot(0.5*(D1 + 10).*cos(theta),0.5*(D1 + 10).*sin(theta),'r');
        % % end
        if size(StatesOfAllNineTines,1) ~= 0
            disp(['States of all tines = ', num2str(StatesOfAllNineTines)]);
            fprintf('Area of ablation on slice covering max spread of tumour for trocar entry at: \n');
            formatSpec = '%3d%c N and %3d%c E is %6.2f mm\n';
            fprintf(formatSpec, longitude, char(176), latitude, char(176), area);
            if sum(abs(VerticalTumourLimits) < abs(VerticalAblationLimits)) == 2
                disp(['Upper limit diff = ', num2str(VerticalAblationLimits(2) - VerticalTumourLimits(2))]);
                disp(['Lower limit diff = ', num2str(VerticalTumourLimits(1) - VerticalAblationLimits(1))]);
            else
                fprintf('You must be careful with the choice of states');
            end
        else
            disp('Empty shot for trocar entry at: ')
            formatSpec = '%3d%c N and %3d%c E\n';
            fprintf(formatSpec, longitude, char(176), latitude, char(176));
        end
        count = count + 1;
    end
    if TopEntry == 0
        TopEntry = 1;
        start_lat = 90;
        end_lat = 180 - delta_theta;
    end
    %%%% clear AverageDiaCurrentSlice
end
toc