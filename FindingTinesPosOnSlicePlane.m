function TinesCords = FindingTinesPosOnSlicePLane(slice_value)
    T1 = load('T1_Profile.txt');
    T2 = load('T2_Profile.txt');
    T9 = load('T9_Profile.txt');
    T8 = load('T8_Profile.txt');
    T = ['T1';'T2';'T9';'T8'];
    tines = zeros(20,3,4);
    tines(:,:,1) = T1;tines(:,:,2) = T2;tines(:,:,3) = T9;tines(:,:,4) = T8;
    TinesCords = zeros(4,3);
    for i = 1:4
        error = eps;idx = 1;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%% A BIG ASSUMPTION IS THAT SLICE PLANE WILL ALWAYS INTERSECT THE TINES %%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        while error > 0
            error = tines(idx,3,i) - slice_value;
            idx = idx + 1;
            if (idx > 20)
                disp('You may have entered slice value which is not intersected by the tines.')
                break;
            end
        end
        disp('Tine ',T(i),' intersects the slice plane at z = ',tines(idx,3,i));
        TinesCords[i,1:2] = tines(idx,1:2,i);   
    end
end