function frameG = myGaussFft(frame, sigma)
% this function convolves frame with gaussian by fft and ifft



ftransform = fft(frame,[],1);
ftransform = fft(ftransform,[],2);

[xsize ysize] = size(ftransform);
[x y] = meshgrid(0 : xsize-1, 0 : ysize-1);


frameG = ifft(exp(sigma * (cos(2 * pi*(x / xsize)) + cos(2 * pi*(y / ysize)) - 2))' .* ftransform,[],1);
frameG = real(ifft(frameG,[],2));