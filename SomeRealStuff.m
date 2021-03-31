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
count = 0;error_limit = -0.2;
for i = 1:2:7 % Do the matching for alternate tines and not for the cosequtive tines.
    count = count + 1;idx_ = 0;
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
        [len,~] = size(data); % We may not have data corresponding to all the tines.
        if len > 0 % To avoid cases when you found no data from the database
            for index = 1:len % Now work upon each entry in the DataSetsFilenames  
                LenT1 = data(index,5); % Tine in the question
                LenT2 = data(index,6); % Tine left to the tine in question
                LenT8 = data(index,7); % Tine right to the tine in question
                if i == 1
                    left = 8; % exceptions not following the rule i.e. tine number 'n-1' is to the right of tine 'n'.
                else
                    left = i-1;
                end
                error(index,:) = [LenT1 - DataOfInterestDistances(i),LenT2 - DataOfInterestDistances(i+1) ...
                        ,LenT8 - DataOfInterestDistances(left)]; % Difference between the ablation front and the entries of database along the three tines. The size is len X 3 
            end
            
            [error_negative, DataForErrorNegative] = ErrorNegative(error,data,error_limit);
            clear data;
            % disp('error negative: ');
            % disp(error_negative);
            if size(error_negative,1) ~= 0 % There can be no case in either one or more DataSets meeting our requirement of all negative errors .
                idx_ = idx_ + 1; % idx_ not necessarily equal to idx.
                [value,place] = max(sum(error_negative,2)); % 
                DataForLeastErrorOfEachSet(idx_,:) = [value, DataForErrorNegative(place,1:4), idx, ...
                    DataForErrorNegative(place,8), DataForErrorNegative(place,9)]; % As name suggests.
            end
        end
        clear DataAll error DataForErrorNegative; % clear the containers for next set data.
    end
    if size(DataForLeastErrorOfEachSet,1) ~= 0
      [~,int_idx] = max(DataForLeastErrorOfEachSet(:,1));
      DataForLeastErrorAmongstAll(count,:) = DataForLeastErrorOfEachSet(int_idx,:); % best choice amongst all the data sets.
    
%%%%%%%%%%%% COMPLETING THE THE ARRAY FOR ALL THE 8 TINES %%%%%%%%%%%%%%%%
      if i > 1 && i < 7
        StatesAssigned(i:i+1) = DataForLeastErrorOfEachSet(int_idx,2:3);
      elseif i == 7
        StatesAssigned(i) = DataForLeastErrorOfEachSet(int_idx,2);
      elseif i == 1
        StatesAssigned(i:i+1) = DataForLeastErrorOfEachSet(int_idx,2:3);
        StatesAssigned(8) = DataForLeastErrorOfEachSet(int_idx,5);
        StatesAssigned(9) = DataForLeastErrorOfEachSet(int_idx,4);
      end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%% EXTRACTING CORRESPONDING ABLATION DATA FROM THE DATABASE
      switch DataForLeastErrorAmongstAll(count,6)
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
      SetNo = DataForLeastErrorAmongstAll(count,7);case_no = DataForLeastErrorAmongstAll(count,8);
      
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
    clear DataForLeastErrorOfEachSet;
end
