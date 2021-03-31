function output = RefineCurveData(input_data)
%myFun - Description
%
% Syntax: RefineCurveData = myFun(input)
%
% Long description
    len = length(input_data);
    input_data = [input_data,input_data(:,1)];
    output = input_data;
    for i = 1:len-1
        sandwitch = LinearInterpolation(input_data(:,i:i+1));
        if ~isempty(sandwitch)
            output = [output(:,1:i),sandwitch,output(:,(i + 1):end)];
        end
    end
    output = output(:,1:end-1);
end