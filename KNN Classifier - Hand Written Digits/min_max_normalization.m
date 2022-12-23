function c = min_max_normalization(Data)
%%Min-Max normalization

%Traverse through dimension
for j = 1:3
    %Find max and min for each sample and store in an array
    for i = 1:length(Data)
        max_data(i) = max(Data{i}(:,j));
        min_data(i) = min(Data{i}(:,j));
    end

    %Find max and min over entire dimension
    max_p = max(max_data);
    min_p = min(min_data);
    
    %Get normalized time series for specific dimension
    for i = 1:length(Data)
        c{i}(:,j) = (Data{i}(:,j) - min_p)./(max_p-min_p);
    end
end


