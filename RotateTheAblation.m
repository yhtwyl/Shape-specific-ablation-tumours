function [v_new] = RotateTheAblation(x, y, z, v_new, TineID)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
v_new(v_new<1) = 0;
if TineID ~= 1
    F = griddedInterpolant(x,y,z,v_new);
    x_grid = size(v_new,1);y_grid = size(v_new,2);z_grid = size(v_new,3);
    angle = 360/8;angle = -angle*(TineID - 1);
    R = [cosd(angle) sind(angle); -sind(angle) cosd(angle)];
    for iz = 1:z_grid
        for iy = 1:y_grid
            for ix = 1:x_grid
                source_coords = R*[x(ix,iy,iz); y(ix,iy,iz)];
                v_new(ix,iy,iz) = F([source_coords' z(ix,iy,iz)]);
            end
        end
    end
end
end