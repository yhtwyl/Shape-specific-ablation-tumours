filename = 'C:\Users\2016m\Documents\MATLAB\FromCT_images\RefineSTL\livertumorsegmentation_livertumor.stl';
slice_height = 1;slice_planes = ['x','y','z'];
legends = [2,3;1,3;1,2];theta= linspace(0,2*pi,100);theta_rot = [90,-90,0];
 for i = 1:3
    [Slices] = StlSliceAndPlot(filename,slice_planes(i),theta_rot(i),slice_height);
    figure; fig1 = gcf;
    BottomSliceValue = 4; TopSliceValue = size(Slices,2) - 4;
    for slice_value = BottomSliceValue:TopSliceValue
        NiceData = RefineStlSlice(Slices{slice_value});
        [AverageDiaCurrentSlice(1,slice_value - BottomSliceValue + 1),~,~,~,~,~,~,~] = DoesEveryThingCtTumourSTL(NiceData,'no',fig1);
        clear NiceData;
    end
    [value, index] = max(AverageDiaCurrentSlice);
    slice_value = BottomSliceValue + index - 1;
    NiceData = RefineStlSlice(Slices{slice_value});
    %%%%%%%%%%%%%% RECENTRE THE CONTOUR %%%%%%%%%%%%%
    % mean_xy = mean(NiceData,2); NiceData(1,:) = NiceData(1,:) - mean_xy(1); NiceData(2,:) = NiceData(2,:) - mean_xy(2);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [~,l1(1),l1(2),w1(1),w1(2),intersection_coords_length, intersection_coords_width,bb] = DoesEveryThingCtTumourSTL(NiceData,'yes',fig1);
    plot([bb(1,:) bb(1,1)],[bb(2,:) bb(2,1)]);axis image;hold off;
    axs = gca; axs.FontSize = 10;
    set(get(gca, 'XLabel'), 'String', strcat(upper(slice_planes(legends(i,1))),'(mm)'));
    set(get(gca, 'YLabel'), 'String', strcat(upper(slice_planes(legends(i,2))),'(mm)'));
    sides(:,i) = [norm(bb(:,1) - bb(:,2));norm(bb(:,2) - bb(:,3))];
    if sides(1,i) > sides(2,:)
        D1 = sides(1,i);D2 = sides(2,i);
    else
        D1 = sides(2,i);D2 = sides(1,i);
    end
    set(get(gca, 'Title'), 'String', 'Slice');
    subtitle(strcat("D1 = ", num2str(D1),' | ',"D2 = ", num2str(D2)));
    %%%% clear AverageDiaCurrentSlice

%{
     StatesOfAllNineTines = OverlappingFromDatabase(NiceData,gcf);
    if size(StatesOfAllNineTines,1) ~= 0
        plot(0.5*(D1 + 10).*cos(theta),0.5*(D1 + 10).*sin(theta),'r');
    end
    disp(['States of all tines = ', num2str(StatesOfAllNineTines)]); 
%}

end 
