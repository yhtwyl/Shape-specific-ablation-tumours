function FilledData = LinearInterpolation(InputPoints)
%myFun - Description
%
% Syntax: FilledData = LinearInterpolation(input)
%
% Long description
FilledData = [];
Destination = InputPoints(:,2);
PreviousFilled = InputPoints(:,1); %% far away from the points on the curve
del_x = InputPoints(1,2) - InputPoints(1,1);
del_y = InputPoints(2,2) - InputPoints(2,1);
slope = del_y/del_x; count = 0;
while norm(PreviousFilled - Destination) > 0.2 %% FOR CONVERGING WITH THE END POINT.
    del_x = Destination(1) - PreviousFilled(1);
    while norm(PreviousFilled - Destination) > 0.2 %% FOR REFINING IN BETWEEN THE POINTS.
        del_x = 0.5*del_x;
        del_y = del_x*slope;
        Destination = PreviousFilled + [del_x; del_y];
    end
    count = count + 1;
    PreviousFilled = Destination;
    Destination = InputPoints(:,2);
    FilledData(:,count) = PreviousFilled;
    if count > 200
        disp('Inner refinement for inerpolation failed');
        break;
    end
end
end