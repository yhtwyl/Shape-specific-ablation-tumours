function Output = OnlyFour(TinesIDsOrder)
    Output(1) = TinesIDsOrder(1);
    idx = 1;
    if mod(Output(1),2) == 0
        for i = 2:length(TinesIDsOrder)
            if ~mod(TinesIDsOrder(i),2)
                idx = idx + 1;
                Output(idx) = TinesIDsOrder(i);
            end
        end
    else
        for i = 2:length(TinesIDsOrder)
            if mod(TinesIDsOrder(i),2)
                idx = idx + 1;
                Output(idx) = TinesIDsOrder(i);
            end
        end
    end
end

