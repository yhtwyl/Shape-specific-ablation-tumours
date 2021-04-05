function [l1, intersection_coords] = iterate_to_find_the_intersection(extreme_points, slope)
%  ITERATE_TO_FIND_THE_INTERSECTION Brief summary of this function.
% 
% Detailed explanation of this function.

if abs(slope) == 0
    x = extreme_points(1,1); y = 0;
elseif abs(slope) > 100000
    x = 0;y = extreme_points(2,1);
else
    origin = [0;0];
    perpendicular_distance_from_origin = distance_from_point_to_rectangle_side(extreme_points,origin);
    % point_of_interest = (norm(extreme_points(:,1)) <= norm(extreme_points(:,2))) : extreme_points(:,1) : extreme_points(:,2);
    delta_x = 0.01;
    % fprintf('delta_x = %f', delta_x);
    coords_of_p1 = [delta_x;slope*delta_x];
    %% 
    perpendicular_distance_upto_p1 = distance_from_point_to_rectangle_side(extreme_points,coords_of_p1);  % a misnomer not from origin here
    if (perpendicular_distance_upto_p1 > perpendicular_distance_from_origin);  delta_x  = -delta_x; end
    coords_of_p1 = [delta_x;slope*delta_x]; % must go inside the above if else statement....
    distance_from_origin_to_p1 = norm(coords_of_p1);
    %% perpendicular_distance_upto_p1 = distance_from_origin_to_rectangle_side(extreme_points,coords_of_p1); % a misnomer not from origin here
    x = 0;y = 0;

    while(distance_from_origin_to_p1 <= perpendicular_distance_from_origin)
        x = x + delta_x;
        y = slope*x;
        distance_from_origin_to_p1 = norm([x;y]);
    end
end
% fprintf('slope = %f \n',slope);
intersection_coords = [x;y];
l1 = norm(intersection_coords - extreme_points(:,1));
end