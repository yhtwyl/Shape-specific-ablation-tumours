function data = FilteredDataSet(DataAll,TineID,StatesAssigned)
    idx = 0;
    [left, right] = TineNeighbours(TineID);
    for i = 1:length(DataAll)
        if (StatesAssigned(left) ~= 9) && (StatesAssigned(right) ~= 9) && (StatesAssigned(9) ~= 9) && (StatesAssigned(left) == DataAll(i,2)) && (StatesAssigned(right) == DataAll(i,4))&& StatesAssigned(9) == DataAll(i,3) %(TineID ~= 7) && (StatesAssigned(TineID-1) == DataAll(i,4)) && (StatesAssigned(9) == DataAll(i,3))
            idx = idx + 1;
            data(idx,:) = DataAll(i,:);
        elseif (StatesAssigned(left) ~= 9) && (StatesAssigned(right) == 9) && (StatesAssigned(9) ~= 9) && (StatesAssigned(left) == DataAll(i,2)) && (StatesAssigned(9) == DataAll(i,3))
            idx = idx + 1;
            data(idx,:) = DataAll(i,:);
        elseif (StatesAssigned(right) ~= 9) && (StatesAssigned(left) == 9) && (StatesAssigned(9) ~= 9) && (StatesAssigned(right) == DataAll(i,4)) && (StatesAssigned(9) == DataAll(i,3))
            idx = idx + 1;
            data(idx,:) = DataAll(i,:);
        elseif (StatesAssigned(right) == 9) && (StatesAssigned(left) == 9) && (StatesAssigned(9) ~= 9) && (StatesAssigned(9) == DataAll(i,3))
            idx = idx + 1;
            data(idx,:) = DataAll(i,:);
        elseif (StatesAssigned(left) == 9) && (StatesAssigned(right) == 9) && (StatesAssigned(9) == 9)
            idx = size(DataAll,1);
            data = DataAll;
            break;
        end
    end
    if idx == 0
        % disp("Insufficient data");
        data = int8.empty;
    end
end
