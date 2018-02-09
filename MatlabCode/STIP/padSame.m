function framePad = padSame( frame, xPad, yPad )
% this function pads the frame with the extension of values at border
% for xPad and yPad values

[rows, cols] = size(frame);
rowsPad = rows + 2 * xPad;
colsPad = cols + 2 * yPad;
framePad = zeros(rowsPad, colsPad);
framePad(xPad + 1 : xPad + rows, yPad + 1 : yPad + cols) = frame;

for i = 1 : yPad
    framePad(:, i) = framePad(:, yPad + 1);
end

for i = yPad+cols+1 : colsPad
    framePad(:, i) = framePad(:, yPad + cols);
end

for i = 1 : xPad
    framePad(i, :) = framePad(xPad + 1, :);
end

for i = xPad+rows+1 : rowsPad
    framePad(i, :) = framePad(xPad + rows, :);
end



end

