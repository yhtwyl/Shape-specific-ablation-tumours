function SliceFitFunc(filename,nature,case_no,similar,TineID,FigHandle,slice_plane,slice_pos)
%UNTITLED2 Summary of this function goes here
% THIS FUNCTION WILL ALSO GIVE MIDDLE LINE OF REFLECTION
%   Detailed explanation goes here
%    clf(FigHandle);
%    clear data;
% xslice = [];yslice = [];% zslice = 50;
data = readmatrix(filename); grid_points = 70;
%% Symmetric case one half
if nature == "Symmetric"
    y_shift = max(data(:,2));% Imported data with regular grid option was not alligned 0 by 0 with the x-axis.
    % y = reshape(data(:,2) - y_shift,[grid_points grid_points grid_points]);
    [x_mat, y_mat, v_mat] = ShapesDataForSliceFitFunc(data,case_no,y_shift,grid_points,slice_plane,slice_pos);
    figure(FigHandle);
    [M, fh] = contour(x_mat,y_mat,v_mat,[1 1]);
    delete(fh);
    Refined_M = SolvingProblemOfPatch(M);
    f_fh = fill(Refined_M(1,:),Refined_M(2,:),'red');
    %fv_fh = patch(isosurface(x,y,z,v,1));axis image;
    %set(fv_fh,'Edgecolor',color{TineID});
    %fv_fh.EdgeColor = 'none'; camlight; lighting gouraud;
    figure(FigHandle);
    [M, sh] = contour(x_mat,-y_mat,v_mat,[1 1]); % conundrum due to reshaping
    delete(sh);
    Refined_M = SolvingProblemOfPatch(M);
    f_sh = fill(Refined_M(1,:),Refined_M(2,:),'red');
    %set(fv_sh,'Edgecolor',color{TineID});
    %fv_sh = patch(isosurface(x,-y,z,v,1));axis image;
    %fv_sh.EdgeColor = 'none'; camlight; lighting gouraud;
    %% rotate the data for correct tine location
    if slice_plane == "z"
        direction = [0 0 1];
    elseif slice_plane == "y"
        direction = [0 1 0];
    end
    origin = [0 0 0]; % conundrum due to changing the axes
    angle = 360/8;angle = angle*(TineID - 1);% + angle*0.5;
    rotate(f_fh,direction,-angle,origin);
    rotate(f_sh,direction,-angle,origin);
    %alpha(fv_fh,0.5);alpha(fv_sh,0.5);
else
    %% reflect the data if necessary
    y_shift = 0;
    if similar == "Yes"
        data(:,2) = -data(:,2);
    end
    [x_mat, y_mat, v_mat] = ShapesDataForSliceFit(data,case_no,y_shift,grid_points,slice_plane,slice_pos);
    %%%%%%%%%%%%% PLOT THE FULL ISO-SURFACE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure(FigHandle);
    [M, fm] = contour(x_mat,y_mat,v_mat,[1 1]);
    delete(fm);
    Refined_M = SolvingProblemOfPatch(M);
    f_fm = fill(Refined_M(1,:),Refined_M(2,:),'red');
    %set(fv_f,'Edgecolor',color{TineID});
    %fv_f.EdgeColor = 'none'; camlight; lighting gouraud;
    %% rotate the data for correct tine location
    if slice_plane == "z"
        direction = [0 0 1];
    elseif slice_plane == "y"
        direction = [0 0 0];%[0 1 0];
    end
    origin = [0 0 0];
    angle = 360/8;angle = angle*(TineID - 1);%  + angle*0.5;
    rotate(f_fm,direction,-angle,origin);
    % alpha(fv_f,0.5)
end
disp(strcat('Plotted ablation contour for Tine ID ', num2str(TineID)));
end