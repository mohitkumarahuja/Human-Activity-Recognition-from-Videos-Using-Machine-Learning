function  convertVideoToMat(  )
% this function takes all videos and convert to 3D mat files

%to get the dialog to select the directory of training data
path = uigetdir('cwd');

% to get the files in the directory selected
videoFiles = dir2([path,'\*.avi']);

%to get number of files in the directory
numFiles = length(videoFiles);

%to sort file names accordingly
fileNames = natsortfiles({videoFiles.name});

%wait bar
h = waitbar(0,'Please wait... converting videos...');


for nFile = 1 : numFiles
    fileName = strcat(path, '\', fileNames{nFile}); % to get filename
    
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
    
    %save the data matrices for further use
    [pathstr, File_name, ext] = fileparts(fileName);
    File_out = strcat('..\KTHDataSetTest_mat\', File_name, '.mat');
    save(File_out,'video3Dmat');
    waitbar(nFile/numFiles);
end
close(h)

end

