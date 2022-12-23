clc
close all
clear all

% %Load data
% files = dir("digits_3d_training_data/digits_3d/training_data//*.mat");
% for i=1:length(files)
%     pos{i} = load("digits_3d_training_data/digits_3d/training_data/"+files(i).name);
%     class{i} = floor(i/101);
% end

%Data has been saved as matfile for convenience
load Data.mat;

% Data = [pos; class];

%%Plotting
colour = [[1 0 0];[0 1 0];[0 0 1];[0 1 1];[1 0 1];[1 1 0];[0 0.4470 0.7410];[0.8500 0.3250 0.0980];[0.8500 0.3250 0.0980];[0.9290 0.6940 0.1250]];
%Plot the un normalised data
% for i =1:n
%     a = Data{1,i}.pos;
%     scatter3(a(:,1),a(:,2),a(:,3),[],colour(Data{2,i}+1,:),'filled')
%     hold on
% end

%Pre process data
[dataNew, classMember] = dataPreProcessing(Data);

%Normalize processed data
normalised_data = min_max_normalization(dataNew);
n = length(normalised_data);

%Classes
classMember = classMember(1:n);
classes = zeros(size(classMember)); 
classes(1,classMember== 0) = 1; classes(2, classMember == 1) = 1;
classes(3,classMember== 2) = 1; classes(4,classMember== 3) = 1; 
classes(5,classMember== 4) = 1; classes(6, classMember == 5) = 1;
classes(7,classMember== 6) = 1; classes(8,classMember== 7) = 1; 
classes(9,classMember== 8) = 1; classes(10,classMember== 9) = 1; 

dataset = {normalised_data{1:n}};


%%Divide the data into testing and training 
% Cross varidation (train: 75%, test: 25%)
cv = cvpartition(n,'HoldOut',0.25);
idx = cv.test;

%Training data and class uptill 75%
Training = dataset(:,~idx); 
classTrain = classes(:,~idx); 
%Testing data and class 25%
Testing = dataset(:,idx);
classTest = classes(:,idx);

k = 7;

C = knn(classTrain,Training,Testing, k);

%Compare output of algo with training class for accuracy
data_miss = sum(sum(C~=classTest))/2;

%Accuracy
accuracy = (length(classTest)-data_miss)/length(classTest)*100;
sprintf("Value of K : %d, Accuray: %d", k,accuracy)


% %Plot the test data against predicted classes
% for i =1:length(Testing)
%     a = Testing{i};
%     b = find(C(:,i) == 1);
%     scatter3(a(:,1),a(:,2),a(:,3), '.')
%     legend([{'0'}, {'1'}, {'2'}, {'3'}, {'4'}, {'5'}, {'6'}, {'7'}, {'8'}, {'9'}])
%     hold on
% end
