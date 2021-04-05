function [l1, l2, w1, w2, intersection_coords_on_length, intersection_coords_on_width] = finding_the_right_dimensions(bb)
%  FINDING_THE_RIGHT_DIMENSIONS Brief summary of this function.
% 
% Detailed explanation of this function.
% origin = [0;0];
side_12 = norm(bb(:,1) - bb(:,2));
side_23 = norm(bb(:,2) - bb(:,3));
if side_12 >= side_23
    longer_dimension_extreme_points = [bb(:,1), bb(:,2)];
    shorter_dimension_extreme_points = [bb(:,2), bb(:,3)];
else
    longer_dimension_extreme_points = [bb(:,2), bb(:,3)];
    shorter_dimension_extreme_points = [bb(:,1), bb(:,2)];
end
slope_longer_dimension = (longer_dimension_extreme_points(2,2) - longer_dimension_extreme_points(2,1))/...
    (longer_dimension_extreme_points(1,2) - longer_dimension_extreme_points(1,1));
slope_shorter_dimension = (shorter_dimension_extreme_points(2,2) - shorter_dimension_extreme_points(2,1))/...
    (shorter_dimension_extreme_points(1,2) - shorter_dimension_extreme_points(1,1));
[l1, intersection_coords_on_length] = iterate_to_find_the_intersection(longer_dimension_extreme_points,slope_shorter_dimension);
if (side_12 >= side_23); l2 = side_12 - l1; else; l2 = side_23 - l1; end 
[w1, intersection_coords_on_width] = iterate_to_find_the_intersection(shorter_dimension_extreme_points,slope_longer_dimension);
if (side_12 <= side_23); w2 = side_12 - w1; else; w2 = side_23 - w1; end
end