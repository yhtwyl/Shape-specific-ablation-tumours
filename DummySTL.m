%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% PASSED!!!! XY planes rotated at angles from 0 to 180 degree. PASSED YAHOOOOOOOOOOOOOOOOO  %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename = 'C:\Users\2016m\Documents\MATLAB\ASME_Upgraded\sample_wedge.stl';
slice_height = 0.1;rotation_axis = {'x','y','z'};%count = 1;
legends = [2,3;1,3;1,2]; % check it once
theta= linspace(0,2*pi,100); delta_theta = 90; % degree
triangles = read_binary_stl_file(filename);
centroid_z = mean(mean(triangles(:,[3 6 9])));
centroid_y = mean(mean(triangles(:,[2 5 8])));
centroid_x = mean(mean(triangles(:,[1 4 7])));
triangles(:,[3 6 9]) = triangles(:,[3 6 9]) - centroid_z;
triangles(:,[2 5 8]) = triangles(:,[2 5 8]) - centroid_y;
triangles(:,[1 4 7]) = triangles(:,[1 4 7]) - centroid_x;
DegreesSeparatingLatitudes = 90; DegreesSeparatingLongitudes = 90;radius = 20;
[GridSquareX, GridSquareY, GridSquareZ] = GridSquare(DegreesSeparatingLatitudes, DegreesSeparatingLongitudes, radius);
% figure;plot3(GridSquareX(2,2),GridSquareY(2,2),GridSquareZ(2),'*');hold on;
% plot3(GridSquareX(3,2),GridSquareY(3,2),GridSquareZ(3),'o');
% plot3(GridSquareX(4,2),GridSquareY(4,2),GridSquareZ(4),'x');
% plot3(GridSquareX(5,2),GridSquareY(5,2),GridSquareZ(5),'+');
LatitudeAngles = 0:DegreesSeparatingLatitudes:(360 - DegreesSeparatingLatitudes);
% for i = 2:5
%     if LatitudeAngles(i-1) ~= 0 && LatitudeAngles(i-1) ~= 180
%         vec_x = [GridSquareX(i,2-1), GridSquareY(i,2-1), GridSquareZ(i); GridSquareX(i,2+1), GridSquareY(i,2+1), GridSquareZ(i)];
%     else
%         vec_x = [GridSquareX(i+1,2-1), GridSquareY(i+1,2-1), GridSquareZ(i+1); GridSquareX(i+1,2+1), GridSquareY(i+1,2+1), GridSquareZ(i+1)]; %% CHECK FOR ANY FUTURE ERRORS IN gridSquareZ index
%     end
%     vec_y = [GridSquareX(i-1,2), GridSquareY(i-1,2), GridSquareZ(i-1); GridSquareX(i+1,2), GridSquareY(i+1,2), GridSquareZ(i+1)];
%     vec_x = vec_x(2,:) - vec_x(1,:);vec_x = vec_x./norm(vec_x);vec_x = [0,0,0;vec_x];
%     vec_y = vec_y(2,:) - vec_y(1,:);vec_y = vec_y./norm(vec_y);vec_y = [0,0,0;vec_y];
%     figure; plot3(vec_x(:,1),vec_x(:,2),vec_x(:,3),'b');hold on;
%     plot3(vec_y(:,1),vec_y(:,2),vec_y(:,3),'r');axis image;set(get(gca, 'XLabel'),...
%      'String', 'X');set(get(gca, 'YLabel'), 'String', 'Y');set(get(gca, 'ZLabel'), 'String', 'Z');
% end
% [X,Y,Z] = sphere;
% r = 10;
% X2 = X * r;
% Y2 = Y * r;
% Z2 = Z * r;
% surf(X2,Y2,Z2);hold off;axis image;
% IndexGrid = 2;
marker = {'*','^','>','<','+'};
for longitude = 0%:delta_theta:(360 - delta_theta)
    tri_long = rotate_stl(triangles,"longitude",longitude);
    % IndexLat = 2;
    count = 0;
    for latitude = 0:delta_theta:(360 - delta_theta)
        count = count + 1;
        tri_long_lat = rotate_stl(tri_long,"latitude",-latitude);
        [Slices] = slice_stl_create_path(tri_long_lat,slice_height);
        % figure; fig1 = gcf;
        BottomSliceValue = 4; TopSliceValue = size(Slices,2) - 4;
        % for slice_value = BottomSliceValue:TopSliceValue
        % NiceDataCutPlane = RefineStlSliceFlipV3(Slices{slice_value},"no");%Show z-slice height or not.
        %     [AverageDiaCurrentSlice(1,slice_value - BottomSliceValue + 1),~,~,~,~,~,~,~] = ...
        %         DoesEveryThingCtTumourSTL(NiceDataCutPlane,'no',fig1);
        %     clear NiceDataCutPlane;
        % end
        % [value, index] = max(AverageDiaCurrentSlice);
        index = 5;
        slice_value = BottomSliceValue + index - 1;
        NiceDataCutPlane = RefineStlSliceFlipV3(Slices{slice_value},"yes");
        %plot3(NiceDataCutPlane(:,1),NiceDataCutPlane(:,2),NiceDataCutPlane(:,3));axis image;
        NiceDataCutPlane = rotate_slice(rotate_slice(NiceDataCutPlane,"latitude",latitude),"longitude",-longitude);
        % NiceDataCutPlane = rotate_slice(NiceDataCutPlane,"longitude",-longitude);
        GlobalCS = [1,0,0;0,1,0;0,0,1];
        LocalCS = rotz(-longitude)*roty(latitude)*GlobalCS;
        % LocalCS = FindTheNormal(FindTheNormal(GlobalCS,"latitude",latitude),"longitude",-longitude);
        figure;plot3(NiceDataCutPlane(:,1),NiceDataCutPlane(:,2),NiceDataCutPlane(:,3));axis image;hold on;
        set(get(gca, 'XLabel'), 'String', 'X');set(get(gca, 'YLabel'), 'String', 'Y');set(get(gca, 'ZLabel'), 'String', 'Z');
        
        % plot3(LocalCS(1,3),LocalCS(2,3),LocalCS(3,3),marker{count});hold off;
        view(LocalCS(:,3));

        % if longitude >= 270 || longitude <= 90
        %     IndexLongFrom = IndexGrid - 1; IndexLongTo = IndexGrid + 1;
        % else
        %     IndexLongFrom = IndexGrid + 1; IndexLongTo = IndexGrid - 1;
        % end

        % if latitude ~= 0 && latitude ~= 180
        %     vec_x = [GridSquareX(IndexLat,IndexLongFrom), GridSquareY(IndexLat,IndexLongFrom), GridSquareZ(IndexLat); ...
        %       GridSquareX(IndexLat,IndexLongTo), GridSquareY(IndexLat,IndexLongTo), GridSquareZ(IndexLat)];
        % else
        %     vec_x = [GridSquareX(IndexLat+1,IndexGrid-1), GridSquareY(IndexLat+1,IndexGrid-1), GridSquareZ(IndexLat+1); ...
        %       GridSquareX(IndexLat+1,IndexGrid+1), GridSquareY(IndexLat+1,IndexGrid+1), GridSquareZ(IndexLat+1)]; %% CHECK FOR ANY FUTURE ERRORS IN gridSquareZ index
        % end
        
        % if latitude <= 180
        %     IndexLatFrom = IndexLat + 1; IndexLatTo = IndexLat - 1;
        % else
        %     IndexLatFrom = IndexLat - 1; IndexLatTo = IndexLat + 1;
        % end
        
        % vec_y = [GridSquareX(IndexLatFrom,IndexGrid), GridSquareY(IndexLatFrom,IndexGrid), GridSquareZ(IndexLatFrom);...
        %   GridSquareX(IndexLatTo,IndexGrid), GridSquareY(IndexLatTo,IndexGrid), GridSquareZ(IndexLatTo)];
        %vec_x = vec_x(2,:) - vec_x(1,:);vec_x = vec_x./norm(vec_x)% vec_x = [0,0,0;vec_x];
        %vec_y = vec_y(2,:) - vec_y(1,:);vec_y = vec_y./norm(vec_y)% vec_y = [0,0,0;vec_y];
        vec_x = LocalCS(:,1);vec_y = LocalCS(:,2);
        local_x_axis_mat = ones(size(NiceDataCutPlane));
        local_y_axis_mat = local_x_axis_mat;
        local_x_axis_mat(:,1) = vec_x(1);
        local_x_axis_mat(:,2) = vec_x(2);
        local_x_axis_mat(:,3) = vec_x(3);
        X_Cords = dot(NiceDataCutPlane,local_x_axis_mat,2);
        local_y_axis_mat(:,1) = vec_y(1);
        local_y_axis_mat(:,2) = vec_y(2);
        local_y_axis_mat(:,3) = vec_y(3);
        Y_Cords = dot(NiceDataCutPlane,local_y_axis_mat,2);
        figure;plot(X_Cords,Y_Cords,'r');axis image;set(get(gca, 'XLabel'), 'String', 'X');set(get(gca, 'YLabel'), 'String', 'Y');
