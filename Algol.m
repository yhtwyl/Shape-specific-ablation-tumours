function OutputData = Algol(DataOfInterestDistances,TineID,StatesAssigned)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%% SUMMARY %%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    DataSetsFilenames = {'StatesAndDistancesSymmetricCases.txt','StatesAndDistancesUniqueCases.txt','StatesAndDistancesUniqueCasesBros.txt'};
    DataBoundedByUpperAndLowerErrorLimitsForEachSet = int8.empty;
    error_lower_limit = -2.0; % -3.0 Worked except for YZ plane.
    error_upper_limit = 10.0;
    %%%%%%%%%%%%%%%%%%%%%%%%%% TINE 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    idx_begin = 1;% idx_end = 0;
    for idx = 1:3 % Seek the appropriate lengths along the tines in all the three files.
        DataAll = load(DataSetsFilenames{idx});
        data = FilteredDataSet(DataAll,TineID,StatesAssigned); % Filtering means we are reducing the whole data into data of interest by keeping only those options that respect the states set from previus group of tines.
        len = size(data,1); % We may not have data corresponding to all the tines.
        if len > 0 % To avoid cases when you found no data from the database
            for index = 1:len % Now work upon each entry in the DataSetsFilenames
                Len_t1 = data(index,5); % Tine in the question
                Len_t2 = data(index,6); % Tine left to the tine in question
                Len_t4 = data(index,7); % Tine right to the tine in question
                [left right] = TineNeighbours(TineID);
                error(index,:) = [Len_t1 - DataOfInterestDistances(TineID),Len_t2 - DataOfInterestDistances(left) ...
                                  ,Len_t4 - DataOfInterestDistances(right)]; % Difference between the ablation front and the entries of database along the three tines. The size is len X 3 BUT WHAT IF TINE 8 IS IN THE QUERRY????
            end
            [ErrorsBoundedByUpperLimit, DataBoundedByUpperErrorLimit] = ErrorNegative(error,data,error_upper_limit);
            % clear data, error;
            % disp('error negative: ');
            % disp(error_negative);
            if size(ErrorsBoundedByUpperLimit,1) ~= 0 % There can be no case in either one or more DataSets meeting our requirement of all negative errors .
                %% idx_ = idx_ + 1; % idx_ not necessarily equal to idx.
                %% Instead of single choice we can move along with multiple of them. For this we set a limit on minimum of negative error.
                DataBoundedByUpperAndLowerErrorLimits = ChoseAFewAmongstAllNegatives(ErrorsBoundedByUpperLimit,DataBoundedByUpperErrorLimit,error_lower_limit);%% make the function
                %% [value,place] = max(sum(error_negative,2)); %
                if size(DataBoundedByUpperAndLowerErrorLimits,1) > 0
                    idx_end = idx_begin + size(DataBoundedByUpperAndLowerErrorLimits,1) - 1;
                    DataBoundedByUpperAndLowerErrorLimitsForEachSet(idx_begin:idx_end,:) = [DataBoundedByUpperAndLowerErrorLimits(:,4:7), ...
                    idx.*ones(size(DataBoundedByUpperAndLowerErrorLimits,1),1),DataBoundedByUpperAndLowerErrorLimits(:,11:12),...
                    sum(DataBoundedByUpperAndLowerErrorLimits(:,1:3),2)]; % As name suggests.
                    idx_begin = idx_end;
                end
            end
        end
        clear DataAll data error DataBoundedByUpperErrorLimit; % clear the containers for next set data.
    end
    if size(DataBoundedByUpperAndLowerErrorLimitsForEachSet,1)~= 0
        OutputData = sortrows(DataBoundedByUpperAndLowerErrorLimitsForEachSet,8,'descend');
    else
        OutputData = DataBoundedByUpperAndLowerErrorLimitsForEachSet;
    end
end