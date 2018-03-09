function tracking (image_set, save_to_gif, file_extension)
% Using Harris Corner Detector, locate feature points and track them in
% a given sequence of images with Lucas-Kanade algorithm
save_file = strcat(image_set, '.gif');
h = figure;

if strcmp(image_set, 'pingpong')
    images_folder = 'pingpong';
    filePattern = fullfile(images_folder, file_extension);
else
    images_folder = 'person_toy';
    filePattern = fullfile(images_folder, file_extension);
end

% read all files in directory that match the pattern
x = zeros(1); y = zeros(1);
images = dir(filePattern);
for k = 1 : length(images)
    base_file_name = images(k).name;
    full_file_name = fullfile(images_folder, base_file_name);
    curr_img = rgb2gray(imread(full_file_name));
    
    if k == 1
        % for the first image, locate feature points
        [x, y] = tracking_locate_points(curr_img);
        
        % display initial image and feature points
        imshow(curr_img);
        hold on; % Prevent image from being blown away.
        plot(x,y,'r+', 'MarkerSize', 20);
        drawnow;
        
        prev_img = curr_img;
        
        % save frame to gif file
        if save_to_gif
            frame = getframe(h);
            im = frame2im(frame);
            [imind,cm] = rgb2ind(im,256);
            imwrite(imind, cm, save_file, 'gif', 'Loopcount', inf, 'DelayTime',0.2);
        end 
    else
        % get velocities and updated points using Lucas-Kanade algorithm
        [V, y, x] = tracking_optical_flow(prev_img, curr_img, y, x, 30);
        
        % display optical flow for current image
        imshow(curr_img);
        hold on;
        quiver(x, y, V(:,1), V(:,2), 'r');
        drawnow;
        
        prev_img = curr_img;
        
        % save frame to gif file
        if save_to_gif
            im = frame2im(getframe(h));
            [imind,cm] = rgb2ind(im,256);
            imwrite(imind, cm, save_file, 'gif', 'WriteMode', 'append', 'DelayTime',0.2);
        end
    end
end
end

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

function [V, points_x, points_y] = tracking_optical_flow(img1, img2, points_x, points_y, window_size)
%TRACKING_OPTICAL_FLOW Apply Lucas-Kanade method to track the interest
%points with coordinates (x,y)
half = round(window_size/2);
pad = half - 1;

% compute partial derivatives in x, y, and t directions
Ix_full = conv2(img1, [-1 1; -1 1], 'same');
Iy_full = conv2(img1, [-1 -1; 1 1], 'same');
It_full = conv2(img1, ones(2), 'same') + conv2(img2, -ones(2), 'same');

V = zeros(size(points_x, 1), 2);

% for each region, take the Ix, Iy and It, compute A, At, b and Vx and Vy
for idx = 1:size(points_x, 1)
    x = round(points_x(idx));
    y = round(points_y(idx));
    
    lower_x = max(x-pad, 1);
    upper_x = min(x+pad, size(img1, 1));
    
    lower_y = max(y-pad, 1);
    upper_y = min(y+pad, size(img1, 2));
    
    % slice matrices to get values for pixels in region
    Ix = Ix_full(lower_x:upper_x, lower_y:upper_y);
    Iy = Iy_full(lower_x:upper_x, lower_y:upper_y);
    It = It_full(lower_x:upper_x, lower_y:upper_y);

    % compute A, At, b
    Ix = Ix(:);
    Iy = Iy(:);
    b = -It(:);
    A = [Ix Iy];

    % compute V = (Vx, Vy) and place in matrix
    v_at_point = pinv(A) * b;

    V(idx, :) = reshape(v_at_point, 1, 2);
    points_x(idx) = points_x(idx) + v_at_point(2);
    points_y(idx) = points_y(idx) + v_at_point(1);
end
end