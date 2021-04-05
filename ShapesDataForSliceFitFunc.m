function [x_mat,y_mat,v_mat] = ShapesDataForSliceFitFunc(data,case_no,y_shift,grid_points,slice_plane,slice_pos)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x = reshape(data(:,1),[grid_points grid_points grid_points]);
y = reshape(data(:,2) - y_shift,[grid_points grid_points grid_points]);
z = reshape(data(:,3),[grid_points grid_points grid_points]);
if slice_plane == "y"
    min_limit = min(y(1,:,1));
    max_limit = max(y(1,:,1));
elseif slice_plane == "z"
    min_limit = min(z(1,1,:));
    max_limit = max(z(1,1,:));
end
SliceFitFuncIdx = FindClosestIndex(slice_pos,grid_points,min_limit,max_limit);% for cases with 70 grid points
% z_SliceFitValidationIdx = FindClosestIndex(zslice,100); % for validation group o0r cases with 100 grid points
i = case_no;
v_reshaped = reshape(data(:,3+i),[grid_points grid_points grid_points]);
% for j = 1:grid_points
%     x(:,:,j) = x(:,:,j).';
%     y(:,:,j) = y(:,:,j).';
%     z(:,:,j) = z(:,:,j).';
%     v_reshaped(:,:,j) = v_reshaped(:,:,j).';
% end
% y = -y;
if slice_plane == "y"
    x_mat = reshape(x(:,SliceFitFuncIdx,:),[grid_points grid_points]);
    y_mat = reshape(z(:,SliceFitFuncIdx,:),[grid_points grid_points]);
    v_mat = reshape(v_reshaped(:,SliceFitFuncIdx,:),[grid_points grid_points]);
elseif slice_plane == "z"
    x_mat = reshape(x(:,:,SliceFitFuncIdx),[grid_points grid_points]);
    y_mat = reshape(y(:,:,SliceFitFuncIdx),[grid_points grid_points]);
    v_mat = reshape(v_reshaped(:,:,SliceFitFuncIdx),[grid_points grid_points]);
end
end