%{
        LocalCoordOrigin = [0, 0, NiceDataCutPlane(1,3)];
        LocalCoordOrigin = rotate_origin(LocalCoordOrigin,"longitude",-longitude);
        LocalCoordOrigin = rotate_origin(LocalCoordOrigin,"latitude",-latitude);
        localcoord = global2localcoord(NiceDataCutPlane','rr',LocalCoordOrigin');%%% too much reduntant cpmputations.
        localcoord = localcoord';
        figure;plot3(localcoord(:,1),localcoord(:,2),localcoord(:,3));axis image; 
%}

        %%%%%%%%%%%%%% RECENTRE THE CONTOUR %%%%%%%%%%%%%
        % mean_xy = mean(NiceData,2); NiceData(1,:) = NiceData(1,:) - mean_xy(1); NiceData(2,:) = NiceData(2,:) - mean_xy(2);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % [~,l1(1),l1(2),w1(1),w1(2),intersection_coords_length, intersection_coords_width,bb] = ...
        %     DoesEveryThingCtTumourSTL(NiceDataCutPlane,'yes',fig1);
        % plot([bb(1,:) bb(1,1)],[bb(2,:) bb(2,1)]);axis image;hold off;
        % axs = gca; axs.FontSize = 10;
        % %% set(get(gca, 'XLabel'), 'String', strcat(upper(slice_planes(legends(i,1))),'(mm)'));
        % %% set(get(gca, 'YLabel'), 'String', strcat(upper(slice_planes(legends(i,2))),'(mm)'));
        % sides(:,count) = [norm(bb(:,1) - bb(:,2));norm(bb(:,2) - bb(:,3))];
        % if sides(1,count) > sides(2,:)
        %     D1 = sides(1,count);D2 = sides(2,count);
        % else
        %     D1 = sides(2,count);D2 = sides(1,count);
        % end
        % set(get(gca, 'Title'), 'String', 'Slice');
        % subtitle(strcat("D1 = ", num2str(D1),' | ',"D2 = ", num2str(D2)));
        % count = count + 1;
        % IndexLat = IndexLat + 1;
    end
    % IndexGrid = IndexGrid + 1;
    %%%% clear AverageDiaCurrentSlice
%{
     StatesOfAllNineTines = OverlappingFromDatabase(NiceData,gcf);
    if size(StatesOfAllNineTines,1) ~= 0
        plot(0.5*(D1 + 10).*cos(theta),0.5*(D1 + 10).*sin(theta),'r');
    end
    disp(['States of all tines = ', num2str(StatesOfAllNineTines)]);
 %}
end