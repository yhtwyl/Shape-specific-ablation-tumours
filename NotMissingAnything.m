%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% SUMMARY %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DataOfInterest = zeros(2,24);
grid_points = 100;
filename = strcat('/home/linuxlover/Documents/MATLAB/PreviousProblem/OverlappingCases/Validation',...
                  'Cases/FinalFourPresentedInArticle/Case4_INorm_data_central_region_100by100by100.txt');
[DataOfInterest,slice_value] = DataGeneration(filename,grid_points);
DataSetsFilenames = {'StatesAndDistancesSymmetricCases.txt','StatesAndDistancesUniqueCases.txt','StatesAndDistancesUniqueCasesBros.txt'};
DataOfInterestDistances = zeros(1,length(DataOfInterest));
for i = 1:length(DataOfInterest)
    DataOfInterestDistances(i) = norm(DataOfInterest(:,i));
end
StatesAssigned = int8.empty;
count = 0;error_lower_limit = -1.0; error_upper_limit = -0.2;
for i = 1%1:2:7 % Do the matching for alternate tines and not for the cosequtive tines.
    count = count + 1;idx_begin = 1; idx_end = 0;
    for idx = 1:3 % Seek the appropriate lengths along the tines in all the three files.
        DataAll = load(DataSetsFilenames{idx});
        if length(StatesAssigned) ~= 0
            data = FilteredDataSet(DataAll,StatesAssigned,i); % Filtering means we are reducing the whole data into data of interest by keeping only those options that respect the states set from previus group of tines.
                                                              % if size(data,1) == 0
                                                              %   break;
                                                              % end
        else
            data = DataAll; % No such filtering necessary for first tine group.
        end
        len = size(data,1); % We may not have data corresponding to all the tines.
        if len > 0 % To avoid cases when you found no data from the database
            for index = 1:len % Now work upon each entry in the DataSetsFilenames  
                LenT1 = data(index,5); % Tine in the question
                LenT2 = data(index,6); % Tine left to the tine in question
                LenT8 = data(index,7); % Tine right to the tine in question
                if i == 1
                    right = 8; % exceptions not following the rule i.e. tine number 'n-1' is to the right of tine 'n'.
                else
                    right = i-1;
                end
                error(index,:) = [LenT1 - DataOfInterestDistances(i),LenT2 - DataOfInterestDistances(i+1) ...
                                  ,LenT8 - DataOfInterestDistances(right)]; % Difference between the ablation front and the entries of database along the three tines. The size is len X 3 
            end
            [ErrorsBoundedByUpperLimit, DataBoundedByUpperErrorLimit] = ErrorNegative(error,data,error_upper_limit);
            clear data, error;
            % disp('error negative: ');
            % disp(error_negative);
            if size(ErrorsBoundedByUpperLimit,1) ~= 0 % There can be no case in either one or more DataSets meeting our requirement of all negative errors .
                %% idx_ = idx_ + 1; % idx_ not necessarily equal to idx.
                %% Instead of single choice we can move along with multiple of them. For this we set a limit on minimum of negative error.
                DataBoundedByUpperAndLowerErrorLimits = ChoseAFewAmongstAllNegatives(ErrorsBoundedByUpperLimit,DataBoundedByUpperErrorLimit,error_lower_limit);%% make the function
                %% [value,place] = max(sum(error_negative,2)); %
                if size(DataBoundedByUpperAndLowerErrorLimits,1) > 0
                    idx_end = idx_begin + size(DataBoundedByUpperAndLowerErrorLimits,1) - 1;
                    DataBoundedByUpperAndLowerErrorLimitsForEachSet(idx_begin:idx_end,:) = [DataBoundedByUpperAndLowerErrorLimits(:,4:7), idx.*ones(size(DataBoundedByUpperAndLowerErrorLimits,1),1),DataBoundedByUpperAndLowerErrorLimits(:,11:12)]; % As name suggests.
                    idx_begin = idx_end;
                end
            end
        end
        clear DataAll data error DataBoundedByUpperErrorLimit; % clear the containers for next set data.
    end
    
    if size(DataBoundedByUpperAndLowerErrorLimitsForEachSet,1) ~= 0
        % [~,int_idx] = max(DataForLeastErrorOfEachSet(:,1));
        % DataForLeastErrorAmongstAll(count,:) = DataForLeastErrorOfEachSet(int_idx,:); % best choice amongst all the data sets.
        
        %%%%%%%%%%%% COMPLETING THE ARRAY FOR ALL THE 8 TINES %%%%%%%%%%%%%%%%
        % if i > 1 && i < 7
        %     StatesAssigned(i:i+1) = DataBoundedByUpperAndLowerErrorLimitsForEachSet(int_idx,2:3);
        % elseif i == 7
        %     StatesAssigned(i) = DataBoundedByUpperAndLowerErrorLimitsForEachSet(int_idx,2);
        % elseif i == 1
        %     StatesAssigned(i:i+1) = DataBoundedByUpperAndLowerErrorLimitsForEachSet(int_idx,2:3);
        %     StatesAssigned(8) = DataBoundedByUpperAndLowerErrorLimitsForEachSet(int_idx,5);
        %     StatesAssigned(9) = DataBoundedByUpperAndLowerErrorLimitsForEachSet(int_idx,4);
        % end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%%%%% EXTRACTING CORRESPONDING ABLATION DATA FROM THE DATABASE
        for j = 1:size(DataBoundedByUpperAndLowerErrorLimitsForEachSet,1)
            switch DataBoundedByUpperAndLowerErrorLimitsForEachSet(j,5)
              case 1
                DirectoryOfDataFile = '/home/linuxlover/Documents/MATLAB/PreviousProblem/OverlappingCases/HalfModel';
                nature = 1;% 1 = "Symmetric";
                similar = 0;
              case 2
                DirectoryOfDataFile = '/home/linuxlover/Documents/MATLAB/PreviousProblem/OverlappingCases/FullModel';
                nature = 0;% 0 = "Unique";
                similar = 0;
              case 3
                DirectoryOfDataFile = '/home/linuxlover/Documents/MATLAB/PreviousProblem/OverlappingCases/FullModel';
                nature = 0;% 0 = "Unique";
                similar = 1;
            end
            
            SetNo = DataBoundedByUpperAndLowerErrorLimitsForEachSet(j,6);case_no = DataBoundedByUpperAndLowerErrorLimitsForEachSet(j,7);
        
            filename = strcat(DirectoryOfDataFile,'/Set',num2str(SetNo), ...
                              '_Inorm_data_70by70by70_central_region_appended.txt');
            FigHandle = gcf; slice_plane = 'z'; azimuthal_angle = 0;% slice_value = 47; %%%%%%%%%%%%% CORRECT SLICE POSIITON %%%%%%%%%%%%
            [x,y,z,v] = ReadmatrixFromDatabase(filename,similar); % reflection
            grid_points = 70; %%%%%%%%%% FOR DATABASE
            x_mat = reshape(x,[grid_points,grid_points,grid_points]);
            y_mat = reshape(y,[grid_points,grid_points,grid_points]);
            z_mat = reshape(z,[grid_points,grid_points,grid_points]);
            v_mat = reshape(v(:,case_no),[grid_points,grid_points,grid_points]);
            
            if nature
                [x_,y_,z_,v_] = ReflectTheSymmetricData(x_mat,y_mat,z_mat,v_mat);
                [x_mat,y_mat,z_mat,v_mat] = MakeMatrixSquare(x_,y_,z_,v_);
            end
            
            [x_tine_contribution,y_tine_contribution,v_tine_contribution] = ShapesDataForSliceFit...
                (x_mat,y_mat,z_mat,v_mat,slice_plane,slice_value,azimuthal_angle);
            [M, fm] = contour(x_tine_contribution,y_tine_contribution,v_tine_contribution,[1 1]);
            delete(fm);
            Refined_M = SolvingProblemOfPatch(M);
            if i > 1; Refined_M = RotateContourData(Refined_M,i); end %%% i corresponds to tine number.
            plot(Refined_M(1,:),Refined_M(2,:));axis square;
        end
    end
    clear DataBoundedByUpperAndLowerErrorLimitsForEachSet;
end