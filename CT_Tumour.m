filename = load('C:\Users\2016m\Documents\MATLAB\FromCT_images\RefineSTL\3Dircadb1_16TumourAndBoundary.txt');
%% FOR JUGAAD
grid_points = 100; sides = zeros(2,3);
[x_mat,y_mat,z_mat,T_mat] = ReadDataFromFile(filename,grid_points);
%%
slice_height = 1;

%%%%% RECENTRE THE TUMOUR %%%%%%%%%
x_mean = mean(x_mat(1,:,1));y_mean = mean(y_mat(:,1,1));z_mean = mean(z_mat(1,1,:));
x_mat = x_mat - x_mean;y_mat = y_mat - y_mean;z_mat = z_mat - z_mean;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x_min = min(x_mat(1,:,1));x_max = max(x_mat(1,:,1));delta_x = (x_max - x_min)/100;
y_min = min(y_mat(:,1,1));y_max = max(y_mat(:,1,1));delta_y = (y_max - y_min)/100;
z_min = min(z_mat(1,1,:));z_max = max(z_mat(1,1,:));
ranges = [x_min y_min z_min;x_max y_max z_max];slice_planes = ['x','y','z'];
legends = [2,3;1,3;1,2];theta= linspace(0,2*pi,100);
for i = 1:3
    lower_limit = ranges(1,i); upper_limit = ranges(2,i); slice_plane = slice_planes(i);
    BottomSliceValue = ceil(lower_limit) + 4; TopSliceValue = floor(upper_limit) - 4; azimuthal_angle = 0; figure; fig1 = gcf;
    subplot_size = 1;
    for slice_value = BottomSliceValue:TopSliceValue
        [AverageDiaCurrentSlice(1,slice_value - BottomSliceValue + 1),~,~,~,~,~,~,~,~,~] = ...
            DoesEveryThingCtTumour(x_mat,y_mat,z_mat,T_mat,slice_plane,slice_value,azimuthal_angle,delta_x,delta_y,'no',fig1);
    end
    [value, index] = max(AverageDiaCurrentSlice);
    slice_value = BottomSliceValue + index - 1;
    [~,l1(1),l1(2),w1(1),w1(2),intersection_coords_length, intersection_coords_width,bb,AreaOfAblationOnSlicePlane,Refined_M] = ...
        DoesEveryThingCtTumour(x_mat,y_mat,z_mat,T_mat,slice_plane,slice_value,azimuthal_angle,delta_x,delta_y,'yes',fig1);
    hold on;
    plot([bb(1,:) bb(1,1)],[bb(2,:) bb(2,1)]);axis image;hold off;
    axs = gca; axs.FontSize = 10;
    set(get(gca, 'XLabel'), 'String', strcat(upper(slice_planes(legends(i,1))),'(mm)'));
    set(get(gca, 'YLabel'), 'String', strcat(upper(slice_planes(legends(i,2))),'(mm)'));
    sides(:,i) = [norm(bb(:,1) - bb(:,2));norm(bb(:,2) - bb(:,3))];
    if sides(1,i) > sides(2,:)
        D1 = sides(1,i);D2 = sides(2,i);
    else
        D1 = sides(2,i);D2 = sides(1,i);
    end
    set(get(gca, 'Title'), 'String', 'Slice');
    subtitle(strcat("D1 = ", num2str(D1),' | ',"D2 = ", num2str(D2)));
    clear AverageDiaCurrentSlice
    StatesOfAllNineTines = OverlappingFromDatabase(Refined_M,gcf);
    if size(StatesOfAllNineTines,1) ~= 0
        plot(0.5*(D1 + 10).*cos(theta),0.5*(D1 + 10).*sin(theta),'r');
    end
    disp(['States of all tines = ', num2str(StatesOfAllNineTines)]);
end