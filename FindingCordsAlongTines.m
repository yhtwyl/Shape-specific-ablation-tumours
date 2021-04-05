function CordsAlongTines = FindingCordsAlongTines(Refined_M,slice_value)
    %{
        Finding coordinates only along the four tines.
    %}
    
    CordsAlongTines = zeros(2,3);
    del_x = 2.0;
    %TinesCords = FindingTinesPosOnSlicePlane(slice_value);
    slope = [0, tand(-45), tand(45)];DummyMatrix = zeros(size(Refined_M));
    for i = 1:3
         error = eps;
         x = 0;
         SecondNormOld = sqrt(Refined_M(1,:).*Refined_M(1,:) + Refined_M(2,:).*Refined_M(2,:));
         %while error > 0
         x = x + del_x;
         y = slope(i).*x;
         DummyMatrix(1,:) = x; DummyMatrix(2,:) = y;
         DiffMatrix = Refined_M - DummyMatrix;
         SecondNormNew = sqrt(DiffMatrix(1,:).*DiffMatrix(1,:) + DiffMatrix(2,:).*DiffMatrix(2,:));
         DiffNorms = SecondNormOld - SecondNormNew;
         [~,idx] = max(DiffNorms); %%% LETS ASSUME WE GET THE RIGHT COORDINATES IN A SINGLE STEP
         CordsAlongTines(:,i) = Refined_M(:,idx);
    end
end