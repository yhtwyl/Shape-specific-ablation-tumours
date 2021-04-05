function [error_negative,DataForErrorNegative] = ErrorNegative(error,data,error_limit)
    count = 0;
    for i = 1:size(error,1)
        if sum(error(i,:) <= error_limit) == 3 % Only those cases passes whose distances along all three tines is less than the target ablation.
            count = count + 1;
            error_negative(count,:) = error(i,:); 
            DataForErrorNegative(count,:) = data(i,:);% Choose only those which have negative errors
        end
    end
    if count == 0; error_negative = int8.empty;DataForErrorNegative = double.empty;
end
