function lucas_kanade(image1, image2)
% if RGB, transform to grayscale
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
figure, imshow(image2);
hold on;
quiver(region_centers_x, region_centers_y, V(:,:,1), V(:,:,2), 'r');
