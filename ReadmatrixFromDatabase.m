function [x,y,z,v] = ReadmatrixFromDatabase(Filename,reflection)
base_idx = 3;
data = readmatrix(Filename);
x = data(:,1);
y = data(:,2);
z = data(:,3);
v = data(:,(base_idx + 1):end);
if reflection
    y = -1*y; 
end
end