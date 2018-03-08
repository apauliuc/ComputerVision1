function [x, y] = tracking_locate_points(I)
%TRACKING_LOCATE_POINTS Locate feature points from input image
%   Uses Harris Corner Detector algorithm to localise feature points
sigma = 3;5;
thres = 16000;
window_N = 14;

half_wid = (sigma * 3 - 1)/2;
[dx, dy] = meshgrid(-half_wid:half_wid, -half_wid:half_wid);
Gxy = fspecial('gaussian', half_wid*2+1, sigma);
Gx = (dx .* Gxy);
Gy = (dy .* Gxy);

Ix = conv2(I, Gx, 'same');
Iy = conv2(I, Gy, 'same');

Ix2 = conv2(Ix .^ 2, Gxy, 'same');
Iy2 = conv2(Iy .^ 2, Gxy, 'same');
Ixy = conv2(Ix .* Iy, Gxy, 'same');

myHarris = (Ix2.*Iy2 - Ixy.^2) - 0.04*(Ix2 + Iy2).^2;

thresholded_harris = myHarris;
thresholded_harris(myHarris<thres) = 0;

window = true(window_N);
window(ceil(window_N/2),ceil(window_N/2)) = 0;
output = thresholded_harris > imdilate(thresholded_harris, window);
[y, x] = find(output == 1);
end