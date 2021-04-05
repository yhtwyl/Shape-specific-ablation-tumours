function [axis] = RotateTheAxis(axis,line,theta)
    %%%rotates the stl file if necessary along the z-axis and further if required along the x-axis
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%Author: Sunil Bhandari%%%%%%%%
    %%%%Date: Mar 12, 2018 %%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if theta ~= 0
            if strcmpi(line,"longitude")
                rotmat = [cosd(theta), -sind(theta), 0; sind(theta), cosd(theta),0; 0, 0,1];
            elseif strcmpi(line,"latitude")
                rotmat = [cosd(theta), 0 , sind(theta); 0, 1, 0; -sind(theta), 0, cosd(theta)];
            end
            axis = axis*rotmat;
        end
    
        % elseif strcmpi(rotation_axis,'Y')
        %     % rotmat = [1, 0, 0; 0, cosd(theta),-sind(theta); 0, sind(theta),cosd(theta)];
        %     rotmat = [cosd(theta), 0 , sind(theta); 0,1,0; -sind(theta) 0, cosd(theta)];
        % elseif strcmpi(rotation_axis,'Z') %% EDIT  BEFORE USE
        %     rotmat = [1,0,0;0,1,0;0,0,1];
        %     % rotmat = [cosd(theta), -sind(theta), 0; sind(theta), cosd(theta),0; 0, 0,1];
        % else
        %     disp('axis should be x, y or z');
        % end
    end