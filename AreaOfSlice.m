function area = AreaOfSlice(input)
%myFun - Description
%
% Syntax: area = AreaOfSlice(input)
%
% Long description
    input = [input; input(1,:)];sum = 0;
    for i = 1:(length(input)-1)
        sum = sum + input(i,1)*input(i+1,2) - input(i+1,1)*input(i,2);
    end
    area = 0.5*abs(sum);
end