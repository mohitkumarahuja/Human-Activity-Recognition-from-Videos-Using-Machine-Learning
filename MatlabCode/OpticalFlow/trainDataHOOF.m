function trainDataHOOF( )
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
    
      
    % loop to read each frame and detect its features
    wantedFrames = 40;
    for nFrame = 1 : wantedFrames

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
        
        trainFeatures(rowCount, :) = ohog';
         rowCount = rowCount + 1;
         
    end
    waitbar(nFile/numFiles);
   
end
save('.\FeaturesTrainOpticalFlow\trainFeaturesHOOF.mat','trainFeatures'); 
close(h); %close wait bar
end

