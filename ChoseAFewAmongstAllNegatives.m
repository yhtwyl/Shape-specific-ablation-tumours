function data = ChoseAFewAmongstAllNegatives(ErrorsBoundedByUpperLimit,DataBoundedByUpperErrorLimit,error_lower_limit)
    idx = 0;
    w = [1, 0.7, 0.7];
    for i = 1:size(ErrorsBoundedByUpperLimit,1)
      if sum(ErrorsBoundedByUpperLimit(i,:).*w >= error_lower_limit) == 3
        idx = idx + 1;
        data(idx,:) = [ErrorsBoundedByUpperLimit(i,:), DataBoundedByUpperErrorLimit(i,:)];
      end
    end
    if idx == 0
        data = double.empty();
    end
end
