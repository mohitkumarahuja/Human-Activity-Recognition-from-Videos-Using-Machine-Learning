function label = recognizeAction( trainFeat, trainFeatLabel, testFeat )
% this function is used to recognise actions using train and test data

% %load the labels of training data
% load('trainFeatLabelsKTH.mat');

%train KNN classifier
mdlKNN = fitcknn(trainFeat, trainFeatLabel, 'ClassNames',[1,2,3,4,5,6], 'Distance','euclidean','NumNeighbors',50 );

%get cross validation error
% classError = kfoldLoss(mdlKNN);
% disp('The cross validation error is');
% disp(classError);

label = predict(mdlKNN, testFeat);

label = mode(label);






end

