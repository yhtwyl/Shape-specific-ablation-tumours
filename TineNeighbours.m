function [left, right] = TineNeighbours(TineID)
    if TineID ~= 1 && TineID ~= 8
        left = TineID + 1;
        right = TineID - 1;
    elseif TineID == 1
        left = TineID + 1;
        right = 8;
    elseif TineID == 8
        left = 1;
        right = TineID - 1;
    end
end