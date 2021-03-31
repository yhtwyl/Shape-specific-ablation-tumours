function [X,Y,Z] = GridSquare(phi,theta,r)
%myFun - latitude,longitude,radius
%
% Syntax: [X,Y,Z] = GridSquare(input)
%
% Long description
    rows = 0:phi:(360-phi);
    cols = 0:theta:(360-phi);
    %X = zeros(length(rows)+2,length(cols) + 2);
    %Y = X; Z = X;
    X = r*(sind([rows(end) rows rows(1)])')*cosd([cols(end) cols cols(1)]);
    Y = r*(sind([rows(end) rows rows(1)])')*sind([cols(end) cols cols(1)]);
    Z = r*cosd([rows(end) rows rows(1)]);
end