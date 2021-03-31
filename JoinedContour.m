function area = JoinedContour(EachTineContribution,fig1)
    %% figure(fig1);
    SignificantTines = size(EachTineContribution,2);
    for index = 1:SignificantTines
        EachTineContribution{index} = RefineCurveData(EachTineContribution{index});
    end
    max_y = 16;min_y = -16;count = 0; n = 100;% no of lines
    height = linspace(min_y,max_y,n);
    for i = 1:n
        GlobalLeftCoord = []; GlobalRightCoord = []; count_tines = 0;
        for j = 1:SignificantTines
            RefineCurveData(EachTineContribution{j}); %EXPERIMENTAL
            line = ones(1,length(EachTineContribution{j}))*height(i);
            [value, indices] = sort(abs(EachTineContribution{j}(2,:) - line));
            SecondPointSlope = zeros(1,10);
            if value(1) < 0.2 %%% CRUCIAL
                LeftCoordIndex = indices(1);% RightCoordIndex = indices(2);
                for k = 1:10 %% I think it should find any bugger lurking out there.
                    SecondPointSlope(k) = abs((EachTineContribution{j}(2,indices(k+1)) - EachTineContribution{j}(2,indices(1)))./...
                        (EachTineContribution{j}(1,indices(k+1)) - EachTineContribution{j}(1,indices(1))));
                    %% disp('Some use');
                end
                [~,SecondPointIndices] = sort(SecondPointSlope);
                RightCoordIndex = indices(SecondPointIndices(1) + 1);
                LeftCoordX = EachTineContribution{j}(1,LeftCoordIndex);
                RightCoordX = EachTineContribution{j}(1,RightCoordIndex);
                if LeftCoordX > RightCoordX %% Too loose
                    temp = RightCoordIndex;
                    RightCoordIndex = LeftCoordIndex;
                    LeftCoordIndex = temp;
                end
                count_tines = count_tines + 1;
                GlobalLeftCoord(count_tines,:) = EachTineContribution{j}(:,LeftCoordIndex);
                GlobalRightCoord(count_tines,:) = EachTineContribution{j}(:,RightCoordIndex);
            else
                % disp('Line is far from the contribution contour');
            end
        end
        if ~isempty(GlobalLeftCoord)
            count = count + 1;
            [~,indices_left] = sort(GlobalLeftCoord(:,1));
            [~,indices_right] = sort(GlobalRightCoord(:,1));
            ContourLeft(count,:) = GlobalLeftCoord(indices_left(1),:);
            ContourRight(count,:) = GlobalRightCoord(indices_right(end),:);
        end
    end
    o1 = norm(ContourLeft(end,:) - ContourRight(1,:));
    o2 = norm(ContourLeft(end,:) - ContourRight(end,:));
    if  o1 <= o2
        UnionData = [ContourLeft; ContourRight];
    else 
        UnionData = [ContourLeft; flip(ContourRight,1)];
    end
    area = AreaOfSlice(UnionData);
    %% plot(UnionData(:,1),UnionData(:,2),'--m');axis image;
end