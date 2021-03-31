% TR = stlread('C:\Users\2016m\Documents\SlicerDICOMDatabase\3Dircadb1.16\STL\livertumorsegmentation_livertumor.stl');
% triplot(TR)
model = createpde;
importGeometry(model,'C:\Users\2016m\Documents\SlicerDICOMDatabase\3Dircadb1.16\STL\livertumorsegmentation_livertumor.stl');
pdegplot(model,'EdgeLabels','on');