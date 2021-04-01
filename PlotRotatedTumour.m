function [] = PlotRotatedTumour(input,FigHandle)
%myFun - Description
%
% Syntax: [] = PlotRotatedTumour(input,FigHandle)
%
% Long description
    figure(FigHandle);
    % Convert color code to 1-by-3 RGB array (0~1 each)
    color = [0,0,255]./255;
    for i = 1:3000
        patch(input(i,[1 4 7]),input(i,[2 5 8]),input(i,[3 6 9]),color);
    end
end