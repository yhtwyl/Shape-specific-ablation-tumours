function [tri] = rotate_stl(tri,line,theta)
%%%rotates the stl file if necessary along the z-axis and further if required along the x-axis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Author: Sunil Bhandari%%%%%%%%
%%%%Date: Mar 12, 2018 %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if theta ~= 0
        if strcmpi(line,"longitude")
            tri(:,1:3) = tri(:,1:3)*rotz(theta);
            tri(:,4:6) = tri(:,4:6)*rotz(theta);
            tri(:,7:9) = tri(:,7:9)*rotz(theta);
            %rotmat = [cosd(theta), -sind(theta), 0; sind(theta), cosd(theta),0; 0, 0,1];
        elseif strcmpi(line,"latitude")
            tri(:,1:3) = tri(:,1:3)*roty(theta);
            tri(:,4:6) = tri(:,4:6)*roty(theta);
            tri(:,7:9) = tri(:,7:9)*roty(theta);
            % rotmat = [cosd(theta), 0 , sind(theta); 0, 1, 0; -sind(theta), 0, cosd(theta)];
        end
        % tri(:,1:3) = rotmat*tri(:,1:3)';% * rotmat;
        % tri(:,4:6) = tri(:,4:6) * rotmat;
        % tri(:,7:9) = tri(:,7:9) * rotmat;
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