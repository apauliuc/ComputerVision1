close all; clear; clc;

k = 0.04;
sigma = 3;5;
threshold = 16000;
window_size = 14;
rotate_img = true;

orig_img = imread('person_toy/00000001.jpg');
if rotate_img
    orig_img = imrotate(orig_img,360*rand());
end
I = rgb2gray(orig_img);

half_wid = (sigma * 3 - 1)/2;
[dx, dy] = meshgrid(-half_wid:half_wid, -half_wid:half_wid);

Gxy = fspecial('gaussian', half_wid*2+1, sigma);
Gx = (dx .* Gxy);
Gy = (dy .* Gxy);

% 1) Compute x and y derivatives of image
Ix = conv2(I, Gx, 'same');
Iy = conv2(I, Gy, 'same');

figure, imshow(Ix)
figure, imshow(Iy)

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
       
       % 6) Threshold on value of R
       if (H(x,y) > threshold)
          im(x, y) = H(x,y); 
       end
   end
end

% 7) Compute nonmax suppression
window = true(window_size);
window(ceil(window_size/2),ceil(window_size/2)) = 0;
output = im > imdilate(im, window);
[y, x] = find(output == 1);

figure, imshow(orig_img);
hold on; % Prevent image from being blown away.
plot(x,y,'r+', 'MarkerSize', 20);