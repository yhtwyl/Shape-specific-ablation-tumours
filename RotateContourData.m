function R_Refined_M = RotateContourData(Refined_M, TineID)
    angle = 360/8;angle = angle*(TineID - 1);
    R = [cosd(angle) sind(angle); -sind(angle) cosd(angle)];
    R_Refined_M = R*Refined_M;
end