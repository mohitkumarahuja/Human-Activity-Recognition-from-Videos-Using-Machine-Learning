function testData3DSift(  )
%this function to detect an action in a given video

addpath('..\3DSIFT\');

%Function to get video file to detect action
[filename, pathname] = uigetfile({'*.avi;*.mpg','Video Files';'*.*','All Files'}, 'Select a Video to Detect Action');
fileName = fullfile(pathname, filename);

load('..\FeaturesTrain3DSift\trainFeatures.mat');

%wait bar
h = waitbar(0,'Please wait... computing features for video...');

%create a video object
vidObject = VideoReader(fileName);

%get video frame height and width
vidHeight = vidObject.Height;
vidWidth = vidObject.Width;

%take 200 frames in each video
vidFrames = 200;

% Create a video as a 3 dimensional data
video3Dmat = zeros(vidHeight, vidWidth, vidFrames);

% Read one frame at a time using readFrame until 200 frames reached
% Append data from each video frame to the mat array
for nFrame = 1: vidFrames
    vid_image = read(vidObject, nFrame);
    vid_image = rgb2gray(vid_image);
    video3Dmat(:, :, nFrame) = vid_image ;
end

% %save the data matrices for further use
% [pathstr, File_name, ext] = fileparts(filename);
% File_out = strcat('KTHDataSet_mat\', File_name, '.mat');
% save(File_out,'video3Dmat');

%get interest points
cornerPoints = interestPoints(video3Dmat);

%get features set
featuresSet = featureSet3DSift( video3Dmat, cornerPoints );

%combine with testfeatures to cluster
featuresSetAll = [featuresSetAll ; featuresSet];

% %pca to reduce dimensions
% coeff = pca(featuresSetAll);
% featuresSetAllR = featuresSetAll * coeff(:,1:700);

% Perform kmeans Clustering to Construct words of the Visual Vocabulary
cluster_idx = kmeans(featuresSetAll,600, 'Display', 'iter');
m = length(trainLabels);
signature = zeros(m+1,600);
nDescriptor = 100;

%bag of features
for k = 1:m+1
    
    for j = 1:nDescriptor
        
        idx = nDescriptor*(k-1) + j;
        
        signature(k, cluster_idx(idx))= signature(k, cluster_idx(idx)) + 1; 
        waitbar(k/m);
    end
end

% train and predict
featureBagTrain = signature(1:end-1, :);
classTrain = trainLabels;
t = templateSVM('Standardize',1,'KernelFunction','linear', 'BoxConstraint', COpt);

SVMMulticlassAction = fitcecoc(featureBagTrain, classTrain, 'Coding', 'onevsone',...
                                    'Learners',t); 
featureBagTest = signature(end,:);
predictAction = predict(SVMMulticlassAction, featureBagTest)

switch predictAction
    case 1
        disp('Boxing');
    case 2
        disp('Hand clapping');
    case 3
        disp('Hand Waving');
    case 4
        disp('Jogging');
    case 5
        disp('Runnning');
    case 6
        disp('Walking');
end
        
close(h);

end

