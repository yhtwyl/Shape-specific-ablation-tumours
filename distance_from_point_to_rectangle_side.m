function [z] = distance_from_point_to_rectangle_side(extreme_point,origin)
slope_of_side = (extreme_point(2,2) - extreme_point(2,1))/(extreme_point(1,2) - extreme_point(1,1));
slope_of_querry_line = (origin(2,1) - extreme_point(2,1))/(origin(1,1) - extreme_point(1,1));

if slope_of_side > 1000 %% in calling program care has been taken
    theta_radians = pi*0.5 - abs(atan(slope_of_querry_line));
else
    theta_radians = abs(atan((slope_of_querry_line - slope_of_side)/(1 + slope_of_side*slope_of_querry_line)));
end
    distance_of_corner = norm(origin - extreme_point(:,1));

    z = distance_of_corner*sin(theta_radians);