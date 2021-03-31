function NiceData = RefineStlSliceFlip(slice_data,k,theta)
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
    if k == 1
        rotmat = [cosd(theta), 0 , sind(theta); 0,1,0; -sind(theta), 0, cosd(theta)];
        NiceData = NiceData*rotmat;
        NiceData = NiceData(:,2:3);
    elseif k == 2
        rotmat = [1, 0, 0; 0, cosd(theta),-sind(theta); 0, sind(theta),cosd(theta)];
        NiceData = NiceData*rotmat;
        NiceData = NiceData(:,[1,3]);
    else
        % rotmat = [1,0,0;0,1,0;0,0,1]
        NiceData = NiceData(:,1:2);
    end
    NiceData = NiceData';
end