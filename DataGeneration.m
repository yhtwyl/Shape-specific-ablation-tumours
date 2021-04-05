function [TargetData,slice_value] = DataGeneration(filename,grid_points)
    % grid_points = 100;
    bottom_slice_value = 46;
    top_slice_value = 55; index = 0;
    count_idx = 0; row = 0;
    AverageDiaCurrentSlice = zeros(1,top_slice_value - bottom_slice_value + 1);
    [x_mat,y_mat,z_mat,v_mat] = ReadDataFromFile(filename,grid_points);
    slice_plane = 'z';azimuthal_angle = 0;
    delta_x = (max(x_mat(:,1,1)) - min(x_mat(:,1,1)))/grid_points; delta_y = (max(y_mat(1,:,1)) - min(y_mat(1,:,1)))/grid_points;
    % count_idx = count_idx + 1;
    figure;fig1 = gcf;
    for slice_value = bottom_slice_value:top_slice_value
        %% figure;fig1 = gcf;
        [AverageDiaCurrentSlice(1,slice_value - bottom_slice_value + 1),~] = ...
            FakeDoesEverything(x_mat,y_mat,z_mat,v_mat,slice_plane,slice_value,azimuthal_angle,delta_x,delta_y,'no',fig1);
        index = index + 1;
    end
    % pause(2);
    [value, index] = max(AverageDiaCurrentSlice);
    slice_value = bottom_slice_value + index - 1;

    [~,TargetData] = FakeDoesEverything(x_mat,y_mat,z_mat,v_mat,slice_plane,slice_value,azimuthal_angle,delta_x,delta_y,'yes',fig1);
end