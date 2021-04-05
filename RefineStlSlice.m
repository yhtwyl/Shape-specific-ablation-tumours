function NiceData = RefineStlSlice(slice_data)
    NiceData = double.empty; index = 0;
    [row, col] = size(slice_data);
    if row > col
        slice_data = slice_data';
    end
    len = size(slice_data,2);
    for i = 1:len
        if isnan(slice_data(1,i)) || isnan(slice_data(2,i)) || isinf(slice_data(1,i)) || isinf(slice_data(2,i))
            %% nothing to do
        else
            index = index + 1;
            NiceData(:,index) = slice_data(:,i);
        end
    end
end