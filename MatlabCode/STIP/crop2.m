function frameCrop = crop2( frame, nX, nY)
%this function is used to crop the frame leaving nX and nY pixels in X and
%Y directions

[row, col] = size(frame);
frameCrop = frame(nX+1:row-nX, nY+1:col-nY);


end

