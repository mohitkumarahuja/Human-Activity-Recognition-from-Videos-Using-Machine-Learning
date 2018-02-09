function [accuracy, ConfusionTestMat] = getAccuracy3DSift(  )
% this function to calculate accuracy of 3D sift

addpath('..\3DSIFT\');

load('..\FeaturesTrain3DSift\trainFeatures.mat');

%to get the dialog to select the directory of testing data
path = uigetdir('cwd');

% to get the files in the directory selected
matFiles = dir2([path,'\*.mat']);

%to get number of files in the directory
numFiles = length(matFiles);

%to sort file names accordingly
fileNames = natsortfiles({matFiles.name});

%wait bar
h = waitbar(0,'Please wait... computing features for testing data...');

featuresSetAllTest = [];
testLabels = [];

for nFile = 1 : numFiles
    fileName = strcat(path, '\', fileNames{nFile}); % to get filename
    
    load(fileName);    
  
    %get interest points
    cornerPoints = interestPoints(video3Dmat);
    
    %get features set
    featuresSet = featureSet3DSift( video3Dmat, cornerPoints );
    
    % concatenate all features
    featuresSetAllTest = [featuresSetAllTest ; featuresSet];
    
    %get class label
    testClass = buildClassLabel(fileNames{nFile});
    
    % stack all class labels
    testLabels = [testLabels testClass];
    
    waitbar(nFile/numFiles);
end

save('..\FeaturesTrain3DSift\testFeatures.mat','featuresSetAllTest','testLabels');

close(h); %close wait bar


%wait bar
h = waitbar(0,'Please wait... training SVM...');

%combine train and test features to form clusters
featuresSetAllTest = [featuresSetAll; featuresSetAllTest];

testLabels = testLabels(:);



% Perform kmeans Clustering to Construct words of the Visual Vocabulary
cluster_idx = kmeans(featuresSetAllTest,600, 'Display', 'iter');
m = length(trainLabels);
n = length(testLabels);
signature = zeros(m+n,600);
nDescriptor = 100;

%Bag of features
for k = 1:m+n
    
    for j = 1:nDescriptor
        
        idx = nDescriptor*(k-1) + j;
        
        signature(k, cluster_idx(idx))= signature(k, cluster_idx(idx)) + 1; 
        waitbar(k/m);
    end
end

% train and predict
featureBagTrain = signature(1:m, :);
classTrain = trainLabels;
t = templateSVM('Standardize',1,'KernelFunction','linear', 'BoxConstraint', COpt);

SVMMulticlassAction = fitcecoc(featureBagTrain, classTrain, 'Coding', 'onevsone',...
                                    'Learners',t); 
featureBagTest = signature(m+1:end,:);
predictAction = predict(SVMMulticlassAction, featureBagTest);

%calculate accuracy
error = 0;
for i = 1:length(testLabels)
    if predictAction(i) ~= testLabels(i)
        error = error + 1;
    end
end
errorPer = error/numel(testLabels)*100;
accuracy = 100 - errorPer;

ConfusionTestMat = confusionmat(testLabels, predictAction);


end

