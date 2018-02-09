function varargout = actionDetection(varargin)
% ACTIONDETECTION MATLAB code for actionDetection.fig
%      ACTIONDETECTION, by itself, creates a new ACTIONDETECTION or raises the existing
%      singleton*.
%
%      H = ACTIONDETECTION returns the handle to a new ACTIONDETECTION or the handle to
%      the existing singleton*.
%
%      ACTIONDETECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ACTIONDETECTION.M with the given input arguments.
%
%      ACTIONDETECTION('Property','Value',...) creates a new ACTIONDETECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before actionDetection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to actionDetection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help actionDetection

% Last Modified by GUIDE v2.5 03-Jun-2017 18:54:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @actionDetection_OpeningFcn, ...
                   'gui_OutputFcn',  @actionDetection_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before actionDetection is made visible.
function actionDetection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to actionDetection (see VARARGIN)

% Choose default command line output for actionDetection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.axes1, 'XTickLabel',[],'YTickLabel',[]);

% UIWAIT makes actionDetection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = actionDetection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function recognizeEdit_Callback(hObject, eventdata, handles)
% hObject    handle to recognizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of recognizeEdit as text
%        str2double(get(hObject,'String')) returns contents of recognizeEdit as a double


% --- Executes during object creation, after setting all properties.
function recognizeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to recognizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in computeTrainFeaturesPush.
function computeTrainFeaturesPush_Callback(hObject, eventdata, handles)
% hObject    handle to computeTrainFeaturesPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%for STIP
if get(handles.stipRadio, 'Value') == true
    addpath('.\STIP\');
    trainData( ); %data will be stored in FeaturesTrainSTIP folder
    
    %For OPTICAL FLOW
elseif get(handles.ofRadio, 'Value') == true
    addpath('.\OpticalFlow');
    trainDataHOOF( ); %data will be stored in FeaturesTrainOpticalFlow folder
    
%for 3D SIFT
elseif get(handles.Sift3DRadio, 'Value') == true
    % add path for 3d sift files to execute
    addpath('.\3DSift_ourfiles\');
    trainData3DSIFT( ); % train data stored in FeaturesTrain3DSift folder
end


% --- Executes on button press in loadTrainFeaturesPush.
function loadTrainFeaturesPush_Callback(hObject, eventdata, handles)
% hObject    handle to loadTrainFeaturesPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = waitbar(0,'Please wait... Data is loading');

%FOR STIP LOADING TRAIN DATA (FEATURES)
if get(handles.stipRadio, 'Value') == true
    
    data = load('.\FeaturesTrainSTIP\trainFeaturesKTHNew1.mat');
    handles.trainFeatures = data.trainFeatures;
    
    waitbar(0.5);
    
    data = load('.\FeaturesTrainSTIP\trainFeatLabelsKTHNew1.mat');
    handles.trainFeatLabels = data.trainLabels;
    
    %FOR OPTICAL FLOW LOADING TRAIN DATA (FEATURES)
elseif get(handles.ofRadio, 'Value') == true
    data = load('.\FeaturesTrainOpticalFlow\trainFeaturesHOOF.mat');
    handles.trainFeatures = data.trainFeatures;
    
    waitbar(0.5);
    
    data = load('.\FeaturesTrainOpticalFlow\trainFeatLabelsHOOF.mat');
    handles.trainFeatLabels = data.trainLabels;
    
    %FOR 3D SIFT LOADING TRAIN DATA (FEATURES)
elseif get(handles.Sift3DRadio, 'Value') == true
    waitbar(0.3);
    data = load('.\FeaturesTrain3DSift\trainFeatures.mat');
    handles.trainFeatures = data.featuresSetAll;
    handles.trainFeatLabels = data.trainLabels;
    handles.COpt = data.COpt;
end


delete(h)

guidata(hObject, handles);



% --- Executes on button press in loadTestVideoPush.
function loadTestVideoPush_Callback(hObject, eventdata, handles)
% hObject    handle to loadTestVideoPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% this function is used to load test data and compute its features

set(handles.recognizeEdit,'String',' ');

if get(handles.stipRadio, 'Value') == true
    
    addpath('.\STIP\');
    %Function to get video file to detect action
    [filename, pathname] = uigetfile({'*.avi;*.mpg','Video Files';'*.*','All Files'}, 'Select a Video to Detect Action');
     
    fileName = fullfile(pathname, filename);
    
    %create a video object
    vidObject = VideoReader(fileName);
    
    
    % declare # of frames and features in each frame required
    wantedFrames = 50;
    nPoints = 40;
    
    %intialise testfeatures matrix to zeros
    testFeatures = zeros(wantedFrames, 36);
    
    axes(handles.axes1)
    
    for nFrame = 1:50
        frame = read(vidObject, nFrame);
        frame = imresize(frame, [256 256]); % resize frames to 256 * 256
        frame = rgb2gray(frame); % convert RGB to Gray
        
        imshow(frame,[]), pause(0.00001);
    end
    
    h = waitbar(0,'Computing Features for test video...');
    
    for nFrame = 1 : wantedFrames
        %         frame = mov(nFrame).cdata; %get each frame
        frame = read(vidObject, nFrame);
        frame = imresize(frame, [256 256]); % resize frames to 256 * 256
        frame = rgb2gray(frame); % convert RGB to Gray
        
        % get features using STIP
        % declare parameters
        kParameter = 0.04;
        sigma = 4;
        sSigma = 2 * sigma;
        % get the test feature from STIP
        [featPos,~] = computeSTIP( frame, kParameter, sigma, sSigma, nPoints );
        
        cPoints = cornerPoints([featPos(:,1) featPos(:,2)]);
        [fea,~] = extractHOGFeatures(frame,cPoints);
        featVal = mean(fea);
        
        testFeatures(nFrame, :) = featVal;
        waitbar(nFrame/wantedFrames);
    end
    save('testFeatures.mat','testFeatures'); 
    delete(h)
    handles.testFeatures = testFeatures;
    guidata(hObject, handles);
    % for HOOF
elseif get(handles.ofRadio,'Value') == true
    addpath('.\OpticalFlow');
    
   
    
    %Function to get video file to detect action
    [filename, pathname] = uigetfile({'*.avi;*.mpg','Video Files';'*.*','All Files'}, 'Select a Video to Detect Action');
    
     h = waitbar(0, 'Loading video...');
    
    fileName = fullfile(pathname, filename);
    
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
        waitbar(k/100);
    end
    
    delete(h);
    
    axes(handles.axes1)
    
    for nFrame = 1:50
        frame = mov(nFrame).cdata;
        frame = imresize(frame, [256 256]); % resize frames to 256 * 256
        frame = rgb2gray(frame); % convert RGB to Gray
        
        imshow(frame,[]), pause(0.00001);
    end
    
    h = waitbar(0,'Computing Features for test video...');
    
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
        % get the train feature from STIP
        testFeatures(nFrame, :) = ohog';
        waitbar(nFrame/wantedFrames);
    end
    save('testFeatures.mat','testFeatures'); 
    delete(h)
    handles.testFeatures = testFeatures;
    guidata(hObject, handles);
    
    %For only loading video for 3D Sift
elseif get(handles.Sift3DRadio, 'Value') == true
    %Function to get video file to detect action
    [filename, pathname] = uigetfile({'*.avi;*.mpg','Video Files';'*.*','All Files'}, 'Select a Video to Detect Action');
    fileName = fullfile(pathname, filename);
    
    %wait bar
    h = waitbar(0,'Please wait... loading video...');
    
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
        waitbar(nFrame/vidFrames);
    end
    
    delete(h)
    handles.video3Dmat = video3Dmat;
    
    % show video
    for nFrame = 1:50
        frame = imresize(video3Dmat(:,:,nFrame), [256 256]); % resize frames to 256 * 256
              
        imshow(frame,[]), pause(0.00001);
    end
    
    guidata(hObject, handles);
end








% --- Executes on button press in detectActionPush.
function detectActionPush_Callback(hObject, eventdata, handles)
% hObject    handle to detectActionPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = waitbar(0, 'Detecting Action...');

if (get(handles.stipRadio, 'Value') == true) || (get(handles.ofRadio,'Value') == true)
    if get(handles.stipRadio, 'Value') == true
        addpath('.\STIP\');
    else
        addpath('.\OpticalFlow\');
    end
    waitbar(0.2);
    trainFeat = handles.trainFeatures;
    trainFeatLabel = handles.trainFeatLabels;
    testFeat = handles.testFeatures;
    
    label = recognizeAction( trainFeat, trainFeatLabel, testFeat );
    
    waitbar(0.75);
else
    waitbar(0.05);
    addpath('.\3DSift_ourfiles\');
    addpath('.\3DSIFT\');
    video3Dmat = handles.video3Dmat;
    
    %get interest points
    cornerPoints = interestPoints(video3Dmat);
    
    %get features set
    featuresSet = featureSet3DSift( video3Dmat, cornerPoints );
    
    %get training data
    featuresSetAll = handles.trainFeatures;
    trainLabels = handles.trainFeatLabels;
    COpt = handles.COpt;
    
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
    label = predict(SVMMulticlassAction, featureBagTest);
end

%for KTH
switch label
    case 1
        set(handles.recognizeEdit,'String','Boxing');
    case 2
        set(handles.recognizeEdit,'String','Hand clapping');
    case 3
        set(handles.recognizeEdit,'String','Hand Waving');
    case 4
        set(handles.recognizeEdit,'String','Jogging');
    case 5
        set(handles.recognizeEdit,'String','Runnning');
    case 6
        set(handles.recognizeEdit,'String','Walking');
end

delete(h)
