function [u,v,cert] = LucasKanadeRefined(uIn, vIn, im1, im2);
% Lucas Kanade Refined computes lucas kanade flow at the current level given previous estimates!
%current implementation is only for a 3x3 window


%[fx, fy, ft] = ComputeDerivatives(im1, im2);

uIn = round(uIn);
vIn = round(vIn);
%uIn = uIn(2:size(uIn,1), 2:size(uIn, 2)-1);
%vIn = vIn(2:size(vIn,1), 2:size(vIn, 2)-1);


u = zeros(size(im1));
v = zeros(size(im2));

%to compute derivatives, use a 5x5 block... the resulting derivative will be 5x5...
% take the middle 3x3 block as derivative
for i = 3:size(im1,1)-2
   for j = 3:size(im2,2)-2
    %  if uIn(i,j)~=0
    %     disp('ha');
    %  end;
      
      curIm1 = im1(i-2:i+2, j-2:j+2);
      lowRindex = i-2+vIn(i,j);
      highRindex = i+2+vIn(i,j);
      lowCindex = j-2+uIn(i,j);
      highCindex = j+2+uIn(i,j);
      
      if (lowRindex < 1) 
         lowRindex = 1;
         highRindex = 5;
      end;
      
      if (highRindex > size(im1,1))
         lowRindex = size(im1,1)-4;
         highRindex = size(im1,1);
      end;
      
      if (lowCindex < 1) 
         lowCindex = 1;
         highCindex = 5;
      end;
      
      if (highCindex > size(im1,2))
         lowCindex = size(im1,2)-4;
         highCindex = size(im1,2);
      end;
      
      if isnan(lowRindex)
         lowRindex = i-2;
         highRindex = i+2;
      end;
      
      if isnan(lowCindex)
         lowCindex = j-2;
         highCindex = j+2;
      end;
      

      
      curIm2 = im2(lowRindex:highRindex, lowCindex:highCindex);
      
      [curFx, curFy, curFt]=ComputeDerivatives(curIm1, curIm2);
      curFx = curFx(2:4, 2:4);
      curFy = curFy(2:4, 2:4);
      curFt = curFt(2:4, 2:4);
      
      curFx = curFx';
      curFy = curFy';
      curFt = curFt';


      curFx = curFx(:);
      curFy = curFy(:);
      curFt = -curFt(:);
      
      A = [curFx curFy];
      
      U = pinv(A'*A)*A'*curFt;
      
      u(i,j)=U(1);
      v(i,j)=U(2);
      
      cert(i,j) = rcond(A'*A);
      
   end;
end;

u = u+uIn;
v = v+vIn;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [fx, fy, ft] = ComputeDerivatives(im1, im2);
%ComputeDerivatives	Compute horizontal, vertical and time derivative
%							between two gray-level images.

if (size(im1,1) ~= size(im2,1)) | (size(im1,2) ~= size(im2,2))
   error('input images are not the same size');
end;

if (size(im1,3)~=1) | (size(im2,3)~=1)
   error('method only works for gray-level images');
end;


fx = conv2(im1,0.25* [-1 1; -1 1]) + conv2(im2, 0.25*[-1 1; -1 1]);
fy = conv2(im1, 0.25*[-1 -1; 1 1]) + conv2(im2, 0.25*[-1 -1; 1 1]);
ft = conv2(im1, 0.25*ones(2)) + conv2(im2, -0.25*ones(2));

% make same size as input
fx=fx(1:size(fx,1)-1, 1:size(fx,2)-1);
fy=fy(1:size(fy,1)-1, 1:size(fy,2)-1);
ft=ft(1:size(ft,1)-1, 1:size(ft,2)-1);
