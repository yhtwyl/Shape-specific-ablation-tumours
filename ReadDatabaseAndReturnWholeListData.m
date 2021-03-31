function [x,y,z,v] = ReadDatabaseAndReturnWholeListData(Filename,reflection)
base_idx = 3;
data = readmatrix(Filename);
x = data(:,1);
y = data(:,2);
z = data(:,3);
v = data(:,5);%base_idx + 1:end);
if reflection == "yes", y = -y; end
end