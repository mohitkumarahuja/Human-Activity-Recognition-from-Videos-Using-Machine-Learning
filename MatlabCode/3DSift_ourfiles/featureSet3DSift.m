function featuresSet = featureSet3DSift( video3Dmat, interestPoints )
% Obtain the Feature descriptors coressponding to 3D SIFT

addpath('..\3DSIFT\');

%Normalise video
video3Dmat = video3Dmat/max(max(max(video3Dmat)));
pix = video3Dmat;

offset = 0;
%tic;
% Generate descriptors at locations given by interestpoints
for i=1:100
    
    reRun = 1;
    
    while reRun == 1
        
        loc = interestPoints(i+offset,:);
        
        % Create a 3DSIFT descriptor at the given location
        [keys{i} reRun] = Create_Descriptor(pix,1,1,loc(1),loc(2),loc(3));
        
        if reRun == 1
            offset = offset + 1;
        end
        
    end
    
    
end

for i = 1:100
    feature_Video(i,:) = keys{1,i}.ivec;
end

featuresSet = double(feature_Video);


end

