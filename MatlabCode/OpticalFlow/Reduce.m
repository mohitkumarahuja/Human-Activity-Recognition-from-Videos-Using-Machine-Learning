function smallIm = Reduce(im)
% REDUCE	Compute smaller layer of Gaussian Pyramid


%Algo
%Gaussian mask = [0.05 0.25 0.4 0.25 0.05] 
% Apply 1d mask to alternate pixels along each row of image
% apply 1d mask to each pixel along alternate columns of resulting image


mask = [0.05 0.25 0.4 0.25 0.05];

hResult = conv2(im, mask);
hResult = hResult(:,3:size(hResult,2)-2);
hResult = hResult(:, 1:2:size(hResult,2));

vResult = conv2(hResult, mask');
vResult = vResult(3:size(vResult,1)-2, :);
vResult = vResult(1:2:size(vResult,1),:);

smallIm = vResult;
