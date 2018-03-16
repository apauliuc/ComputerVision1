function plot_matching_points(image1, image2, features_image1, features_image2, matches, no_points)
%PLOT_MATCHING_POINTS Plot the two images and their matched keypoints
%   plot_matching_points(image1, image2, features_image1, features_image2, matches, no_points)
%   - ARGUMENTS
%       image1              First image as matrix
%       image2              Second image as matrix
%       features_image1     Feature points in image1
%       features_image1     Feature points in image2
%       matches             Matched points between images
%       points              Number of points to be displayed

if nargin == 5
    no_points = 50;
end

% select random matched points
perm = randperm(size(matches,2));
points_image1 = features_image1(1:2,matches(1,perm(1:no_points)))';
points_image2 = features_image2(1:2,matches(2,perm(1:no_points)))';

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
title('Matched keypoints between the two images');
hold on
scatter(points_image1_x, points_image1_y, 'filled', 'r', 'LineWidth', 0.1);
scatter(points_image2_x, points_image2_y, 'filled', 'g', 'LineWidth', 0.1);
for i = 1:size(points_image1,1)
    x_coord = [points_image1_x(i), points_image2_x(i)];
    y_coord = [points_image1_y(i), points_image2_y(i)];
    line(x_coord, y_coord, 'color', rand(1,3), 'LineWidth', 1.5);
end

end

