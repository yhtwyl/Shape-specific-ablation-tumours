data = load('StatesAndDistancesSymmetricCases.txt');
Sets = [1 2 3 4 5 7;21 30 37 44 47 50];
for i = 1:length(Sets)
    if i == 1
        init = 1;
        last = Sets(2,i);
    else
        init = Sets(2,i-1) + 1;
        last = Sets(2,i) - Sets(2,i-1); 
    end
    for j = init:Sets(2,i)
        data(j,8) = Sets(1,i);
    %    data(j,9) = ;
    end
    data(init:Sets(2,i),8) = Sets(1,i)*ones(last,1);
    data(init:Sets(2,i),9) = 1:last;
end
% dummy = data(:,2);
% data(:,2) = data(:,4);
% data(:,4) = dummy;
% dummy = data(:,6);
% data(:,6) = data(:,7);
% data(:,7) = dummy;
save('StatesAndDistancesSymmetricCases.txt','data','-ascii');
