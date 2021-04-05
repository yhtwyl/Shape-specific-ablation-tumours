function output = rotz(angle)
%myFun - Description
%
% Syntax: output = rotz(input,angle)
%
% Long description
    output = [cosd(angle), sind(angle), 0; -sind(angle), cosd(angle), 0; 0, 0, 1];
end