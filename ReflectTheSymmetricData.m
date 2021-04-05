function  [x_mat, y_mat, z_mat, v_mat] = ReflectTheSymmetricData(x,y,z,v)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%% REFLECTION OF DATA
grid_points = length(x);
v_mat = zeros(grid_points,2*grid_points - 1,grid_points);
v_mat(:,1:grid_points,:) = v;
v_mat(:,grid_points+1:end,:) = v(:,grid_points-1:-1:1,:);
%% Expand Coordinate matrices
x_range = x(:,1,1);y_range = linspace(min(y(1,:,1)),-min(y(1,:,1)),2*grid_points - 1);z_range = z(1,1,:);
[x_mat, y_mat, z_mat] = ndgrid(x_range, y_range, z_range);
end