model = createpde(3);
importGeometry(model,'C:\Users\2016m\Documents\MATLAB\ASME_Upgraded\sample_wedge.stl');
figure;pdegplot(model,'FaceLabels','on');