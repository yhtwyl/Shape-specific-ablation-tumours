function [x,y,z,v] = ReadDataFromFile(filename,grid_points)
    data_ = load(filename);
    [row,col]=size(data_);
    if row < col
        data = data_.';
    else
        data = data_;
    end
    x = reshape(data(:,1),[grid_points grid_points grid_points]);
    y = reshape(data(:,2),[grid_points grid_points grid_points]);
    z = reshape(data(:,3),[grid_points grid_points grid_points]);
    v = reshape(data(:,4),[grid_points grid_points grid_points]);
    for j = 1:grid_points
        x(:,:,j) = x(:,:,j).';
        y(:,:,j) = y(:,:,j).';
        z(:,:,j) = z(:,:,j).';
        v(:,:,j) = v(:,:,j).';
    end
end