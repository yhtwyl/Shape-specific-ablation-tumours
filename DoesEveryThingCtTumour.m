function [AverageDiaCurrentSlice_,l1,l2,w1,w2,intersection_coords_on_length,intersection_coords_on_width,bb,AreaOfAblationOnSlicePlane, Refined_M] = ...
    DoesEveryThingCtTumour(x_mat,y_mat,z_mat,v_mat,slice_plane,slice_value,azimuthal_angle,delta_x,delta_y,plot_or_not,fig1)
    [x_tine_contribution, y_tine_contribution, v_tine_contribution] = ShapesDataForSliceFit...
        (x_mat,y_mat,z_mat,v_mat,slice_plane,slice_value,azimuthal_angle);
    [M, fm] = contour(x_tine_contribution,y_tine_contribution,v_tine_contribution,[0.7 0.7]);
    delete(fm);
    Refined_M = SolvingProblemOfPatch(M);
    bb = minBoundingBox(Refined_M);
    side_12 = norm(bb(:,1) - bb(:,2));
    side_23 = norm(bb(:,2) - bb(:,3));
    [l1,l2,w1,w2,intersection_coords_on_length, intersection_coords_on_width] = ...
        finding_the_right_dimensions(bb);
    AverageDiaCurrentSlice_ = 0.5*(side_12 + side_23);
    AreaOfAblationOnSlicePlane = 0;

    %if FindCordsAlongTines == "yes"
    
    % CordsAlongTines = FindingCordsAlongTines(Refined_M,slice_value);
    %end

    if plot_or_not == "yes"
        figure(fig1);
        plot(Refined_M(1,:),Refined_M(2,:));hold on;
        grid on;
        % xlabel('X (mm)'); ylabel('Y (mm)'); 
        axs = gca;axs.GridAlpha = 0.3;
        %axs.FontSize = 12;
        % plot(CordsAlongTines(1,1),CordsAlongTines(2,1),'*',CordsAlongTines(1,2),CordsAlongTines(2,2),...
        %     '+',CordsAlongTines(1,3),CordsAlongTines(2,3),'o'); daspect([1 1]);
        %[longest_dimension_extreme_points, diameter, data_one_half, data_other_half] = ...
        %    DiametricalPoints(Refined_M, fig1);
        AreaOfAblationOnSlicePlane = delta_x*delta_y*length(find(v_tine_contribution > 0.7)); % due to diffusion of heat
    end
end