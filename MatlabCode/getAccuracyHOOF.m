function getAccuracyHOOF(  )
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % this function to get Accuracy of test data set

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('.\OpticalFlow\');

%load the train features and labels
data = load('.\FeaturesTrainOpticalFlow\trainFeaturesHOOF.mat');
trainFeatures = data.trainFeatures;
data = load('.\FeaturesTrainOpticalFlow\trainFeatLabelsHOOF.mat');
trainFeatLabels = data.trainLabels; 
%load test labels
data = load('.\FeaturesTrainOpticalFlow\testFeatLabelsKTHNew.mat');
testLabels = data.testFeatLabelsKTHNew;

%to get the dialog to select the directory of testing data
path = uigetdir('cwd');

h = waitbar(0,'Please wait... calculating accuracy...');


% to get the files in the directory selected
videoFiles = dir2([path,'\*.avi']);

%to get number of files in the directory
numFiles = length(videoFiles);

%to sort file names accordingly
fileNames = natsortfiles({videoFiles.name});

%train classifier
mdlKNN = fitcknn(trainFeatures, trainFeatLabels, 'ClassNames',[1,2,3,4,5,6], 'Distance','euclidean','NumNeighbors',100 );

labelNew = [];

for nFile = 1 : numFiles
    fileName = strcat(path, '\', fileNames{nFile}); % to get filename
    
    %create a video object
    vidObject = VideoReader(fileName);
    
    %for HOOF
            %get video frame height and width
    vidHeight = vidObject.Height;
    vidWidth = vidObject.Width;
    
    %create a structure array to save frames
    mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);
    
    %read frames one ata a time till end
    k = 1;
    while hasFrame(vidObject)
        mov(k).cdata = readFrame(vidObject);
        k = k+1;
    end
    
    wantedFrames = 40;
    for nFrame = 1 : wantedFrames
        %for HOOF

        %get one frame to compute OF
        frame1 = mov(nFrame).cdata; %get each frame
        frame1 = rgb2gray(frame1); % convert RGB to Gray
        
        %get other frame to compute OF
        frame2 = mov(nFrame+1).cdata; %get each frame
        frame2 = rgb2gray(frame2); % convert RGB to Gray
        
        %compute Optical flow
        numLevels = 2; % for pyramid of LK
        windowSize = 3; %Size of smoothing window
        iterations = 1;
        display = 0; % dont disply the OF
        [u,v,~] = HierarchicalLK(double(frame1), double(frame2), numLevels, windowSize, iterations, display);

        %compute HOOF
        ohog = gradientHistogram(u,v,50);
        % get the train feature from STIP
        testFeatures(nFrame, :) = ohog';
         
    end

    %detect the video
    label = predict(mdlKNN, testFeatures);
    labelNew = [labelNew mode(label)]
    waitbar(nFile/numFiles);
end

%calculate accuracy
error = 0;
for i = 1:length(testLabels)
    if labelNew(i) ~= testLabels(i)
        error = error + 1;
    end
end
errorPer = error/numel(testLabels)*100;
accuracy = 100 - errorPer;

c = confusionmat(testLabels, labelNew);
delete(h);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('******************************************************************');
disp('The accuracy of test data set is :');
disp(accuracy);
disp('The Confusion matrix is:');
disp(c);
disp('******************************************************************');
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

