function fig = lucas_kanade(image1_path, image2_path)
%LUCAS_KANADE apply Lucas-Kanade algorithm on given images to determine
%optical flow
%  lucas_kanade(image1_path, image2_path)
%  lucas_kanade('sphere1.ppm', 'shpere2.ppm');
%
%   - ARGUMENTS
%     image1      Path of the image to be taken as reference point
%     image2      Path of the image with movement
%
%   - OUTPUT
%     fig  Figure containing image2 and the arrows of the optical flow

image1 = imread(image1_path);
image2 = imread(image2_path);

% if images are RGB, transform to grayscale
if size(image1,3) > 1
    frame1 = rgb2gray(image1);
else
    frame1 = image1;
end

if size(image2,3) > 1
    frame2 = rgb2gray(image2);
else
    frame2 = image2;
end

% parameters setup
window = 15;
half = round(window/2);
pad = half - 1;
horizontal_blocks = floor(size(frame1, 1) / window);
vertical_blocks = floor(size(frame1, 2) / window);

% find the centers of the non-overlapping regions
% have the form (half, half+window, half+window*2, ...)
region_centers_x = cumsum([half, repelem(window, horizontal_blocks-1)]);
region_centers_y = cumsum([half, repelem(window, vertical_blocks-1)]);

% compute partial derivatives in x, y, and t directions
Ix_full = conv2(frame1, [-1 1; -1 1], 'same');
Iy_full = conv2(frame1, [-1 -1; 1 1], 'same');
It_full = conv2(frame1, ones(2), 'same') + conv2(frame2, -ones(2), 'same');

V = zeros(horizontal_blocks, vertical_blocks, 2);

% for each region, take the Ix, Iy and It, compute A, At, b and Vx and Vy
for x = region_centers_x
   for y = region_centers_y
       % slice matrices to get values for pixels in region
       Ix = Ix_full(x-pad:x+pad, y-pad:y+pad);
       Iy = Iy_full(x-pad:x+pad, y-pad:y+pad);
       It = It_full(x-pad:x+pad, y-pad:y+pad);
       
       % compute A, At, b
       Ix = Ix(:);
       Iy = Iy(:);
       b = -It(:);
       A = [Ix Iy];
       
       % compute V = (Vx, Vy) and place in matrix
       region_v = pinv(A) * b;
       
       V(region_centers_x==x, region_centers_y==y, :) = reshape(region_v, 1, 1, 2);
   end
end

% display image with the optical flow of each region (arrows are placed at
% the computed region centers)
fig = figure;
imshow(image2);
hold on;
quiver(region_centers_y, region_centers_x, V(:,:,1), V(:,:,2), 'r');