function [x_mat,y_mat,v_mat] = ShapesDataForSliceFit(x,y,z,v,slice_plane,slice_value,azimuthal_angle)
%UNTITLED Summary of this function goes here
if slice_plane == "x"
    disp('X plane');
    min_limit = min(x(1,:,1));
    max_limit = max(x(1,:,1));
    grid_points = size(v,1);
    SliceFitFuncIdx = FindClosestIndex(slice_value,grid_points,min_limit,max_limit);% for cases with 70 grid points
    x_mat = reshape(y(:,SliceFitFuncIdx,:),[grid_points grid_points]);
    y_mat = reshape(z(SliceFitFuncIdx,:,:),[grid_points grid_points]);
    v_mat = reshape(v(SliceFitFuncIdx,:,:),[grid_points grid_points]);
elseif slice_plane == "y"
    disp('Y plane');
    min_limit = min(y(:,1,1));
    max_limit = max(y(:,1,1));
    grid_points = size(v,1);
    SliceFitFuncIdx = FindClosestIndex(slice_value,grid_points,min_limit,max_limit);% for cases with 70 grid points
    x_mat = reshape(x(SliceFitFuncIdx,:,:),[grid_points grid_points]);
    y_mat = reshape(z(:,SliceFitFuncIdx,:),[grid_points grid_points]);
    v_mat = reshape(v(:,SliceFitFuncIdx,:),[grid_points grid_points]);
elseif slice_plane == "z"
    disp('Z plane');
    min_limit = min(z(1,1,:));
    max_limit = max(z(1,1,:));
    grid_points = size(v,1);
    SliceFitFuncIdx = FindClosestIndex(slice_value,grid_points,min_limit,max_limit);% for cases with 70 grid points
    x_mat = reshape(x(:,:,SliceFitFuncIdx),[grid_points grid_points]);
    y_mat = reshape(y(:,:,SliceFitFuncIdx),[grid_points grid_points]);
    v_mat = reshape(v(:,:,SliceFitFuncIdx),[grid_points grid_points]);
elseif slice_plane == "xz"
    disp('XZ plane');
    min_limit = min(y(1,:,1));
    max_limit = max(y(1,:,1));
    grid_points = size(v,1);slice_value = 0;
    SliceFitFuncIdx = FindClosestIndex(slice_value,grid_points,min_limit,max_limit);% for cases with 70 grid points
    x_mat = reshape(x(:,SliceFitFuncIdx,:),[grid_points grid_points]);
    y_mat = reshape(z(:,SliceFitFuncIdx,:),[grid_points grid_points]);
    % v_mat = reshape(v(:,SliceFitFuncIdx,:),[grid_points grid_points]);
    [x_prime, y_prime] = CoordinatesOfSlicePlaneAtAnyAngle(x_mat,azimuthal_angle);
    %% Data corresponding to the slice plane
    F = griddedInterpolant(x,y,z,v);
    v_mat = F(x_prime,y_prime,y_mat);
    %    x_old_range = x_prime(:,1); y_old_range = y_prime(1,:);
    % x_mat = sqrt(x_prime.*x_prime + y_prime.*y_prime);
end
end 