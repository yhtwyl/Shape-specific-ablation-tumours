function StatesAssigned = AssignTheStates(TinesIDs,TineID,StatesSet)
    StatesAssigned = 9.*ones(1,9);
    Current = find(TinesIDs == TineID);
    for i = 1:(Current-1)
        TineID_ = TinesIDs(i);
        [left, right] = TineNeighbours(TineID_);
        StatesAssigned(TineID_) = StatesSet(4*(i-1) + 1);StatesAssigned(9) = StatesSet(4*(i-1) + 3);
        StatesAssigned(left) = StatesSet(4*(i-1) + 2);StatesAssigned(right) = StatesSet(4*(i-1) + 4);
    end
end