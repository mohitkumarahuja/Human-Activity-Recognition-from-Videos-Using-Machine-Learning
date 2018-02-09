function trainData( )
% this function takes the training videos and form the trainfeature vectors



%to get the dialog to select the directory of training data
path = uigetdir('cwd');

% to get the files in the directory selected
videoFiles = dir2([path,'\*.avi']);

%to get number of files in the directory
numFiles = length(videoFiles);

%to sort file names accordingly
fileNames = natsortfiles({videoFiles.name});

%row counter for features
rowCount = 1;

%wait bar
h = waitbar(0,'Please wait... computing features for training data...');

for nFile = 1 : numFiles
    fileName = strcat(path, '\', fileNames{nFile}); % to get filename
    
    %create a video object
    vidObject = VideoReader(fileName);
    
%     %get video frame height and width
%     vidHeight = vidObject.Height;
%     vidWidth = vidObject.Width;
%     
%     %create a structure array to save frames
%     mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);
%     
%     %read frames one ata a time till end
%     k = 1;
%     while hasFrame(vidObject)
%         mov(k).cdata = readFrame(vidObject);
%         k = k+1;
%     end
    
    % loop to read each frame and detect its features
    wantedFrames = 50;
    for nFrame = 1 : wantedFrames
%         frame = mov(nFrame).cdata; %get each frame
        frame = readFrame(vidObject);
        frame = imresize(frame, [256 256]); % resize frames to 256 * 256
        frame = rgb2gray(frame); % convert RGB to Gray
        
        % get features using STIP
        % declare parameters
        kParameter = 0.04;
        sigma = 4;
        sSigma = 2 * sigma;
        nPoints = 40;
        [featPos, ~] = computeSTIP( frame, kParameter, sigma, sSigma, nPoints );
        
        cPoints = cornerPoints([featPos(:,1) featPos(:,2)]);
        [fea,~] = extractHOGFeatures(frame,cPoints);
        featVal = mean(fea);
        % get the train feature from STIP
        trainFeatures(rowCount, :) = featVal;
         rowCount = rowCount + 1;
    end

    waitbar(nFile/numFiles);
    
end
save('.\FeaturesTrainSTIP\trainFeaturesKTHNew1.mat','trainFeatures'); 
close(h); %close wait bar
end

