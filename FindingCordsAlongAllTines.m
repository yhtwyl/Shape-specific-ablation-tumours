function CordsAlongTines = FindingCordsAlongAllTines(Refined_M)
    %{
        Finding coordinates along all the eight tines.
    %}
    CordsAlongTines = zeros(2,8);
    del_x = 2.0;del_y = 2.0; %% What if there is no boundary along the +ve and -ve y axis.
    %TinesCords = FindingTinesPosOnSlicePlane(slice_value);
    slope = [0, tand(-45), tand(-90), tand(-135), tand(-180), tand(-225), tand(-270), tand(-315)];
    increment_x = [del_x, del_x, 0, -del_x, -del_x, -del_x, 0, del_x];
    DummyMatrix = zeros(size(Refined_M));
    for i = 1:8
         error = eps;
         x = 0;
         SecondNormOld = sqrt(Refined_M(1,:).*Refined_M(1,:) + Refined_M(2,:).*Refined_M(2,:));
         %while error > 0
         x = x + increment_x(i);
         if slope(i) < abs(100000)
            y = slope(i)*x;
         else
            y = sign(slope(i))*del_y;
         end
         DummyMatrix(1,:) = x; DummyMatrix(2,:) = y;
         DiffMatrix = Refined_M - DummyMatrix;
         SecondNormNew = sqrt(DiffMatrix(1,:).*DiffMatrix(1,:) + DiffMatrix(2,:).*DiffMatrix(2,:));
         DiffNorms = SecondNormOld - SecondNormNew;
         [~,idx] = max(DiffNorms); %%% LETS ASSUME WE GET THE RIGHT COORDINATES IN A SINGLE STEP
         CordsAlongTines(:,i) = Refined_M(:,idx);
    end
end