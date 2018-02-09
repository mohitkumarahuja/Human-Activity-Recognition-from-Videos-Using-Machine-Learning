function [ pos, val] = maxSupression(cornerImage)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % this function computes the maxima of corner image
%     input
%     cornerImage         harris corner image               
%     
%     output
%     pos                 gives position of maxima
%     val                 gives value of maxima
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



Shifts = zeros( numel( cornerImage), 9);

% find shifts at each position of 9 * 9 neighbourhood
for vecpsf = eye( 9)
  Shift = conv2( pad( cornerImage, -inf), reshape( vecpsf, 3, 3), 'valid');
  Shifts( :, find(vecpsf)) = Shift( :);
end

Anms = ones( size( cornerImage(:)));
% check whether middle col is greater than first four colums
for shiftind = 1: 4
  Anms = Anms & Shifts( :, 5) >= Shifts( :, shiftind);
end
% check whether middle col is greater than last four colums
for shiftind = 6: 9
  Anms = Anms & Shifts( :, 5) > Shifts( :, shiftind);
end

%find local maximum in 9*9 neighbourhood
locmaxind = find( Anms);
[ Col, Row] = meshgrid( 1: size( cornerImage, 2), 1: size( cornerImage, 1));

%find position of lacal maxima
pos = [ Row( locmaxind) Col( locmaxind)];

% find value of local maxima
val = cornerImage( locmaxind);
