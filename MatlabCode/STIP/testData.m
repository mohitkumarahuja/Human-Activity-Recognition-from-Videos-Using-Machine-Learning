function testFeatures = testData(  )
% this function is used to load test data and compute its features

%Function to get video file to detect action
[filename, pathname] = uigetfile({'*.avi;*.mpg','Video Files';'*.*','All Files'}, 'Select a Video to Detect Action');
fileName = fullfile(pathname, filename);

%create a video object
vidObject = VideoReader(fileName);

% declare # of frames and features in each frame required
wantedFrames = 50;
nPoints = 40;

%intialise testfeatures matrix to zeros
testFeatures = zeros(wantedFrames, nPoints);

axes(handles.axes1);

for nFrame = 1 : wantedFrames
    %         frame = mov(nFrame).cdata; %get each frame
    frame = readFrame(vidObject);
    frame = imresize(frame, [256 256]); % resize frames to 256 * 256
    frame = rgb2gray(frame); % convert RGB to Gray
    
    % get features using STIP
    % declare parameters
    kParameter = 0.04;
    sigma = 2;
    sSigma = 2 * sigma;
    % get the test feature from STIP
    [featPos, featVal] = computeSTIP( frame, kParameter, sigma, sSigma, nPoints );
    testFeatures(nFrame, :) = featVal;
    imshow(frame,[]), hold on;
end
save('testFeatures.mat','testFeatures'); 
hold off;
end

