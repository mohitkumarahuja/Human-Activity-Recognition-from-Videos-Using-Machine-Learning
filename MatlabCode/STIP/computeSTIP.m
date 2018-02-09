function [featPos, featVal] = computeSTIP( frame, kParameter, sigma, sSigma, nPoints )
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % this function computes the spatio-temporal interest points of the given
% % frame and outputs the interesting features of the frame.
%     input
%     frame               input frame to find STIP
%     kParameter          k parameter for harris corner detector
%     sigma               sigma for scale space representation to do gaussian convolution
%     sSigma              scaled sigma
%     nPoints             number of interest points required
%     
%     output
%     features            gives feature for frame
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[rows, cols] = size(frame);

% to pad the frame with extension of border values
framePad = padSame(frame, 4, 4);

% apply gaussian filter on frame
LFrame = myGaussFft(framePad, sigma);

% create masks for X and Y derivative
xMask = zeros(9,9);
xMask(5,4) = -1/2; xMask(5,6) = 1/2;
yMask = xMask';

%apply masks on frame
LFrameX = filter2(xMask,LFrame,'same');
LFrameY = filter2(yMask,LFrame,'same');

%crop as we extended earlier
LFrameX = crop2(LFrameX, 4, 4) * sqrt(sigma);
LFrameY = crop2(LFrameY, 4, 4) * sqrt(sigma);

% compute structure tensor matrix
LFrameX2 = LFrameX.*LFrameX;
LFrameY2 = LFrameY.*LFrameY;
LFrameXY = LFrameX.*LFrameY;

%apply gaussian on structure tensor
LFrameX2Fil = myGaussFft(LFrameX2, sSigma);
LFrameY2Fil = myGaussFft(LFrameY2, sSigma);
LFrameXYFil = myGaussFft(LFrameXY, sSigma);


%compute det and trace of structure tensor
detS = (LFrameX2Fil .* LFrameY2Fil) - (LFrameXYFil.^2);
traceS = LFrameX2Fil + LFrameY2Fil;

cornerImg = detS - (kParameter * (traceS.^2));

%detect maxima
[pos, val] = maxSupression(cornerImg);

%get X and Y position
posX = pos(:,2);
posY = pos(:,1);

% Sort and choose strongest nPoints
[valStrong, indexStrong] = sort(-val);

%check whether nPOints or strong points detected, which is small
nPoints = min(nPoints, length(indexStrong));

%position of strongest points
posX = posX(indexStrong(1:nPoints));
posY = posY(indexStrong(1:nPoints));

% value of strongest points
featVal = -valStrong(1:nPoints);

%get indices to point to original frame
indFrame = sub2ind([rows, cols],posY,posX);

%get values of structure tesnsor at these indices
LFrameX2Fil_11 = LFrameX2Fil(indFrame);
LFrameY2Fil_22 = LFrameY2Fil(indFrame);
LFrameXYFil_12 = LFrameXYFil(indFrame);

% put all positions, sigmas and gradient values together
featPos = [posX posY sigma*ones(size(posX)) LFrameX2Fil_11 LFrameXYFil_12 LFrameXYFil_12 LFrameY2Fil_22];

%discard boundary pixels
bound = 2;
goodIndex = find((posX>bound).*(posX<(cols-bound)).*(posY>bound).*(posY<(rows-bound)));
featPos = featPos(goodIndex, :);


end

