function [x_square,y_square,z_square,v_square] = MakeMatrixSquare(x_rectangular, y_rectangular, z_rectangular, v_rectangular)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x_range = x_rectangular(:,1,1);y_range = y_rectangular(1,:,1);z_range = z_rectangular(1,1,:);
y_range = linspace(y_range(1),y_range(end),size(y_rectangular,1)); % Based upon the first dimension
[x_square, y_square, z_square] = ndgrid(x_range,y_range,z_range);
F = griddedInterpolant(x_rectangular,y_rectangular,z_rectangular,v_rectangular);
v_square = F(x_square,y_square, z_square);
end