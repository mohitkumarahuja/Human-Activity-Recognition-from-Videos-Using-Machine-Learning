function [cornerPoints] = interestPoints(video3Dmat)
% Function to Obtain the Interest Points coressponding to Harris corners
% from the video frames

numFrames = size(video3Dmat, 3); % get number of frames

subTotal = [];
for nFrame = 1:2:numFrames
    
    
    
         frame = squeeze(video3Dmat(:,:, nFrame)); %squueze singleton dimension
         pointsFeat = detectHarrisFeatures(frame);  % detect harris corners
         [ ~ , validPoints] = extractFeatures(frame, pointsFeat); % extract features
         validPoints = validPoints.selectStrongest(12); % select strongest corners
         corners = validPoints.Location ; % get locations
         points = round(corners);
     
         numInterestPoints = size(points,1); 
         
         if numInterestPoints >= 10
         
             sub = points(1:10, 1:2);
             if nFrame==1
                   subTotal = [sub(:,1), sub(:,2), ones(max(length(sub(:,1))),1)]; % third column in matrix to know corner points of which frame
             else 
                   subTotal = [subTotal; [sub(:,1), sub(:,2),nFrame*ones(max(length(sub(:,1))),1)]];
             end
         end
     
end
     cornerPoints = subTotal;
end