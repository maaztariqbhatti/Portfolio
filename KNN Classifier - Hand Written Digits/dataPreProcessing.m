function [dataNew, classMember] = dataPreProcessing(Data)
%% This function performs the task of removing outliers
%% -----------------------------------------------------
%% dataNew - 3d dataset after outlier's removal
%% classMember - New array containing class labels

%% Seperate time series data row from Data structure 
dataRow = {};
for i = 1:length(Data)
    dataRow{i} =  Data{1,i}.pos(:,:);
end

%Seperate classes label row from Data structure 
classRow = [Data{2,:}];

%% Dimension 1
dim1 = [];
for i = 1:length(Data)
    dim1 = [dim1; Data{1,i}.pos(:,1)];
end

for i = 1:length(Data)
    dim1Data{i} = Data{1,i}.pos(:,1);
end

%Upper treshhold 
upperThresh = mean(dim1) + 3*std(dim1);
%Lower treshhold 
lowerThresh = mean(dim1) - 3*std(dim1);

removeIdx = [];
for j = 1:length(dim1Data)
    if (sum(dim1Data{j}>upperThresh)>0 || sum(dim1Data{j}<lowerThresh)>0)
        removeIdx = [removeIdx j];
    end
end


%% Dimension 2
dim2 = [];
for i = 1:length(Data)
    dim2 = [dim2; Data{1,i}.pos(:,2)];
end

for i = 1:length(Data)
    dim2Data{i} = Data{1,i}.pos(:,2);
end

%Upper treshhold 
upperThresh = mean(dim2) + 3*std(dim2);

%Lower treshhold 
lowerThresh = mean(dim2) - 3*std(dim2);

removeIdx2 = [];
for j = 1:length(dim2Data)
    if (sum(dim2Data{j}>upperThresh)>0 || sum(dim2Data{j}<lowerThresh)>0)
        removeIdx2 = [removeIdx2 j];
    end
end

%% Dimension 3
dim3 = [];
for i = 1:length(Data)
    dim3 = [dim3; Data{1,i}.pos(:,3)];
end

for i = 1:length(Data)
    dim3Data{i} = Data{1,i}.pos(:,3);
end

%Upper treshhold 
upperThresh = mean(dim3) + 3*std(dim3);

%Lower treshhold 
lowerThresh = mean(dim3) - 3*std(dim3);

removeIdx3 = [];
for j = 1:length(dim3Data)
    if (sum(dim3Data{j}>upperThresh)>0 || sum(dim3Data{j}<lowerThresh)>0)
        removeIdx3 = [removeIdx3 j];
    end
end

%% Get all indexes for outliers from 3 dimensions
unionDim1Dim2 = union(removeIdx,removeIdx2);
unionAll = union(unionDim1Dim2, removeIdx3);

col = 0;
dataNew ={};
for j = 1:length(Data)
    if (sum(unionAll == j) > 0)
        continue
    end
    col = col+1;
    dataNew{col} = dataRow{j};
end

col = 0;
for j = 1:length(classRow)
    if (sum(unionAll == j) > 0)
        continue
    end
    col = col+1;
    classMember(col) = classRow(j);
end
end



