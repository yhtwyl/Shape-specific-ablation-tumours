function NiceData = RefineStlSliceFlipV3(slice_data,show_slice_plane_height)%,rotation_axis,theta)
    NiceData = double.empty; index = 0;
    [row, col] = size(slice_data);
    if col > row
        slice_data = slice_data';
    end
    len = size(slice_data,1);
    for i = 1:len
        if isnan(slice_data(i,1)) || isnan(slice_data(i,2)) || isinf(slice_data(i,1)) || isinf(slice_data(i,2))
            %% What about z coordinates
            %% nothing to do
        else
            index = index + 1;
            NiceData(index,:) = slice_data(i,:);
        end
    end

    % if strcmpi(show_slice_plane_height,"yes")
    %     disp(num2str(slice_data(10,3))); % There is nothing particular about index 10. It could be any.
    % end
%{
     if strcmpi(rotation_axis,'Z') %% NOT ACCURATE
        % rotmat = [cosd(theta), 0 , sind(theta); 0,1,0; -sind(theta), 0, cosd(theta)]; %% EDIT BEFORE USE
        % NiceData = NiceData*rotmat;
        NiceData = NiceData(:,2:3);
    elseif strcmpi(rotation_axis,'Y') %% NOT ACCURATE
        % rotmat = [1, 0, 0; 0, cosd(theta),-sind(theta); 0, sind(theta),cosd(theta)]; %% EDIT BEFORE USE
        % NiceData = NiceData*rotmat;
        NiceData = NiceData(:,[1,3]);
    elseif strcmpi(rotation_axis,'X')
        % rotmat = [1,0,0;0,1,0;0,0,1]
        %rotmat = [1, 0, 0; 0, cosd(theta),-sind(theta); 0, sind(theta),cosd(theta)];
        %NiceData = NiceData*rotmat;

        % NiceData = NiceData(:,2:3);
        NiceData = NiceData(:,1:2);
        disp('I am in');
    end 
%}

    % NiceData = NiceData(:,1:2)';
end