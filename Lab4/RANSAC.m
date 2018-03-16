function [bm1, bm2, bm3, bm4, bt1, bt2] = RANSAC(features_image1, features_image2, matches, N, P, plot_img, image1, image2)
%RANSAC Perform RANSAC algorithm to get best transformation
%   [bm1, bm2, bm3, bm4, bt1, bt2 = RANSAC(features_image1, features_image2, matches, N, P, plot_img, image1, image2)
%   - ARGUMENTS
%       features_image1     Set of detected features in first image
%       features_image2     Set of detected features in second image
%       matches             The matching between features
%       N                   Number of iterations
%       P                   Number of points for initial approximation
%       plot_img            Plot intermediary RANSAC images (true/false)
%       image1              First image as matrix
%       image2              Second image as matrix
%
%   - OUTPUT
%       [m1,m2,m3,m4,t1,t2] Best set of transformation parameters from 
%                           image1 to image2

if nargin == 3
    N = 50;
    P = 3;
    plot_img = false;
end

best_count_inliers = 0;

% get approximation on first P random points, repeating N times
for repeat = 1:N
    % generate random order of points and index them
    perm = randperm(size(matches,2));    
    points_image1 = features_image1(1:2,matches(1,perm));
    points_image2 = features_image2(1:2,matches(2,perm));
    
    % get trasnformation parameters using given equations
    x = compute_transformation_params(points_image1(:,1:P), points_image2(:,1:P));
    [m1, m2, m3, m4, t1, t2] = x{:};  
    
    % transform points from first image and count inliers between
    % transformed points and the given output image
    transformed_points = [m1, m2; m3, m4] * points_image1 + [t1; t2];
    [count_inliers, inliers_set] = detect_count_inliers(transformed_points, points_image2);
    
    % plot matches between feature points in image1 and transformed ones
    if plot_img
        plot_images(image1, image2, points_image1, transformed_points, 50, repeat);
    end
    
    % if the inliers count is the best so far, save the set of inliers
    if count_inliers > best_count_inliers
        best_count_inliers = count_inliers;
        inliers_image1 = points_image1(:,inliers_set);
        inliers_image2 = points_image2(:,inliers_set);
    end
end

% Perform least squares on all resulting inliers and detect again the set
% of inliers
x = compute_transformation_params(inliers_image1, inliers_image2);
[m1, m2, m3, m4, t1, t2] = x{:};
transformed_points = [m1, m2; m3, m4] * points_image1 + [t1; t2];
[~, inliers_set] = detect_count_inliers(transformed_points, points_image2);

% Perform least squares again, on the new set of inliers. Those are the final
% transformation parameters.
inliers_image1 = points_image1(:,inliers_set);
inliers_image2 = points_image2(:,inliers_set);
x = compute_transformation_params(inliers_image1, inliers_image2);
[bm1, bm2, bm3, bm4, bt1, bt2] = x{:};

end

function [x] = compute_transformation_params(points_first_img, points_second_img)
% get A and b matrices
no_points = size(points_first_img,2);
A = zeros(2*no_points, 6);
b = zeros(2*no_points, 1);
for i = 1:no_points
    A(i*2-1,:)      = [points_first_img(:,i)', 0, 0, 1, 0];
    A(i*2,:)        = [0, 0, points_first_img(:,i)', 0, 1];
    b(i*2-1:i*2,1)  = points_second_img(:,i);
end
% compute transformation parameters
x = num2cell(pinv(A)*b);
end

function [count, inliers_set] = detect_count_inliers(new_points, old_points)
% count number of inliers that are not further away than 10 pixels
count = 0;
inliers_set = [];
for idx = 1:size(new_points,2)
    coord = [old_points(:,idx)'; new_points(:,idx)'];
    if pdist(coord, 'euclidean') < 10
        count = count + 1;
        inliers_set = [inliers_set, idx]; %#ok<AGROW>
    end
end
end

function plot_images(image1, image2, points_image1, transformed_points, no_points, repeat)
% select random matched points
perm = randperm(size(points_image1,2));
points_image1 = points_image1(:,perm(1:no_points))';
points_image2 = transformed_points(:,perm(1:no_points))';

% save x,y coordinates for points for easier access
points_image1_x = points_image1(:,1);
points_image1_y = points_image1(:,2);

points_image2_x = points_image2(:,1);
points_image2_y = points_image2(:,2);

% add offset to x coordinates of image 2 for correct displaying
points_image2_x = points_image2_x + size(image1, 2);

% display images side by side with points highlighted and linked by lines
figure;
imshowpair(image1, image2, 'montage');
title(sprintf('Transformed key points on repetition %i', repeat));
hold on
scatter(points_image1_x, points_image1_y, 'filled', 'r', 'LineWidth', 0.1);
scatter(points_image2_x, points_image2_y, 'filled', 'g', 'LineWidth', 0.1);
for idx = 1:size(points_image1,1)
    x_coord = [points_image1_x(idx), points_image2_x(idx)];
    y_coord = [points_image1_y(idx), points_image2_y(idx)];
    line(x_coord, y_coord, 'color', rand(1,3), 'LineWidth', 1.5);
end

end

