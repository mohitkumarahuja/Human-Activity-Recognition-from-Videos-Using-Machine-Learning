function trainData3DSIFT( )
% this function takes the training videos and form the trainfeature vectors

addpath('..\3DSIFT\');

%to get the dialog to select the directory of training data
path = uigetdir('cwd');

% to get the files in the directory selected
matFiles = dir2([path,'\*.mat']);

%to get number of files in the directory
numFiles = length(matFiles);

%to sort file names accordingly
fileNames = natsortfiles({matFiles.name});

%wait bar
h = waitbar(0,'Please wait... computing features for training data...');

featuresSetAll = [];
trainLabels = [];

for nFile = 1 : numFiles
    fileName = strcat(path, '\', fileNames{nFile}); % to get filename
    
    load(fileName); %load mat data
    
    %get interest points
    cornerPoints = interestPoints(video3Dmat);
    
    %get features set
    featuresSet = featureSet3DSift( video3Dmat, cornerPoints );
    
    % concatenate all features
    featuresSetAll = [featuresSetAll ; featuresSet];
    
    %get class label
    trainClass = buildClassLabel(fileNames{nFile});
    
    % stack all class labels
    trainLabels = [trainLabels trainClass];
    
    waitbar(nFile/numFiles);
    nFile
end


close(h); %close wait bar

%wait bar
h = waitbar(0,'Please wait... optimising SVM for Traindata...');

trainLabels = trainLabels(:);

% Perform kmeans Clustering to Construct words of the Visual Vocabulary
cluster_idx = kmeans(featuresSetAll,600, 'Display', 'iter');
m = length(trainLabels);
signature = zeros(m,600);
nDescriptor = 100;

%Bag of features
for k = 1:m
    
    for j = 1:nDescriptor
        
        idx = nDescriptor*(k-1) + j;
        
        signature(k, cluster_idx(idx))= signature(k, cluster_idx(idx)) + 1; 
        waitbar(k/m);
    end
end

% Shuffle the training set
indxs = randperm(length(trainLabels));
CValues = [0.01; 0.1; 1; 10; 100; 1000];

for i = 1:length(CValues)
    % Performing 5 fold cross vaalidation
     C = CValues(i,:);
     featureBagCombn = signature(indxs(1:m), :);
     actionLabels = trainLabels(indxs(1:m), :);
     t = templateSVM('Standardize',1,'KernelFunction','linear', 'BoxConstraint', C);      
     
     SVMMulticlass_combn = fitcecoc(featureBagCombn, actionLabels, 'Coding', 'onevsone',...
                                          'Learners', t); 
     ActionCrossVal = crossval(SVMMulticlass_combn, 'KFold', 5);
     
     
     cross_val_error(i,:) = kfoldLoss(ActionCrossVal);
     
     waitbar(i/length(CValues));
end

[~, indC] = min(cross_val_error);
COpt = CValues(indC,:);

close(h)
save('.\FeaturesTrain3DSift\trainFeatures.mat','featuresSetAll','trainLabels','COpt');
end

