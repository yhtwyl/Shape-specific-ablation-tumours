function  Flag = IsTumourCoveredByAblation(tri_long_lat,PredictedAblation,tolerance)
%Description IsTumourCoveredByAblation(tri_long_lat,PredictedAblation)
%
% Long description
    Flag = 1;
    query = (reshape(tri_long_lat(:,1:9)',3,[]))';
    idx = inShape(alphaShape(PredictedAblation,20),query);
    if sum(~idx) > 0
        Flag = 0;
    else
        PredictedAblationEased = uniquetol(PredictedAblation,0.1,'ByRows',true);
        % figure(figHandle);scatter3(PredictedAblationEased(:,1),PredictedAblationEased(:,2),PredictedAblationEased(:,3),'.');axis image;
        % [row,col] = size(tri_long_lat);
        % Tumour = reshape(tri_long_lat',[3,floor(row*col/3)]);
        % Tumour = uniquetol(Tumour','ByRows',eps);
        for i = 1:length(query)
            diff = query(i,:).*ones(size(PredictedAblationEased)) - PredictedAblationEased;
            dist = sqrt(sum(diff.*diff,2));
            if sum(dist < tolerance) ~= 0
                % disp('Bro margin issue');
                Flag = 0;
                break;
            end
        end
    end
end