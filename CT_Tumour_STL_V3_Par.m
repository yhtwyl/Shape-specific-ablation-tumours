%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% PASSED!!!! XY planes rotated at angles from 0 to 180 degree. PASSED YAHOOOOOOOOOOOOOOOOO  %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;
TumourMargin = 3.0; %% Safety margin. Keep it 2 less than advised numerical error will take care of 2 mm.
userProfile = getenv('USERPROFILE');
filename = strcat(userProfile,'\Documents\MATLAB\ASME_Upgraded\livertumour19_3.stl');
slice_height = 1;rotation_axis = {'x','y','z'};count = 1;
legends = [2,3;1,3;1,2]; % check it once
theta= linspace(0,2*pi,100); delta_theta = 18; % degree
triangles = read_binary_stl_file(filename);
centroid_z = mean(mean(triangles(:,[3 6 9])));
centroid_y = mean(mean(triangles(:,[2 5 8])));
centroid_x = mean(mean(triangles(:,[1 4 7])));
triangles(:,[3 6 9]) = triangles(:,[3 6 9]) - centroid_z;
triangles(:,[2 5 8]) = triangles(:,[2 5 8]) - centroid_y;
triangles(:,[1 4 7]) = triangles(:,[1 4 7]) - centroid_x;
TopEntry = 0; start_lat = 0; end_lat = 180;
%model = createpde(3);
% importGeometry(model,'C:\Users\2016m\Documents\MATLAB\ASME_Upgraded\livertumorsegmentation_livertumor.stl');
theta_long = 0:delta_theta:(360 - delta_theta);
theta_long = theta_long';
theta_lat = 0:delta_theta:180;
theta_lat = theta_lat';thetas = [];
for i = 1:length(theta_long)
    if i~=1
        thetas = [thetas;theta_long(i).*ones(size(theta_lat,1)-2,1),theta_lat(2:end-1)];
    else
        thetas = [theta_long(i).*ones(size(theta_lat,1),1), theta_lat];        
    end
end

% thetas = [theta_long,]
%for longitude = 0:delta_theta:(360 - delta_theta)
longitude = thetas(:,1);latitude = thetas(:,2);%AverageDiaCurrentSlice = zeros(1,100);
parfor i = 1:size(thetas,1)
    AverageDiaCurrentSlice = zeros(1,100);
%     longitude = thetas(i,1);
%     latitude = thetas(i,2);
    tri_long = rotate_stl(triangles,"longitude",longitude(i));
    tri_long_lat = rotate_stl(tri_long,"latitude",-latitude(i));
    [Slices,min_z,max_z] = slice_stl_create_path(tri_long_lat,slice_height);
    VerticalTumourLimits = [min_z, max_z];
    %figure; fig1 = gcf;hold on;
    BottomSliceValue = 4; TopSliceValue = size(Slices,2) - 4;
    slice_values = BottomSliceValue:TopSliceValue;
    for j = 1:numel(slice_values)
        NiceDataCutPlane = RefineStlSliceFlipV3(Slices{slice_values(j)},"no");%Show z-slice height or not.
        [AverageDiaCurrentSlice(1,j),~,~,~,~,~,~,~] = ...
            DoesEveryThingCtTumourSTL_NoFig(NiceDataCutPlane(:,1:2));%,'no',fig1);
        % NiceDataCutPlane = [];
    end
    [value, index] = max(AverageDiaCurrentSlice);
    slice_value = BottomSliceValue + index - 1;
    NiceDataCutPlane = RefineStlSliceFlipV3(Slices{slice_value},"yes");
    %%%%%%%%%%%%%% RECENTRE THE CONTOUR %%%%%%%%%%%%%
    % mean_xy = mean(NiceData,2); NiceData(1,:) = NiceData(1,:) - mean_xy(1); NiceData(2,:) = NiceData(2,:) - mean_xy(2);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [~,~,~,~,~,intersection_coords_length, intersection_coords_width,bb] = ...
        DoesEveryThingCtTumourSTL_NoFig(NiceDataCutPlane(:,1:2));
    %% plot([bb(1,:) bb(1,1)],[bb(2,:) bb(2,1)]);axis image;hold off;
    % axs = gca; axs.FontSize = 10;
    %%%% set(get(gca, 'XLabel'), 'String', strcat(upper(slice_planes(legends(i,1))),'(mm)'));
    %%%% set(get(gca, 'YLabel'), 'String', strcat(upper(slice_planes(legends(i,2))),'(mm)'));
    % sides(:,count) = [norm(bb(:,1) - bb(:,2));norm(bb(:,2) - bb(:,3))];
    % if sides(1,count) > sides(2,count)
    %     D1 = sides(1,count);D2 = sides(2,count);
    % else
    %     D1 = sides(2,count);D2 = sides(1,count);
    % end
    %% set(get(gca, 'Title'), 'String', 'Slice');
    %% subtitle(strcat("D1 = ", num2str(D1),' | ',"D2 = ", num2str(D2)));
    [StatesOfAllNineTines, area, VerticalAblationLimits, PredictedAblation] = OverlappingFromDatabase3D_NoFig(NiceDataCutPlane(:,1:2)',userProfile);%,gcf);
    % % if size(StatesOfAllNineTines,1) ~= 0
    % %     % if D1 < D2
    % %     %     D1 = D2;
    % %     % end 
    % %     plot(0.5*(D1 + 10).*cos(theta),0.5*(D1 + 10).*sin(theta),'r');
    % % end
    if size(StatesOfAllNineTines,1) ~= 0
        % disp(['States of all tines = ', num2str(StatesOfAllNineTines)]);
        % fprintf('Area of ablation on slice covering max spread of tumour for trocar entry at: \n');
        % formatSpec = '%3d%c N and %3d%c E is %6.2f mm\n';
        % fprintf(formatSpec, longitude(i), char(176), latitude(i), char(176), NiceDataCutPlane(10,3));
        % disp(num2str(NiceDataCutPlane(10,3)));
        % if sum(abs(VerticalTumourLimits) < abs(VerticalAblationLimits)) == 2 %% CHECK THIS OUT
        %     disp(['Upper limit diff = ', num2str(VerticalAblationLimits(2) - VerticalTumourLimits(2))]);
        %     disp(['Lower limit diff = ', num2str(VerticalTumourLimits(1) - VerticalAblationLimits(1))]);
        % else
        %     fprintf('You must be careful with the choice of states');
        % end
        tri_long_lat(:,[3,6,9]) = tri_long_lat(:,[3,6,9]) - NiceDataCutPlane(10,3);
        Flag = IsTumourCoveredByAblation(tri_long_lat,PredictedAblation,TumourMargin); % Nothing special about index 10;
        if Flag
            % figure;fig1 = gcf;hold on;
            % plot(alphaShape(PredictedAblation,20));axis image;
            % PlotShiftedAndRotatedTumour(tri_long_lat,fig1); hold off;
            disp('ADB ^3');
            disp('For trocar entry at: ');
            formatSpec = '%3d%c N and %3d%c E\n';
            fprintf(formatSpec, longitude(i), char(176), latitude(i), char(176));
            disp(['States of all tines = ', num2str(StatesOfAllNineTines)]);
        % else
            % close(gcf);
            % disp('DISCARD THIS APPROACH ANGLE');
        end
    % else
        %close(gcf);
        % disp('Empty shot for trocar entry at: ')
        % formatSpec = '%3d%c N and %3d%c E\n';
        % fprintf(formatSpec, longitude(i), char(176), latitude(i), char(176));
    end
    % count = count + 1;
end
%%%% clear AverageDiaCurrentSlice
%end
toc