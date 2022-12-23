function C = knn(trainclass, traindata, testData, k)
%% knn returns the classes C for multiple testData

%Class vector gets appended with each classification
C = [];

%Distance between each sample calculated using DTW
for n = 1:length(testData)
    for i=1:length(traindata)
        dtwSum = 0;

        %Traverse over all 3 dimensions
        for d = 1:3
            dtwMatrix = DTW(testData{n}(:,d), traindata{i}(:,d));
       
            %Last element is the actual distance b/w the 2 time series
            dtw = dtwMatrix(size(dtwMatrix,1),size(dtwMatrix,2));

            dtwSum = dtwSum + dtw;
        end
        dist(i) = dtwSum;
    end

    %Closest k neighbours
    [~,idx] = mink(dist,k);

    %Which class has closest set of elements; 3x1
    classPredicted = sum(trainclass(:,idx),2);
    
    %Get class with max closest points
    [~, class] = max(classPredicted);
    
    %Assigning the data point the class based on kNN
    C(class,n) = 1;
 
end