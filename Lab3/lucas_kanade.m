function lucas_kanade(input_image1, input_image2)
% read images and if RGB, transform to grayscale
image1 = im2double(input_image1);
if size(image1,3) > 1
    frame1 = rgb2gray(image1);
else
    frame1 = image1;
end

image2 = im2double(input_image2);
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
blocks_center_x = cumsum([half, repelem(window, horizontal_blocks-1)]);
blocks_center_y = cumsum([half, repelem(window, vertical_blocks-1)]);

% compute partial derivatives in x, y, and t directions
Ix_full = conv2(frame1, [-1 1; -1 1], 'same');
Iy_full = conv2(frame1, [-1 -1; 1 1], 'same');
It_full = conv2(frame1, ones(2), 'same') + conv2(frame2, -ones(2), 'same');

Vx = zeros(horizontal_blocks, vertical_blocks);
Vy = zeros(horizontal_blocks, vertical_blocks);

% for each region, take the Ix, Iy and It, compute A, At, b and Vx and Vy
for x = blocks_center_x
   for y = blocks_center_y       
       Ix = Ix_full(x-pad:x+pad, y-pad:y+pad);
       Iy = Iy_full(x-pad:x+pad, y-pad:y+pad);
       It = It_full(x-pad:x+pad, y-pad:y+pad);
       
       Ix = Ix(:);
       Iy = Iy(:);
       b = -It(:);
       
       A = [Ix Iy];
       V = pinv(A) * b;
       
       i = find(blocks_center_x==x);
       j = find(blocks_center_y==y);
       
       Vx(i, j) = V(1);
       Vy(i, j) = V(2);
   end
end

% display image with the optical flow of each region (arrows are placed at
% the computed region centers)
figure();
imshow(image2);
hold on;
quiver(blocks_center_x, blocks_center_y, Vx, Vy, 'r');
