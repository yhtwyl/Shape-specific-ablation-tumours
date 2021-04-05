function [AverageDiaCurrentSlice_,CordsAlongTines] = ...
    FakeDoesEveryThing(x_mat,y_mat,z_mat,v_mat,slice_plane,slice_value,azimuthal_angle,delta_x,delta_y,plot_or_not,fig1)
    [x_tine_contribution, y_tine_contribution, v_tine_contribution] = ShapesDataForSliceFit...
        (x_mat,y_mat,z_mat,v_mat,slice_plane,slice_value,azimuthal_angle);
    [M, fm] = contour(x_tine_contribution,y_tine_contribution,v_tine_contribution,[1 1]);
    delete(fm);
    Refined_M = SolvingProblemOfPatch(M);
    bb = minBoundingBox(Refined_M);
    side_12 = norm(bb(:,1) - bb(:,2));
    side_23 = norm(bb(:,2) - bb(:,3));
    AverageDiaCurrentSlice_ = 0.5*(side_12 + side_23);
    % fprintf('Average diameter of current slice = %f \n', AverageDiaCurrentSlice_);
    % disp('Average diameter of current slice = ',AverageDiaCurrentSlice_);
    AreaOfAblationOnSlicePlane = 0;

    CordsAlongTines = FindingCordsAlongAllTines(Refined_M);
    % disp(size(Refined_M));
    % figure(fig1);fig1 = gcf;
    if plot_or_not == "yes"
        %subplot(subplot_size(1),subplot_size(2),subplot_no)
        plot(Refined_M(1,:),Refined_M(2,:));hold on;
        axis([-20 20 -20 20]);
        % axis equal;
        grid on;
        xlabel('X (mm)'); ylabel('Y (mm)'); axs = gca;% axs.GridAlpha = 0.3;
        axs.FontSize = 12;
        % plot(CordsAlongTines(1,1),CordsAlongTines(2,1),'*',CordsAlongTines(1,2),CordsAlongTines(2,2),...
        % '+',CordsAlongTines(1,3),CordsAlongTines(2,3),'o')
    end
end