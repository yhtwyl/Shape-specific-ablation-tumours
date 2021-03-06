% model = createpde(3);
% importGeometry(model,'C:\Users\2016m\Documents\MATLAB\ASME_Upgraded\sample_wedge.stl');
% figure;h = pdegplot(model,'FaceLabels','on');
% rotate(h,[0,0,1],90);
% fv = stlread('sample_wedge.stl');
% P = fv.Points;     %access the vertex data from triangulation              
% C = fv.ConnectivityList;     %access the connectivity data from triangulation
% P(:,3) = P(:,3) + eps;     %add 5 to each vertex's x value
% fv = triangulation(C, P);     %Combine both components back into a triangulation variable
%h = pdegplot(fv);
%patch(fv);%,'FaceColor','r','EdgeColor','none','FaceLighting','gouraud',...
         %'AmbientStrength', 0.15);
% P = fv.Points;     %access the vertex data from triangulation              
% C = fv.ConnectivityList;     %access the connectivity data from triangulation
% P(:,1) = P(:,1) + 50;     %add 5 to each vertex's x value
% fv = triangulation(C, P);     %Combine both components back into a triangulation variable
% 
% patch(fv,'FaceColor','r');%'EdgeColor','none','FaceLighting','gouraud',...
%'AmbientStrength', 0.15);

tic;
[ret, name] = system('hostname');
filename = 'C:\Users\2016m\Documents\MATLAB\ASME_Upgraded\livertumorsegmentation_livertumor.stl';
slice_height = 1;rotation_axis = {'x','y','z'};count = 1;
legends = [2,3;1,3;1,2]; % check it once
theta= linspace(0,2*pi,100); delta_theta = 90; % degree
triangles = read_binary_stl_file(filename);
centroid_z = mean(mean(triangles(:,[3 6 9])));
centroid_y = mean(mean(triangles(:,[2 5 8])));
centroid_x = mean(mean(triangles(:,[1 4 7])));
triangles(:,[3 6 9]) = triangles(:,[3 6 9]) - centroid_z;
triangles(:,[2 5 8]) = triangles(:,[2 5 8]) - centroid_y;
triangles(:,[1 4 7]) = triangles(:,[1 4 7]) - centroid_x;
figure;hold on;
for i = 1:3000
    patch(triangles(i,[1 4 7]),triangles(i,[2 5 8]),triangles(i,[3 6 9]),'r');
end
toc
% points = reshape(triangles(:,1:9)',[3,9000]);
% points = uniquetol(points','ByRows',eps);
% scatter3(points(:,1),points(:,2),points(:,3));axis image;
% tol = eps;
% size(triangles)
% size(uniquetol(triangles(:,1:9),'ByRows',1e-5))