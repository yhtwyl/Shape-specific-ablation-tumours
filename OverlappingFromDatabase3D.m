 %%%%%%%%%%%%%%%%%%% OVERLAP THE ABLATIONS FROM THE DATABASE %%%%%%%%%%%%%%%%%%%
function [StatesOfAllNineTines, area, VerticalAblationLimits, WrapedSurfaceVertices] = OverlappingFromDatabase3D(Refined_M,userProfile,~)
    VerticalAblationLimits = []; WrapedSurfaceVertices = [];%IsoSurfVerticesPostRotation = []; IsoSurfVerticesPostRotation_Prev = [];
    StatesOfAllNineTines = int8.empty; EachTineContribution = {};area = [];
    DataOfInterest = FindingCordsAlongAllTines(Refined_M);
    DataOfInterestDistances = zeros(1,length(DataOfInterest));
    for i = 1:length(DataOfInterest)
        DataOfInterestDistances(i) = norm(DataOfInterest(:,i));
    end
    DataOfInterestDistances = DataOfInterestDistances + 5;% Add the margin to tumour boundary
    [~, TinesIDsOrder] = RankDistances(DataOfInterestDistances);
    StatesAssigned = 9.*ones(1,9);
    DetailedMatrixLevel1 = zeros(100,16);
    DetailedMatrixLevel2 = zeros(150,24);
    DetailedMatrixLevel3 = zeros(200,32);
    %% count = 0;error_lower_limit = -1.0; error_upper_limit = -0.2;
    TinesIDs = OnlyFour(TinesIDsOrder);
    TineID = TinesIDs(1);
    %%%%%%%%%%%%%%%%%%%%%%%%%% TINE 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Do the matching for alternate tines and not for the consequtive tines.
    PossibleCasesTine1 = Algol(DataOfInterestDistances,TineID,StatesAssigned);
    %%%%%%%%%%%%%%%%%%%%%%%% TINE 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%
    TineID = TinesIDs(2); idx_begin = 1;
    for i = 1:size(PossibleCasesTine1,1)
        StatesAssigned = AssignTheStates(TinesIDs,TineID,PossibleCasesTine1(i,1:4));
        PossibleCasesTine2 = Algol(DataOfInterestDistances,TineID,StatesAssigned);
        if size(PossibleCasesTine2,1) ~= 0
            n = size(PossibleCasesTine2,1);
            idx_end = idx_begin + n - 1;
            for j = 1:n
                DummyMat(j,:) = PossibleCasesTine1(i,:);
            end
            DetailedMatrixLevel1(idx_begin:idx_end,1:16) = [DummyMat PossibleCasesTine2];
            idx_begin = idx_end + 1;
        end
        clear PossibleCasesTine2 DummyMat
    end

    TineID = TinesIDs(3); idx_begin = 1;
    for i = 1:size(DetailedMatrixLevel1,1)
        StatesAssigned = AssignTheStates(TinesIDs,TineID,[DetailedMatrixLevel1(i,1:4), DetailedMatrixLevel1(i,9:12)]);
        %%    StatesAssigned = [DetailedMatrix(i,4),DetailedMatrix(i,1:2),DetailedMatrix(i,9:10),0,0,0,DetailedMatrix(i,3)];
        PossibleCasesTine3 = Algol(DataOfInterestDistances,TineID,StatesAssigned);
        if size(PossibleCasesTine3,1) ~= 0
            n = size(PossibleCasesTine3,1);
            idx_end = idx_begin + n - 1;
            for j = 1:n
                DummyMat(j,:) = DetailedMatrixLevel1(i,:);
            end
            DetailedMatrixLevel2(idx_begin:idx_end,1:24) = [DummyMat PossibleCasesTine3];
            idx_begin = idx_end + 1;
        end
        clear PossibleCasesTine3 DummyMat
    end

    TineID = TinesIDs(4); idx_begin = 1;
    for i = 1:size(DetailedMatrixLevel2,1)
        StatesAssigned = AssignTheStates(TinesIDs,TineID,[DetailedMatrixLevel2(i,1:4),DetailedMatrixLevel2(i,9:12),DetailedMatrixLevel2(i,17:20)]);
        %%    StatesAssigned = [DetailedMatrix(i,4),DetailedMatrix(i,1:2),DetailedMatrix(i,9:10),0,0,0,DetailedMatrix(i,3)];
        PossibleCasesTine4 = Algol(DataOfInterestDistances,TineID,StatesAssigned);
        if size(PossibleCasesTine4,1) ~= 0
            n = size(PossibleCasesTine4,1);
            idx_end = idx_begin + n - 1;
            for j = 1:n
                DummyMat(j,:) = DetailedMatrixLevel2(i,:);
            end
            DetailedMatrixLevel3(idx_begin:idx_end,1:32) = [DummyMat PossibleCasesTine4];
            idx_begin = idx_end + 1;
        end
        clear PossibleCasesTine4 DummyMat
    end
    ImpDataRow = min(find(DetailedMatrixLevel3(:,5) == 0)) - 1; %% Remove zeros in pre allocated Matrix.
    DetailedMatrixLevel3_unsorted = zeros(ImpDataRow,size(DetailedMatrixLevel3,2) + 1);
    DetailedMatrixLevel3_unsorted(:,1:end-1) = DetailedMatrixLevel3(1:ImpDataRow,:);
    DetailedMatrixLevel3_unsorted(:,end) = sum([DetailedMatrixLevel3(1:ImpDataRow,8),DetailedMatrixLevel3(1:ImpDataRow,16),DetailedMatrixLevel3(1:ImpDataRow,24),DetailedMatrixLevel3(1:ImpDataRow,32)],2);
    DetailedMatrixLevel3_sorted = sortrows(DetailedMatrixLevel3_unsorted,size(DetailedMatrixLevel3_unsorted,2)); % according to last column enteries
    clear DetailedMatrixLevel3_unsorted DetailedMatrix DetailedMatrixLevel1 DetailedMatrixLevel2 DetailedMatrixLevel3 TineID
    hold on;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if size(DetailedMatrixLevel3_sorted,1) ~= 0
        CountIsoSurfs = 0;
        ApproximatedStates = DetailedMatrixLevel3_sorted(end,1:end-1);
        v_new = zeros(70,70,70); % better give it a variable for user input or calculate it using the matrix size
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        StatesOfAllNineTines = zeros(1,9);
        for i = 1:length(TinesIDs)
            [left, right] = TineNeighbours(TinesIDs(i));
            StatesOfAllNineTines(TinesIDs(i)) = ApproximatedStates(8*(i-1) + 1);
            StatesOfAllNineTines(left) = ApproximatedStates(8*(i-1) + 2);
            StatesOfAllNineTines(right) = ApproximatedStates(8*(i-1) + 4);
            StatesOfAllNineTines(9) = ApproximatedStates(8*(i-1) + 3);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%% EXTRACTING CORRESPONDING ABLATION DATA FROM THE DATABASE
        VerticalAblationLimits = [0,0];
        for j = 1:fix(length(ApproximatedStates)/8)
            TineID = TinesIDs(j);CountIsoSurfs = CountIsoSurfs + 1;
            switch ApproximatedStates(8*(j-1) + 5)
            case 1
                DirectoryOfDataFile = strcat(userProfile,'\Documents\MATLAB\Overlapping\HalfModel');
                nature = 1;% 1 = "Symmetric";
                similar = 0;
            case 2
                DirectoryOfDataFile = strcat(userProfile,'\Documents\MATLAB\Overlapping\FullModel');
                nature = 0;% 0 = "Unique";
                similar = 0;
            case 3
                DirectoryOfDataFile = strcat(userProfile,'\Documents\MATLAB\Overlapping\FullModel');
                nature = 0;% 0 = "Unique";
                similar = 1;
            end
            
            SetNo = ApproximatedStates(8*(j-1) + 6);case_no = ApproximatedStates(8*(j-1) + 7);
            
            filename = strcat(DirectoryOfDataFile,'\Set',num2str(SetNo), ...
                            '_Inorm_data_70by70by70_central_region_appended.txt');
            %% FigHandle = fig1; 
            azimuthal_angle = 0; slice_value = 0; % 47 is for unmoved data !!! CORRECT SLICE POSIITON %%%%%%%%%%%%
            [x,y,z,v] = ReadmatrixFromDatabase(filename,similar); % reflection
            grid_points = 70; %%%%%%%%%% FOR DATABASE
            x_mat = reshape(x,[grid_points,grid_points,grid_points]);
            if nature
                y_shift = max(y);
                y_mat = reshape(y-y_shift,[grid_points,grid_points,grid_points]);
            else
                y_mat = reshape(y,[grid_points,grid_points,grid_points]);
            end
            z_mat = reshape(z,[grid_points,grid_points,grid_points]);
            v_mat = reshape(v(:,case_no),[grid_points,grid_points,grid_points]);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SHIFT THE DATA TO ORIGIN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            z_mean = 47;z_mat = z_mat - z_mean; %% FROM THE SIMULATED DATABASE. THE SKIRT OF TROCAR AND MAX SPREAD OF ABLATION IS IN THIS PLANE.
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if nature
                [x_,y_,z_,v_] = ReflectTheSymmetricData(x_mat,y_mat,z_mat,v_mat);
                [x_mat,y_mat,z_mat,v_mat] = MakeMatrixSquare(x_,y_,z_,v_);
            end
            % clear Refined_M M

            slice_plane = "z"; % THE TROCAR IS ASSUMED TO REMAIN PERPENDICULAR TO THE QUERRY PLANES
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if VerticalAblationLimits(1) > min(z_mat(1,1,:)); VerticalAblationLimits(1) = min(z_mat(1,1,:)); end%%
            if VerticalAblationLimits(2) < max(z_mat(1,1,:)); VerticalAblationLimits(2) = max(z_mat(1,1,:)); end%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % [x_tine_contribution, y_tine_contribution, v_tine_contribution] = ShapesDataForSliceFitReadMatrix...
            %     (x_mat,y_mat,z_mat,v_mat,slice_plane,slice_value,azimuthal_angle);
            % [M, fm] = contour(x_tine_contribution,y_tine_contribution,v_tine_contribution,[1 1]);
            % delete(fm);
            % Refined_M = SolvingProblemOfPatch(M);
            % disp(size(Refined_M));
            % if TineID > 1; Refined_M = RotateContourData(Refined_M,TineID); end %%% i corresponds to tine number.
            % plot(Refined_M(1,:),Refined_M(2,:));axis square;
            % EachTineContribution{j} = Refined_M;

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%   PLOT THE 3D ABLATIONS %%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%% FOR INDIVIDUAL TINE CONTRIBUTION %%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            IsoSurf = isosurface(x_mat,y_mat,z_mat,v_mat,1);
            % fv_f = patch(IsoSurf);axis image;
             % fv_f.FaceColor = 'red';% blue
            % fv_f.EdgeColor = 'none'; hold on;% camlight; lighting gouraud;
            % alpha(fv_f,0.5);
            % direction = [0 0 1];%TineID = ;
            % origin = [0 0 60]; % conundrum due to changing the axes %% CHECK OUT THIS ORIGIN....
            angle = 360/8;angle = angle*(TineID - 1);% + angle*0.5;
            % rotate(fv_f,direction,-angle,origin);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%% SUPERIMPOSE ABLATION SURFACES CORRESPONDING TO EACH TINE %%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            IsoSurfVerticesPostRotation = (rotz(-angle)*(IsoSurf.vertices'))';

            if CountIsoSurfs ~=1
                WrapedSurfaceVertices = WrapTheIsoSurfaces(IsoSurfVerticesPostRotation,WrapedSurfaceVertices);
            else
                WrapedSurfaceVertices = IsoSurfVerticesPostRotation;
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
        % shp = alphaShape(WrapedSurfaceVertices,20);
        % plot(shp);axis image;
        % WrapTheIsoSurfaces(IsoSurfVerticesPostRotation);
        % area = JoinedContour(EachTineContribution,fig1);
        % IsoSurfVerticesPostRotation = uniquetol(IsoSurfVerticesPostRotation','ByRows',1e-5);
        % shp = alphaShape(IsoSurfVerticesPostRotation,0.5);
        % plot(shp);axis image;
        % figure(fig1);plot(Refined_M(1,:),Refined_M(2,:),'r');axis image;
    end
end