function [ myHarris ] = harris_corner_detector(image, sigma, thres, window_N, rotate)
%HARRIS_CORNER_DETECTOR creates a cornerness matrix H
%  myHarris = harris_corner_detector(image, sigma, thres, window_N, rotate)
%  harris_corner_detector('person_toy/00000001.jpg', 3, 16000, 14, false);
%
%   - ARGUMENTS
%     image      Path to the image
%     sigma      Standard deviation of the gaussian
%     threshold  Which values can be seen as corners
%     window_N   size of the nonmax suppression window
%     rotate     boolean about whether the image should be rotated
%   
%   - OUTPUT
%     myHarrs  A matrix of size [h,w], holding the cornerness value of
%     each pixel.

% 1) Read image and rotate if needed
orig_img = imread(image);
if rotate
    orig_img = imrotate(orig_img,360*rand());
end
I = rgb2gray(orig_img);

% 2) Calculating the gaussian kernel
half_wid = (sigma * 3 - 1)/2;
[dx, dy] = meshgrid(-half_wid:half_wid, -half_wid:half_wid);
Gxy = fspecial('gaussian', half_wid*2+1, sigma);
Gx = (dx .* Gxy);
Gy = (dy .* Gxy);

% 3) Compute x and y derivatives of image
Ix = conv2(I, Gx, 'same');
Iy = conv2(I, Gy, 'same');

% 4) Show computed image of derivatives Ix and Iy
figure, imshow(Ix), title('image derivatives Ix')
figure, imshow(Iy), title('image derivatives Iy')

% 5) Compute the sums of the products of derivatives at each pixel
Ix2 = conv2(Ix .^ 2, Gxy, 'same');
Iy2 = conv2(Iy .^ 2, Gxy, 'same');
Ixy = conv2(Ix .* Iy, Gxy, 'same');

% 6) Define the matrix H for each pixel
myHarris = (Ix2.*Iy2 - Ixy.^2) - 0.04*(Ix2 + Iy2).^2;

% 7) Changing values below threshold to zero
thresholded_harris = myHarris;
thresholded_harris(myHarris<thres) = 0;

% 8) Compute nonmax suppression
window = true(window_N);
window(ceil(window_N/2),ceil(window_N/2)) = 0;
output = thresholded_harris > imdilate(thresholded_harris, window);
[y, x] = find(output == 1);

% 9) Show original image with corner points
figure, imshow(orig_img);
hold on; % Prevent image from being blown away.
plot(x,y,'y+', 'MarkerSize', 10);
title('original image with corner points')
end