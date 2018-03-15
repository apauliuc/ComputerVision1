function plot_matching_points(image1, image2, points_image1, points_image2)
%PLOT_MATCHING_POINTS Plot the two images and their matched keypoints
%   Using the David Lowe's SIFT to match keypoints, we plot the points in
%   two side-by-side images and provide matchings between them.

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
scatter(points_image1_x, points_image1_y, 'filled', 'r');
scatter(points_image2_x, points_image2_y, 'filled', 'r');
for i = 1:size(points_image1,1)
    x_coord = [points_image1_x(i), points_image2_x(i)];
    y_coord = [points_image1_y(i), points_image2_y(i)];
    line(x_coord, y_coord, 'color', rand(1,3), 'linewidth', 1.5);
end

end

