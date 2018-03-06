close all; clear; clc;

k = 0.04;
sigma = 4;
Threshold = 15000;

I = rgb2gray(imread('person_toy/00000001.jpg'));

half_wid = (sigma * 3 - 1)/2;
[dx, dy] = meshgrid(-half_wid:half_wid, -half_wid:half_wid);

Gxy = fspecial('gaussian', half_wid*2+1, sigma);
Gx = (dx .* Gxy);
Gy = (dy .* Gxy);

% 1) Compute x and y derivatives of image
Ix = conv2(I, Gx, 'same');
Iy = conv2(I, Gy, 'same');

% 2) Compute the sums of the products of derivatives at each pixel
Ix2 = conv2(Ix .^ 2, Gxy, 'same');
Iy2 = conv2(Iy .^ 2, Gxy, 'same');
Ixy = conv2(Ix .* Iy, Gxy, 'same');

% 3) Define at each pixel the matrix H
H = (Ix2.*Iy2 - Ixy.^2) - k*(Ix2 + Iy2).^2;

numOfRows = size(I, 1);
numOfColumns = size(I, 2);

im = zeros(numOfRows, numOfColumns);
for x=1:numOfRows
   for y=1:numOfColumns
       % 4) Threshold on value of R
       if (H(x,y) > Threshold)
          im(x, y) = H(x,y); 
       end
   end
end

% 5) Compute nonmax suppression
output = im > imdilate(im, [1 1 1; 1 0 1; 1 1 1]);

figure, imshow(I);
figure, imshow(output)