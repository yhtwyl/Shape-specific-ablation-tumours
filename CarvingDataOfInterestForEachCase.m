function [x_mat, y_mat, v_mat] = CarvingDataOfInterestForEachCase(filename, ...
    slice_value, grid_points, azimuthal_angle)%(filename,nature,case_no,similar,TineID,grid_points,slice_plane,slice_value,azimuthal_angle)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
case_no = 1; % for trial
[x,y,z,v] = ReadDatabaseAndReturnWholeListData(filename);
%% Symmetric case one half
% % if nature == "Symmetric"
% %     [x_rectangular, y_rectangular, z_rectangular, v_rectangular] = ReflectTheSymmetricData(x,y,z,v);
% %     [x, y, z, v] = MakeMatrixSquare(x_rectangular, y_rectangular, z_rectangular, v_rectangular);
% % else
% %     if similar == "Yes"
% %         [v] = SwapTheData(v);
% %     end
% % end
% % v = RotateTheAblation3DMatrix(x, y, z, v, TineID);
[x_mat,y_mat,v_mat] = ShapesDataForSliceFit(x,y,z,v,slice_plane,slice_value,azimuthal_angle);
end